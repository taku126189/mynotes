// sqflite is for storage of our data. so you need to import sqflite for flutter to talk with sqflite
// path provider allows us to grab application's documents folder for database storage
// path is imported for us to use join function
// we need to grab current database path
// android, ios, ipad os etc (mobile devices) have their own document directories.
// we are going to get the path of the document directory.
// we are going to join that using path dependency with a name we are going to specify

import 'package:flutter/foundation.dart'; // this is imported for immutable
import 'package:mynotes4/services/crud/crud_exceptions.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class NotesService {
  Database? _db; // to begin with, it is null. this is local database

  // update the notes
  // grab exisisting database and we expect the user to update the text
  Future<DatabaseNote> updateNote(
      {required DatabaseNote note, required String text}) async {
    final db = _getDatabaseOrThrow();

// make sure if the note exists
    await getNote(id: note.id);

// we're updating noteTable
    final updatesCount = await db.update(noteTable, {
      textColumn: text,
      isSyncedWithCloudColumn: 0,
    });

// we make sure note exists in the database, so updatesCount should not be 0
    if (updatesCount == 0) {
      throw CouldNotUpdateNote();
    } else {
      return await getNote(id: note.id);
    }
  }

  // get all notes. we render all notes to the user
  // it should not ask parameter since it returns all notes
  Future<Iterable<DatabaseNote>> getAllNotes() async {
    final db = _getDatabaseOrThrow();
    final notes = await db.query(noteTable);

    return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
  }

  // fetching a specific note
  // we render the list of notes to the main UI that users can see
  // Users tap one of them. So we need to get an ID of the note they tapped and read the information from the database
  Future<DatabaseNote> getNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final notes = await db.query(
      noteTable,
      limit: 1, // we want one note from the database
      where: 'id = ?',
      whereArgs: [id],
    );

// if notes is empty (could not find note with a specific id), throw CouldNotFindNote exception. otherwise, create an instance of DatabaseNote
    if (notes.isEmpty) {
      throw CouldNotFindNote();
    } else {
      return DatabaseNote.fromRow(notes.first);
    }
  }

  // ability to delete all notes
  Future<int> deleteAllNotes() async {
    final db = _getDatabaseOrThrow();
    return await db.delete(noteTable); // this deletes every row inside
  }

  // allow notes to be deleted
  // from noteTable, delete an object that has id = ? and then passing that to something in whereArgs
  // if the note with a specific id does not exist, throw CouldNotDeleteNote exception
  Future<void> deleteNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      noteTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deletedCount == 0) {
      throw CouldNotDeleteNote();
    } else {}
  }

// create new notes and see who is the owner of the note.
// associate the note with the given user (i.e., owner)
  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    final db = _getDatabaseOrThrow();

// calll getUser function to get owner
// make sure owner exists in the database with the correct id
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotFindUser();
    }

    const text = "";

    // create the note
    final noteId = await db.insert(noteTable, {
      userIdColumn: owner.id,
      textColumn: text, // empty text
      isSyncedWithCloudColumn: 1,
    });

    final note = DatabaseNote(
      id: noteId,
      userId: owner.id,
      text: text,
      isSyncedWithCloud: true,
    );

    return note;
  }

// get user given its email
  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDatabaseOrThrow();

// query is about whether the user with a specific email already exists in the database.
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );

// if the user does not exsit, throw CouldNotFindUser exception. Else, return data of first row
    if (results.isEmpty) {
      throw CouldNotFindUser();
    } else {
      return DatabaseUser.fromRow(results.first);
    }
  }

// we are going to issue a query to the database
// query is about whether the user with a specific email already exists in the database.
// if not, throw UserAlreadyExists
  Future<DatabaseUser> createUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isNotEmpty) {
      throw UserAlreadyExists();
    }

    // insert user
    // select table and map
    // .insert gives id back
    final userId = await db.insert(userTable, {
      emailColumn: email.toLowerCase(),
    });

    return DatabaseUser(id: userId, email: email);
  }

// first, check if the database is open. If it is not open, throw an error.
// in order to delete something from sqlite that is managed by sqflite, .delete is used.
// it says delete from userTable as long as email is ?
  Future<void> deleteUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

// this is a prrivate function that reads and writes internal functions in this class.
// every function that reads the database has some code to make sure the database is open. If it is not, throw an error.
// this function is for avoiding creating the same process of getting the current database
  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  Future<void> close() async {
    final db = _db;
    // if the database is not open, anyone should not be able to close it
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      await db.close();
      _db = null; // reset the database after closing it.
    }
  }

  // create the function to open the database.
  // before opening the database, there are a lot of asynchronous things like grabbiing document folder, append it etc.
  // after opening the database, the open function is going to save it somewhere in the database.
  // then other functions grab the database.

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      // this returns Future<Directory> so it needs await on it
      final dbPath = join(docsPath.path, dbName);
      // get the actual path of the database
      // dbName ('notes.db') is going to be joined with actual path of our documents folder
      final db = await openDatabase(dbPath);
      // Future<Database> so it needs await on it
      _db = db;
// create the user table
// createUserTable is sql.
      await db.execute(createUserTable);
// create the note table
      await db.execute(createNoteTable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }
}

@immutable
class DatabaseUser {
  // every user has an id and email
  final int id;
  final String email;

// constructor with required parameters
  const DatabaseUser({
    required this.id,
    required this.email,
  });

// this is a row of inside the user table
// note service we are going to create each row in the user table and pass it to the Databaseuser class
// then the DatabaseClass creates an instance of itself.
  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

// to print out user to debug console. had it was not for this, instance of DatabaseUser would be printed out.
  @override
  String toString() => 'Person, ID = $id, email = $email';

// implement equality. if person X is equal to person Y, read person Y let's say.
// covariant can change the behaviour of your input parameter. parameter of type should be object, but now it is not.
  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseNote {
  final int id;
  final userId;
  final String text;
  final bool isSyncedWithCloud;

  DatabaseNote({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncedWithCloud,
  });

// initialization of DatabaseNote
  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String,
        isSyncedWithCloud =
            (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

  @override
  String toString() =>
      'Note, ID = $id, userId = $userId, isSyncedWithCloud = $isSyncedWithCloud';

  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const dbName = 'notes.db'; // the file under which the data is saved.
const noteTable = 'note';
const userTable = 'user';
const idColumn = 'id';
const emailColumn = 'email';
const userIdColumn = 'user_id';
const textColumn = 'text';
const isSyncedWithCloudColumn = 'is_synced_with_cloud';
// create the user table
// by using three quotation marks you can put anything in it.
// IF NOT EXISTS is added. if you create the user table even though it has already been created before, it is going to create an error. So you need IF NOT EXISTS
const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
        "id"	INTEGER NOT NULL,
        "email"	TEXT NOT NULL UNIQUE,
        PRIMARY KEY("id" AUTOINCREMENT)
      );
      ''';
const createNoteTable = '''CREATE TABLE IF NOT EXISTS "note" (
        "id"	INTEGER NOT NULL,
        "user_id"	INTEGER NOT NULL,
        "text"	TEXT,
        "is_synced_with_cloud"	INTEGER DEFAULT 0,
        PRIMARY KEY("id" AUTOINCREMENT),
        FOREIGN KEY("user_id") REFERENCES "user"("id")
      );
      ''';
