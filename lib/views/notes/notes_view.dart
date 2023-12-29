// main UI that the user who logged in can see.
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes4/constants/routes.dart';
import 'package:mynotes4/enums/menu_action.dart';
import 'package:mynotes4/services/auth/auth_service.dart';
import 'package:mynotes4/services/crud/notes_service.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  // notes view grab hold of an instance of notesservice
  late final NotesService _notesService;

  String get userEmail => AuthService.firebase().currentUser!.email!;

// open DB
// Upon going to notesview, our database should be open. that's why notesview is stateful widget
  @override
  void initState() {
    _notesService =
        NotesService(); // _notesservice is an instance of notesservice
    super.initState();
  }

// upon the note view disposal (close), we are going to close DB
  @override
  void dispose() {
    _notesService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(newNoteRoute);
              // you want the user to get back to the main ui after the new note view page.
              // so you should not use pushNamedAndRemoveUntil
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await AuthService.firebase().logOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
                  } // if the user presses cancel, it returns false, if the user presses logout, it returns true.
                // pushNamedAndRemoveUntil() As its name suggests, it pushes a routes on top of the screen. Named means named routes. AndRemoveUntil means if another screen is pushed on the top of the screen, the screen that were already on the top of the screen will be removed
              }
              // devtools.log(value.toString()); // log takes String so you need to covert value to String.
            },
            itemBuilder: (context) {
              // hover your mouse over itemBuilder. You can see itemBuilder is required to return List.
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout, // that's what programmers can see
                  child: Text('Log out'), // that's what users can see
                ), // when popupmenuitem is tapped, it passes value onto popupmenubutton.
              ];
            },
          ), // upon selected (onSelected), it returns value for us.
        ], // actions is a list of widgets.
      ),
      // after getting the user, we need to grab all notes the user has ever created
      body: FutureBuilder(
          future: _notesService.getOrCreateUser(email: userEmail),
          builder: (context, snapshot) {
            // you can use command . to get VS code to help us with missing case clauses.
            // if getting the user or creating the user has been completed, return text in case ConnectionState.done:
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return StreamBuilder(
                  stream: _notesService.allNotes,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        return const Text('Waiting for all notes...');
                      default: // this will be executed if cases above here are not executed.
                        return const CircularProgressIndicator();
                    }
                  },
                );
              default:
                return const CircularProgressIndicator();
            }
          }),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
          // showDialog returns a future of optional value. In other words, it returns a future, and it's optional.
          context: context,
          builder: (context) {
            return AlertDialog(
              // AlertDialog is to create a dialog. showDialog is to display a dialog.
              title: const Text('Sign out'),
              content: const Text('Are you sure you want to sign out?'),
              actions: [
                // actions is a list of TextButtons typically.
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(
                        false); // to close the dialog and pass a boolean value ('false' for cancel and 'true' for logout) to the future.
                    // Navigator is a class that manages a stack of routes and provides methods to navigate between them. A route represents a screen or page in your app, and the stack maintains the order in which screens are displayed.
                  }, // The pop method is used to remove the topmost route from the navigation stack. It effectively closes the current screen or dialog and returns control to the previous screen.
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Log out'),
                )
              ],
            );
          })
      .then((value) =>
          value ??
          false); // .then says if showDialog cannot return bool, i am going to return false; otherwise return the value of showDialog.
  // users may tap outside of the dialog to dissmiss it. This is why showDialogue says I might not be able to return the value that I promised. So, .then is used.
} // dialog is a small popup window that usually displays in the centre of screen.
// In this case, you need the user to select either they want to log out or remain logged in.
// Hence, future boolean is suited for this.
