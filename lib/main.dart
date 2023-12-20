// import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes4/firebase_options.dart';
import 'package:mynotes4/views/login_view.dart';
import 'package:mynotes4/views/register_view.dart';
import 'package:mynotes4/views/verify_email_view.dart';
import 'dart:developer' as devtools show log;
// import statements are configureable. There are many functions that you don't need and you can see all functions by pressing ctrl and space.
// Hence, use as and show to limit the package you import and use functions you actually need.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home:
        const HomePage(), // By changing here, you can see both LoginView and RegistrationView.
    routes: {
      '/login/': (context) =>
          const LoginView(), // this returns the instance of loginview.
      '/register/': (context) => const RegisterView(),
    }, // routes are parameter. it's a map with keys being strings and values being functions. it returns a widget and the function takes buildcontext inside.
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform),
      // FutureBuilder gives you a callback if a future fails.
      // In the callback, FutureBuilder asks you what widget you want to produce for an user depending of the future's result.
      // Firebase.InitializeApp is a future that FutureBuilder performs.
      // If the same user is registered, error occurs. ([ERROR:flutter/runtime/dart_vm_initializer.cc(41)] Unhandled Exception: [firebase_auth/email-already-in-use] The email address is already in use by another account.)
      builder: (context, snapshot) {
        // asyncsnapshot of an object is the state of that object right now. So that object itself is the result of your future. in this case, it's firebaseapp.
        // we don't need firebase app in snapshot; however, one thing you need in this snapshot is its state.
        // a future has a start point, has a line where it processes its information, and has an end point. It either ends successfully or fails.
        // snapshot is your way of getting the results of your future, whether it has started, it is processing, it is done, or it failed.
        // So, you need to tell an user it is loading and the laoding has finished as soon as the snapshot has finished.
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            // if a future is done, this is execute.
            final user =
                FirebaseAuth.instance.currentUser; // get the current user.
            if (user != null) {
              if (user.emailVerified) {
                return const NotesView(); // if the user is not null (i.e., the user is present) and the user is verified, it prints out email is verified.
              } else {
                return const VerifyEmailView(); // if the user is not null and the user is not verified, it returns VerifyEmailView.
              }
            } else {
              return const LoginView(); // if the user is null, it returns LoginView.
            }
          // return const Text('Done'); // Upon the firebase initialisation being done succefully, checks the current user. If the current user is already logged in and verified, it returns done.
          // print(user);
          // if (user?.emailVerified ?? false) {
          //   return const Text('Done');

          //   // this means if the left hand side (user?.emailVerified) is not true, take the right hand side (false).
          // } else {
          //   return const VerifyEmailView();
          //   //  this creates Navigator (class) and tells Navigator to push something on the screen.
          //   // Then we say, create MaterialPageRoute to push.
          //   // MaterialPageRoute has an argument called builder, which expects a widget.
          // }
          // return const LoginView();
          // checks if the current user is logged in.
          // anonymous  users are those who have not come to the website yet.
          // user.emailVerified causes an error because user is a optional user, which means that .currentUser property is a optional user.
          // you can move your mouse over user to see User? that means if firebase cannot calcuate the current user, it returns null. So the user may be null.
          default: // a default is a case that says everything else it hasn't handled.
            return const CircularProgressIndicator();
          // If the user's connection is slow, the loading indicator will be displayed.
        }
      },
    );
    // Builder widget is expected to return some widget. It is like a contract.
    // if the future is done, the text done will be printed out.
    // onPressed is required. onPressed tells Flutter what to do after the button is pressed.)
    // you need to remove scaffold from homepage because loginview has a scafold and is embedded in homepage.
  }
}

enum MenuAction { logout }

// main UI that the user who logged in can see.
class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  devtools.log(shouldLogout.toString());
                  if (shouldLogout) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login/',
                      (_) => false,
                    );
                  } // if the user presses cancel, it returns false, if the user presses logout, it returns true.
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

// named routes vs anonymous routes
// routes are a journey. it has a start view and end view.
// named routes tell Flutter where to go beforehand.
// anonymous routes does not tell Flutter the final destination.

// Git and GitHub
// you need to use these services to store your code.
// What is Git?
// it is a piece of software on your computer to manage changes you made to the codebase.
// git reporsitory is an empty bucket initially. It is like a project folder that contains all files and dictionaries related to your project. It stores the entire history of changes you made to your project.
// you need to tell Git to save a file you want to save. untracked files are files that you have not told Git about it. (git add info.txt)
// commit means you are going to save it in Git. (git commit -m "add new info.txt file for fun")
// What is GitHub?
// GitHub is a cloud service where git repositories are stored.
// If you save your code in Git, nobody else can see and modify it.
// If you want to share your code with other people and want to collaborate with them and want to be able to commit to it in the sourcecode,
// you can share it in GitHub.
// git log
// git status is to display the status of your working direcotry and staging area with respect to the git repository.
// staging area (a.k.a. index) is a middle ground between your working directory and the git repository. You can choose which changes  you want to include in your next commit.
// Use the git add command to stage specific modifications.
// working directory is where you make modifications to your files. You edit, create, or delete files.
// git init . is to make your local repository a git repository
// git add --all is to add all changes to the statging area.
// git commit -m "XYZ" is to create a new commit with a specified commit message.
// git push is used to upload local changes to a remote repository. Hence, Before using git push, you typically set up a remote repository (e.g., on GitHub, GitLab, or Bitbucket) where you want to send your changes.
// git tag is used to create a tag in a Git repository.
// git push --tags is used to push tags from your local Git repository to the remote repository.
// git diff is used to see differences you made. You can scroll down by presssing enter. To quit, press q.
