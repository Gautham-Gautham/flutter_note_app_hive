import 'package:flutter/material.dart';
import 'package:flutter_note_app_hive/Core/Common/CustomTextField/custom_text_field.dart';
import 'package:flutter_note_app_hive/Core/Common/space.dart';
import 'package:flutter_note_app_hive/Core/app_export.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import '../../../Models/note_model.dart';

class NoteEditScreen extends StatefulWidget {
  final Note? note;

  NoteEditScreen({this.note});

  @override
  _NoteEditScreenState createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController =
        TextEditingController(text: widget.note?.content ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    final title = _titleController.text;
    final content = _contentController.text;

    if (title.isNotEmpty || content.isNotEmpty) {
      final notesBox = Hive.box<Note>('notes');
      if (widget.note == null) {
        notesBox.add(Note(
          title: title,
          content: content,
          createdAt: DateTime.now(),
        ));
      } else {
        widget.note!.title = title;
        widget.note!.content = content;
        widget.note!.save();
      }
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'New Note' : 'Edit Note'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: appTheme.mainGreen,
        child: const Icon(Icons.save),
        onPressed: () {
          _saveNote();
        },
      ),
      body: Padding(
        padding: EdgeInsets.only(right: 8.0.h, left: 8.0.h),
        child: Column(
          children: [
            CustomTextField(controller: _titleController, label: "Title"),
            space(h: 30.v),
            // // CustomTextField(
            // //   isRequired: false,
            // //   controller: _contentController,
            // //   label: "Content",
            // // ),
            Expanded(
              child: TextFormField(
                  expands: true,
                  maxLines: null,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    hintText: "Content",
                    hintStyle: GoogleFonts.poppins(
                      color: appTheme.whiteA700,
                    ),
                    floatingLabelStyle: GoogleFonts.poppins(
                        color: appTheme.whiteA700, fontWeight: FontWeight.w400),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade700, width: 1.0),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade700,
                        width: 2.0,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: appTheme.mainGreen,
                        width: 2.0,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0)),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
