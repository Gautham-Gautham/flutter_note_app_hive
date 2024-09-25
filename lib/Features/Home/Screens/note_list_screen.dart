import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_note_app_hive/Core/Common/CustomTextField/custom_text_field.dart';
import 'package:flutter_note_app_hive/Core/Theme/new_custom_text_style.dart';
import 'package:flutter_note_app_hive/Core/Utils/snackbar_dialogs.dart';
// import 'package:flutter_note_app_hive/Core/Theme/theme_helper.dart';
import 'package:flutter_note_app_hive/Core/app_export.dart';
import 'package:flutter_note_app_hive/Features/Authentication/Screens/login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Models/note_model.dart';
import 'note_edit_screen.dart';

final noteList = StateProvider<List<Note>>(
  (ref) => [],
);

class NoteListScreen extends ConsumerStatefulWidget {
  const NoteListScreen({super.key});

  @override
  ConsumerState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends ConsumerState<NoteListScreen> {
  late Box<Note> notesBox;
  final _searchController = TextEditingController();

  // List<Note> filteredNotes = [];
  String searchQuery = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
    notesBox = Hive.box<Note>('notes');
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        ref.read(noteList.notifier).update(
              (state) => notesBox.values.toList(),
            );
      },
    );
    // filteredNotes = notesBox.values.toList();
  }

  void _filterNotes(String query) {
    // setState(() {
    searchQuery = query;

    ref.read(noteList.notifier).update(
      (state) {
        final res = notesBox.values
            .where((note) =>
                note.title.toLowerCase().contains(query.toLowerCase()) ||
                note.content.toLowerCase().contains(query.toLowerCase()))
            .toList();
        return res;
      },
    );
    ;
  }

  Future<void> logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear().then(
      (value) async {
        await _auth.signOut();
        await _googleSignIn.signOut();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ));
      },
    );
  }

  void _deleteNote(Note note) {
    note.delete();
    ref.read(noteList.notifier).update(
      (state) {
        final res = state;
        res.remove(note);
        return res;
      },
    );
  }

  String truncateSentence(String sentence, int length) {
    if (sentence.length > length) {
      return "${sentence.substring(0, length)}...";
    } else {
      return sentence; // Show full sentence if it's shorter than 30 characters
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Notes',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final isOk = await alert(
                  context, "Do You Want To Logout!!!", QuickAlertType.warning);
              if (isOk) {
                logOut();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomTextField(
              controller: _searchController,
              label: "Search",
              onChanged: _filterNotes,
              prefixIcon: const Icon(Icons.search),
            ),
          ),
          Consumer(
            builder: (context, refNote, child) {
              final resNotes = refNote.watch(noteList);
              return Expanded(
                child: ValueListenableBuilder(
                  valueListenable: notesBox.listenable(),
                  builder: (context, Box<Note> box, _) {
                    if (resNotes.isNotEmpty) {
                      return ListView.builder(
                        itemCount: resNotes.length,
                        itemBuilder: (context, index) {
                          final note = resNotes[index];
                          return ListTile(
                            title: Text(
                              note.title,
                              style: CustomPoppinsTextStyles.bodyText1,
                            ),
                            subtitle: Text(
                              truncateSentence(note.content, 52 + 17),
                              style: CustomPoppinsTextStyles.bodyMedium,
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                final isOk = await alert(
                                    context,
                                    "Do you want to delete this note?",
                                    QuickAlertType.error);
                                if (isOk) {
                                  _deleteNote(note);
                                }
                              },
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NoteEditScreen(note: note),
                                ),
                              );
                            },
                          );
                        },
                      );
                    } else {
                      return SizedBox(
                        // color: Colors.red,
                        height: SizeUtils.height * 0.4,
                        width: SizeUtils.width,
                        child: Center(
                          child: Text(
                            'No Notes',
                            style: GoogleFonts.poppins(),
                          ),
                        ),
                      );
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: appTheme.mainGreen,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NoteEditScreen(),
            ),
          );
        },
      ),
    );
  }
}
