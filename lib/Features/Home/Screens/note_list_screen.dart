import 'package:flutter/material.dart';
import 'package:flutter_note_app_hive/Core/Common/CustomTextField/custom_text_field.dart';
import 'package:flutter_note_app_hive/Core/Theme/new_custom_text_style.dart';
import 'package:flutter_note_app_hive/Core/Theme/theme_helper.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../Models/note_model.dart';
import 'note_edit_screen.dart';

class NoteListScreen extends StatefulWidget {
  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  late Box<Note> notesBox;
  final _searchController = TextEditingController();

  List<Note> filteredNotes = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    notesBox = Hive.box<Note>('notes');
    filteredNotes = notesBox.values.toList();
  }

  void _filterNotes(String query) {
    setState(() {
      searchQuery = query;
      filteredNotes = notesBox.values
          .where((note) =>
              note.title.toLowerCase().contains(query.toLowerCase()) ||
              note.content.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _deleteNote(Note note) {
    note.delete();
    setState(() {
      filteredNotes.remove(note);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Notes'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/login');
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
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: notesBox.listenable(),
              builder: (context, Box<Note> box, _) {
                return ListView.builder(
                  itemCount: filteredNotes.length,
                  itemBuilder: (context, index) {
                    final note = filteredNotes[index];
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
                            builder: (context) => NoteEditScreen(note: note),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
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
