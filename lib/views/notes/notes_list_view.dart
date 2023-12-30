import 'package:flutter/material.dart';
import 'package:mynotes4/services/crud/notes_service.dart';
import 'package:mynotes4/utilities/dialogs/delete_dialog.dart';

// Render a list of notes.
// create a delete button at the end of notes
// create a delete dialog, are you sure you want to delete?
// Upon pressing yes, we're going to delete the note from the database
// if the notes list view could delegate the deletion task to the notes view, that would be ideal
// the notes list view displays the delete dialog and if the user pressed yes, the notes list view delegate the task back to the parent

// typedef function called DeleteNoteCallback, which is a void function that takes DtabaseNote note.
// this function is called when the user pressed yes in the error dialogue
typedef NoteCallback = void Function(DatabaseNote note);

class NotesListView extends StatelessWidget {
  final List<DatabaseNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;
  const NotesListView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return ListTile(
          onTap: () {
            onTap(note);
          },
          title: Text(
            note.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          // trailing is a property of ListTile that displays a widget at the end (trail) of evry list tile
          trailing: IconButton(
              onPressed: () async {
                final shouldDelete = await showDeleteDialog(context);
                if (shouldDelete) {
                  onDeleteNote(note);
                }
              },
              icon: const Icon(Icons.delete)),
        );
      },
    );
  }
}
