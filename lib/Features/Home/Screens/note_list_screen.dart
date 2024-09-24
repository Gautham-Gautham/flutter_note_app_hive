import 'package:flutter/material.dart';
import 'package:flutter_note_app_hive/Core/Common/CustomTextField/custom_text_field.dart';
import 'package:flutter_note_app_hive/Core/Theme/new_custom_text_style.dart';
// import 'package:flutter_note_app_hive/Core/Theme/theme_helper.dart';
import 'package:flutter_note_app_hive/Core/app_export.dart';
import 'package:flutter_note_app_hive/Features/Authentication/Screens/login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

    // filteredNotes = notesBox.values
    //     .where((note) =>
    //         note.title.toLowerCase().contains(query.toLowerCase()) ||
    //         note.content.toLowerCase().contains(query.toLowerCase()))
    //     .toList();
    // });
  }

  void _deleteNote(Note note) {
    note.delete();
    // setState(() {
    ref.read(noteList.notifier).update(
      (state) {
        final res = state;
        res.remove(note);
        return res;
      },
    );

    // });
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
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CustomTextField(
              controller: _searchController,
              label: "Search",
              onChanged: _filterNotes,
              prefixIcon: Icon(Icons.search),
            ),
            // child: TextField(
            //   onChanged: _filterNotes,
            //   decoration: InputDecoration(
            //     labelText: 'Search',
            //     prefixIcon: Icon(Icons.search),
            //   ),
            // ),
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
                              style: CustomPoppinsTextStyles.buttonText,
                            ),
                            subtitle: Text(
                              note.content,
                              style: CustomPoppinsTextStyles.bodyText1White,
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _deleteNote(note),
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
