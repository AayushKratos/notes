import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note/Model/note_model.dart';

class NoteScreen extends StatefulWidget {
  final Note note;
  const NoteScreen({super.key, required this.note});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final CollectionReference myNotes =
      FirebaseFirestore.instance.collection('notes');
  late TextEditingController titleController;
  late TextEditingController noteController;
  late Note note;
  String titleString = '';
  String noteString = '';
  late int color;

  void initState() {
    super.initState();
    note = widget.note;
    titleString = note.title;
    noteString = note.note;
    color = note.color == 0xFFFFFFFF ? generateRandomLightColor() : note.color;
    titleController = TextEditingController(text: titleString);
    noteController = TextEditingController(text: noteString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey),
                  child: BackButton(
                    color: Colors.white,
                  ),
                ),
                Text(
                  note.id.isEmpty ? 'Add note' : 'Edit note',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          saveNotes();
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                      ),
                      if (note.id.isNotEmpty)
                        IconButton(
                          onPressed: () {
                            myNotes.doc(note.id).delete();
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                )
              ],
            ),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: "Note Title"),
              onChanged: (value) {
                titleString = value;
              },
            ),
            Expanded(
              child: TextField(
                controller: noteController,
                maxLines: null,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: "Note Content"),
                onChanged: (value) {
                  noteString = value;
                },
              ),
            ),
          ],
        ),
      )),
    );
  }

  void saveNotes() async {
    DateTime now = DateTime.now();
    if (note.id.isEmpty) {
      await myNotes.add({
        'title': titleString,
        'note': noteString,
        'color': color,
        'createdAt': now,
        'archived': false,
      });
    } else {
      await myNotes.doc(note.id).update({
        'title': titleString,
        'note': noteString,
        'color': color,
        'updatedAt': now,
      });
    }
  }
}
