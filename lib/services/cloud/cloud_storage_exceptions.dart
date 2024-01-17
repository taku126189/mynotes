// if you wannt group exceptions into one big exception, it is effective
// to do so, use inheretence

class CloudStorageException implements Exception {
  const CloudStorageException();
}

// Define CouldNotCreateNoteException
// upon you trying to create a note and firebase is unable to create the note, throw an exception
class CouldNotCreateNoteException extends CloudStorageException {}

// CRUD = Create, Read, Update, Delete. This class is R
class CouldNotGetAllNotesException extends CloudStorageException {}

class CouldNotUpdateNoteException extends CloudStorageException {}

class CouldNotDeleteNoteException extends CloudStorageException {}
