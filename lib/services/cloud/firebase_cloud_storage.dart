// firebase cloud storage is a singleton
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes4/services/cloud/cloud_note.dart';
import 'package:mynotes4/services/cloud/cloud_storage_constants.dart';
import 'package:mynotes4/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  // collection reference is like a stream you can read from and you can write to. Stream is only for reading so it is actually not a stream though
  final notes = FirebaseFirestore.instance.collection('notes');

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> updataNote({
    required String documentId,
    required String text,
  }) async {
    try {
      notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

// if you want to use a stream of data as it is evolving (you want to be able to subscribe to all the changes hapenning to it), then you need to use snapshots
// all the changes come inside of Query Snapshot
  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) =>
      notes.snapshots().map((event) => event.docs
          .map((doc) => CloudNote.fromSnapshot(doc))
          .where((note) => note.ownerUserId == ownerUserId));

  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      // where clause
      return await notes
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then(
            (value) => value.docs.map(
              (doc) {
                return CloudNote(
                  documentId: doc.id,
                  ownerUserId: doc.data()[ownerUserIdFieldName] as String,
                  text: doc.data()[textFieldName] as String,
                );
              },
            ),
          );
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  void createNewNote({required String ownerUserId}) async {
    await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });
  }

  // _ means it is private to its library. A private identifier with an underscore can only be accessed within the same Dart lib.
  // in this case, it is a private variable
  // single instance of the class
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();

  // private constructor
  FirebaseCloudStorage._sharedInstance();

  // factory constructor to provide the single instance
  factory FirebaseCloudStorage() => _shared;
}
