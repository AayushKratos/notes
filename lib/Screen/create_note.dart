 import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:note/Model/note_model.dart';

class NoteCreationScreen extends StatefulWidget {
  final Note note;

  const NoteCreationScreen({required this.note, super.key});

  @override
  State<NoteCreationScreen> createState() => _NoteCreationScreenState();
}

class _NoteCreationScreenState extends State<NoteCreationScreen> {
  late TextEditingController titleController;
  late TextEditingController noteController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note.title);
    noteController = TextEditingController(text: widget.note.note);
  }

  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    super.dispose();
  }

  void saveNote() {
    // Here you would save the note to Firestore, or update it if it already exists
    // For example:
    // FirebaseFirestore.instance.collection('notes').doc(widget.note.id).set({
    //   'title': titleController.text,
    //   'note': noteController.text,
    //   'createdAt': widget.note.createdAt,
    //   'updatedAt': DateTime.now(),
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Note'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              log("................");
              saveNote();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(hintText: 'Title'),
            ),
            SizedBox(height: 10),
            Expanded(
              child: TextField(
                controller: noteController,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(hintText: 'Note'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

 