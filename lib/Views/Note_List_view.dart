import 'package:flutter/material.dart';
import 'package:train/Dialogs/DeleteDialog.dart';
import 'package:train/cloud/cloud_note.dart';

typedef NoteCallBack = void Function(CloudNote note);

class NoteList extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallBack ondelete;
  final NoteCallBack onTap;

  const NoteList({
    super.key,
    required this.notes,
    required this.ondelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes.elementAt(index);
        return ListTile(
          onTap: () {
            onTap(note);
          },
          title: Text(
            note.text,
          ),
          trailing: IconButton(
            onPressed: () async {
              final flag = await deleteDialog(context);
              if (flag) {
                ondelete(note);
              }
            },
            icon: const Icon(Icons.delete),
          ),
        );
      },
    );
  }
}
