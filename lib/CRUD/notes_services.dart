// import 'dart:async';
// import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart'
//     show MissingPlatformDirectoryException, getApplicationDocumentsDirectory;
// import 'package:path/path.dart' show join;
// import 'package:train/Exceptions/CRUD_Exceptions.dart';
// import 'package:train/extensions/filter.dart';

// class Noteservice {
//   Database? _db;
//   DatabaseUser? _user;

//   List<DatabaseNotes> _notes = [];

//   static final Noteservice _shared = Noteservice._shareInstance();
//   Noteservice._shareInstance() {
//     _notesStreamController = StreamController<List<DatabaseNotes>>.broadcast(
//       onListen: () {
//         _notesStreamController.sink.add(_notes);
//       },
//     );
//   }

//   factory Noteservice() => _shared;

//   late final StreamController<List<DatabaseNotes>> _notesStreamController;

//   Stream<List<DatabaseNotes>> get allnotes =>
//       _notesStreamController.stream.filter((note) {
//         final currentuser = _user;
//         if (currentuser != null) {
//           return note.userId == currentuser.id;
//         } else {
//           throw TheUserisNotSettedException;
//         }
//       });

//   Future<void> ensureDBisopen() async {
//     try {
//       if (_db!.isOpen == true) {
//         // print('already open');
//         return;
//       } else {
//         await open();
//         print('database is open at create note');
//       }
//     } on NotconnectedDBException {
//       //
//     }
//   }

//   Future<DatabaseUser> getORcreateUser({
//     required String email,
//     bool setuser = true,
//   }) async {
//     try {
//       final user = await getuser(email: email);
//       if (setuser) {
//         _user = user;
//       }
//       print('_user is $_user');
//       return user;
//     } on UserNotFoundException {
//       final newuser = await createuser(email: email);
//       if (setuser) {
//         _user = newuser;
//       }
//       print('new user created $newuser');
//       return newuser;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<void> _cacheNotes() async {
//     final allnotes = await getallnotes();
//     _notes = allnotes.toList();
//     _notesStreamController.add(_notes);
//   }

//   Database getDatabase() {
//     final db = _db;
//     if (db == null) {
//       throw NotconnectedDBException();
//     } else {
//       return db;
//     }
//   }

//   Future<void> open() async {
//     if (_db != null) {
//       throw ConnectedDBException();
//     }
//     try {
//       final dbpath = await getApplicationDocumentsDirectory();
//       final finalpath = join(dbpath.path, dbname);
//       final db = await openDatabase(finalpath);
//       _db = db;

//       const createusertable = '''CREATE TABLE IF NOT EXISTS "user" (
// 	    "id"	INTEGER NOT NULL,
// 	    "email"	TEXT NOT NULL UNIQUE,
//      	PRIMARY KEY("id" AUTOINCREMENT)
//      );''';

//       const createnotestable = '''CREATE TABLE IF NOT EXISTS "note" (
// 	    "id"	INTEGER NOT NULL,
// 	    "user_id"	INTEGER NOT NULL,
// 	    "text"	TEXT,
// 	    "is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
// 	    FOREIGN KEY("user_id") REFERENCES "user"("id"),
// 	    PRIMARY KEY("id" AUTOINCREMENT)
//     );''';

//       await _db?.execute(createusertable);
//       await _db?.execute(createnotestable);
//       await _cacheNotes();
//     } on MissingPlatformDirectoryException {
//       throw UnabletofinddirectoryException();
//     }
//   }

//   Future<void> close() async {
//     final db = _db;
//     if (_db == null) {
//       throw NotconnectedDBException();
//     } else {
//       await db?.close();
//       _db = null;
//     }
//   }

//   Future<void> deleteuser({required String email}) async {
//     await ensureDBisopen();
//     final db = getDatabase();

//     int deletecount = await db.delete(usertable,
//         where: 'email = ?', whereArgs: [email.toLowerCase()]);

//     if (deletecount != 1) {
//       throw CouldnotdeletethatuserException();
//     }
//   }

//   Future<DatabaseUser> createuser({required String email}) async {
//     await ensureDBisopen();
//     final db = getDatabase();
//     final usercheck = await db.query(
//       usertable,
//       limit: 1,
//       where: 'email =?',
//       whereArgs: [email.toLowerCase()],
//     );

//     if (usercheck.isNotEmpty) {
//       throw UserAlreadyFoundException();
//     }

//     final newuser = await db.insert(usertable, {
//       emailColumn: email.toLowerCase(),
//     });

//     return DatabaseUser(
//       id: newuser,
//       email: email,
//     );
//   }

