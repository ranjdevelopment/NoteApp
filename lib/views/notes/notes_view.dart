import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;
import 'package:learning_flutter/constants/routes.dart';
import 'package:learning_flutter/extension/buildcontext/loc.dart';
import 'package:learning_flutter/services/auth/bloc/auth_bloc.dart';
import 'package:learning_flutter/services/auth/bloc/auth_event.dart';
import 'package:learning_flutter/services/cloud/cloud_note.dart';
import 'package:learning_flutter/services/cloud/firebase_cloud_storage.dart';
import 'package:learning_flutter/views/notes/notes_list_view.dart';
import '../../enums/menu_action.dart';
import '../../services/auth/auth_service.dart';
import '../../utilities/dialogs/logout_dialog.dart';

extension Count<T extends Iterable> on Stream<T> {
  Stream<int> get getLength => map((event) => event.length);
}

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _noteService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _noteService = FirebaseCloudStorage();
    //  _noteService.open();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 17.0,
        backgroundColor: Colors.green,
        title: StreamBuilder(
            stream: _noteService.allNotes(ownerUserId: userId).getLength,
            builder: (context, AsyncSnapshot<int> snapshot) {
              if (snapshot.hasData) {
                final noteCount = snapshot.data ?? 0;
                final text = context.loc.notes_title(noteCount);
                return Text(text);
              } else {
                return const Text('');
              }
            }),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          PopupMenuButton(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogOut = await showLogOutDialog(context);
                  if (shouldLogOut) {
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );
                  }
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: MenuAction.logout,
                  child: Text(context.loc.logout_button),
                )
              ];
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _noteService.allNotes(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNote = snapshot.data as Iterable<CloudNote>;
                return NotesListView(
                  notes: allNote,
                  onDeleteNote: (note) async {
                    await _noteService.deleteNote(documentId: note.documentId);
                  },
                  onTab: (note) {
                    Navigator.of(context).pushNamed(
                      createOrUpdateNoteRoute,
                      arguments: note,
                    );
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
