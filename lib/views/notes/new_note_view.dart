import 'package:flutter/material.dart';
import 'package:mynotes4/services/auth/auth_service.dart';
import 'package:mynotes4/services/crud/notes_service.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({super.key});

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  DatabaseNote? _note;
  late final NotesService _notesService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _notesService = NotesService();
    _textController = TextEditingController();
    super.initState();
  }

// we need to constantly update the infomation the user put. so we need a listner
// if the current note exists, take the note and update it in the database
// whenever text changes, call this function
  void _textControllerListner() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _notesService.updateNote(
      note: note,
      text: text,
    );
  }

// remove this listener (_textControllerListner) from the text editing controller if it has already been added and then add it
  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListner);
    _textController.addListener(_setupTextControllerListener);
  }

// if we have create the note, we don't have to create it again.
// if we haven't created the note, go to the note service and say create the note and then get the note back to us
  Future<DatabaseNote> createNewNote() async {
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }

    // createNote requires an owner
    // upon going to the main UI, the notes view creates a new user in the database
    // you've logged in the firebase, you go to the notes view, and then the notes view creates the new user.
    // so we need to retrieve it from the database
    // ! expects that the result of uthService.firebase().currentUser is non-nullable.
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _notesService.getUser(email: email);
    return await _notesService.createNote(owner: owner);
  }

// when the user goes to the new notes view and not enter any text (when the notes view is diposed), delete the note
  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _notesService.deleteNote(id: note.id);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    if (note != null && text.isNotEmpty) {
      await _notesService.updateNote(
        note: note,
        text: text,
      );
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('New Note'),
        ),
        // when the new note has been created in the database,
        body: FutureBuilder(
          future: createNewNote(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                // assign   DatabaseNote? _note; to our note variable
                // this is how we get notes from snapshot
                _note = snapshot.data as DatabaseNote;
                _setupTextControllerListener();
                // TextField send a message to an object called a text editing controller and say hey my text has been changed
                return TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Start typing your note...',
                  ),
                );
              default:
                return const CircularProgressIndicator();
            }
          },
        ));
  }
}
