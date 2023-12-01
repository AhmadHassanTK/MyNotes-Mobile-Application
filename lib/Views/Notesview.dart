import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:train/Auth/Auth_services.dart';
import 'package:train/Auth/Bloc/Auth_Bloc.dart';
import 'package:train/Auth/Bloc/Bloc_Event.dart';
import 'package:train/Views/Note_List_view.dart';
import 'package:train/Dialogs/logoutdialog.dart';
import 'package:train/cloud/cloud_note.dart';
import 'package:train/cloud/firebase_cloud_storage.dart';
import 'package:train/enum/menuaction.dart';
import 'package:train/routes/routes.dart';
import 'dart:developer' as x show log;

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => NotesPageState();
}

class NotesPageState extends State<NotesPage> {
  String get userid => Authservices.firebase().currentuser!.id;
  late final FirebaseCloudStorage noteservice;

  @override
  void initState() {
    noteservice = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Notes Page'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(newnoteroute);
              },
              icon: const Icon(Icons.add),
            ),
            PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final temp = await logoutdialog(context);
                    x.log(temp.toString());
                    if (temp) {
                      context.read<AuthBloc>().add(const AuthLogOutEvent());
                    }
                    break;
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem<MenuAction>(
                      value: MenuAction.logout, child: Text('Logout')),
                ];
              },
            ),
          ],
        ),
        body: StreamBuilder(
          stream: noteservice.allNotes(owneruserid: userid),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return const Center(child: Text('Your notes are empty'));
                  } else {
                    final allnotes = snapshot.data as Iterable<CloudNote>;
                    print('allnotes is $allnotes');
                    return NoteList(
                      notes: allnotes,
                      ondelete: (note) async {
                        await noteservice.deletenote(
                            documentid: note.documentid);
                      },
                      onTap: (note) {
                        Navigator.of(context).pushNamed(
                          newnoteroute,
                          arguments: note,
                        );
                      },
                    );
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }

              default:
                return const Center(child: Text('loading'));
            }
          },
        ));
  }
}
