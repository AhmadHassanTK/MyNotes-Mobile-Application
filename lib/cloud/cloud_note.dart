import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:train/cloud/cloud_storage_constants.dart';

class CloudNote {
  final String text;
  final String userid;
  final String documentid;

  CloudNote({
    required this.text,
    required this.userid,
    required this.documentid,
  });

  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : text = snapshot.data()[textfieldname] as String,
        documentid = snapshot.id,
        userid = snapshot.data()[useridfieldname];
}
