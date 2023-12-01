import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:train/Auth/Auth_services.dart';
import 'package:train/Dialogs/CannotshareDialog.dart';
import 'package:train/cloud/cloud_note.dart';
import 'package:train/cloud/firebase_cloud_storage.dart';
import 'package:train/extensions/get_arguments.dart';

class Newnote extends StatefulWidget {
  const Newnote({super.key});

  @override
  State<Newnote> createState() => _NewnoteState();
}

class _NewnoteState extends State<Newnote> {
  CloudNote? _note;
  late final FirebaseCloudStorage _noteservice;
  late final TextEditingController _textController;

  void _setlistner() {
    _textController.removeListener(_textcontrollerlistner);
    _textController.addListener(_textcontrollerlistner);
  }

  @override
  void initState() {
    _noteservice = FirebaseCloudStorage();
    _textController = TextEditingController();
    super.initState();
  }

  void _textcontrollerlistner() async {
    final note = _note;

    if (note == null) {
      return;
    }
    final text = _textController.text;
    print(text);
    await _noteservice.updatenote(documentid: note.documentid, text: text);
  }

  Future<CloudNote> createORupdatenote(BuildContext context) async {
    final widgetnote = context.getArguments<CloudNote>();

    if (widgetnote != null) {
      _note = widgetnote;
      _textController.text = widgetnote.text;
      return widgetnote;
    }
    final existingnote = _note;
    if (existingnote != null) {
      print('the existingnote is $existingnote');
      return existingnote;
    }
    final currentuser = Authservices.firebase().currentuser!;
    final currentuserid = currentuser.id;
    final note = await _noteservice.createnote(userid: currentuserid);
    print('the  new note is $note');
    return note;
  }

  void _deleteEmptyNote() async {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      await _noteservice.deletenote(documentid: note.documentid);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    if (_textController.text.isNotEmpty && note != null) {
      await _noteservice.updatenote(
        documentid: note.documentid,
        text: _textController.text,
      );
    }
  }

  @override
  void dispose() {
    _deleteEmptyNote();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New note'),
        actions: [
          IconButton(
            onPressed: () async {
              if (_textController.text.isEmpty || _note == null) {
                await cannotShareNoteDialog(context);
              } else {
                Share.share(_textController.text);
              }
            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: FutureBuilder(
        future: createORupdatenote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _note = snapshot.data;
              _setlistner();
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      autofocus: true,
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: 'Start typing your notes',
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _textController.clear();
                      },
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              );

            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
