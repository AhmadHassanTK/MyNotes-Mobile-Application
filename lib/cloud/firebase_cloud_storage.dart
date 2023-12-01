import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:train/cloud/cloud_note.dart';
import 'package:train/cloud/cloud_storage_constants.dart';
import 'package:train/cloud/cloud_storage_exception.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._shareInstance();
  FirebaseCloudStorage._shareInstance();

  factory FirebaseCloudStorage() => _shared;

  Future<CloudNote> createnote({required String userid}) async {
    final document = await notes.add({
      useridfieldname: userid,
      textfieldname: '',
    });

    final fetchednote = await document.get();
    return CloudNote(
      text: '',
      userid: userid,
      documentid: fetchednote.id,
    );
  }

  Future<Iterable<CloudNote>> getAllNotes({required String userid}) async {
    try {
      return await notes
          .where(
            useridfieldname,
            isEqualTo: userid,
          )
          .get()
          .then(
              (value) => value.docs.map((doc) => CloudNote.fromSnapshot(doc)));
    } catch (e) {
      throw CouldnotGetAllNotesException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String owneruserid}) =>
      notes.snapshots().map((event) => event.docs
          .map((doc) => CloudNote.fromSnapshot(doc))
          .where((note) => note.userid == owneruserid));

  Future<void> updatenote({
    required String documentid,
    required String text,
  }) async {
    try {
      await notes.doc(documentid).update({textfieldname: text});
    } catch (e) {
      throw CouldnotUpdateNoteException();
    }
  }

  Future<void> deletenote({
    required String documentid,
  }) async {
    try {
      await notes.doc(documentid).delete();
    } catch (e) {
      throw CouldnotDeleteNoteException();
    }
  }
}