//   Future<DatabaseUser> getuser({required String email}) async {
//     await ensureDBisopen();
//     final db = getDatabase();
//     final usercheck = await db.query(
//       usertable,
//       limit: 1,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//     if (usercheck.isEmpty) {
//       print('user not found');
//       throw UserNotFoundException();
//     } else {
//       return DatabaseUser.fromRow(usercheck.first);
//     }
//   }

//   Future<DatabaseNotes> createnote({required DatabaseUser owner}) async {
//     await ensureDBisopen();
//     final db = getDatabase();

//     final getowner = await getuser(email: owner.email);

//     if (getowner != owner) {
//       throw UserNotFoundException();
//     }
//     const text = '';
//     final newnoteid = await db.insert(notestable, {
//       userIdColumn: owner.id,
//       textcolumn: text,
//       isSyncedWithCloudColumn: 1,
//     });

//     final note = DatabaseNotes(
//         id: newnoteid, userId: owner.id, text: text, isSyncedWithCloud: true);

//     print('notes array is $_notes');
//     _notes.add(note);
//     _notesStreamController.add(_notes);

//     return note;
//   }

//   Future<void> deletenote({required int id}) async {
//     await ensureDBisopen();
//     final db = getDatabase();
//     final count = await db.delete(notestable, where: 'id = ?', whereArgs: [id]);

//     if (count == 0) {
//       throw NoteDeleteFailedException();
//     } else {
//       _notes.removeWhere((note) => note.id == id);
//       _notesStreamController.add(_notes);
//     }
//   }

//   Future<int> deleteallnotes() async {
//     final db = getDatabase();
//     final count = await db.delete(notestable);
//     _notes = [];
//     _notesStreamController.add(_notes);
//     return count;
//   }

//   Future<DatabaseNotes> getnote({required int id}) async {
//     await ensureDBisopen();
//     final db = getDatabase();
//     final notes = await db.query(
//       notestable,
//       limit: 1,
//       where: 'id=?',
//       whereArgs: [id],
//     );

//     if (notes.isEmpty) {
//       throw NoteNotFoundException();
//     } else {
//       final note = DatabaseNotes.fromRow(notes.first);
//       _notes.removeWhere((note) => note.id == id);
//       _notes.add(note);
//       _notesStreamController.add(_notes);
//       return note;
//     }
//   }

//   Future<Iterable<DatabaseNotes>> getallnotes() async {
//     await ensureDBisopen();
//     final db = getDatabase();
//     final allnotes = await db.query(notestable);

//     final notes = allnotes.map((n) => DatabaseNotes.fromRow(n));
//     return notes;
//   }

//   Future<DatabaseNotes> updatenote({
//     required DatabaseNotes note,
//     required String text,
//   }) async {
//     final db = getDatabase();
//     final updated = await db.update(
//       notestable,
//       {textcolumn: text, isSyncedWithCloudColumn: 0},
//       where: 'id = ?',
//       whereArgs: [note.id],
//     );

//     if (updated == 0) {
//       throw CouldnotupdatenoteException();
//     } else {
//       final updatednote = await getnote(id: note.id);
//       _notes.removeWhere((note) => updatednote.id == note.id);
//       _notes.add(updatednote);
//       _notesStreamController.add(_notes);
//       return updatednote;
//     }
//   }
// }

// class DatabaseUser {
//   final int id;
//   final String email;

//   DatabaseUser({
//     required this.id,
//     required this.email,
//   });

//   DatabaseUser.fromRow(Map<String, Object?> map)
//       : id = map[idcolumn] as int,
//         email = map[emailColumn] as String;

//   @override
//   String toString() => 'person : Id = $id , Email = $email';

//   @override
//   bool operator ==(covariant DatabaseUser other) => id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }

// class DatabaseNotes {
//   final int id;
//   final int userId;
//   final String text;
//   final bool isSyncedWithCloud;

//   DatabaseNotes({
//     required this.id,
//     required this.userId,
//     required this.text,
//     required this.isSyncedWithCloud,
//   });

//   DatabaseNotes.fromRow(Map<String, Object?> map)
//       : id = map[idcolumn] as int,
//         userId = map[userIdColumn] as int,
//         text = map[textcolumn] as String,
//         isSyncedWithCloud =
//             (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

//   @override
//   String toString() =>
//       'Notes : id = $id , UserId = $userId , NotesText = $text ,isSyncedWithCloud = $isSyncedWithCloud ';

//   @override
//   bool operator ==(covariant DatabaseNotes other) => id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }

// const dbname = 'testing.db';
// const notestable = 'note';
// const usertable = 'user';
// const idcolumn = 'id';
// const emailColumn = 'email';
// const userIdColumn = 'user_id';
// const textcolumn = 'text';
// const isSyncedWithCloudColumn = 'is_synced_with_cloud';
