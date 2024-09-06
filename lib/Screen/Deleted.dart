import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note/Model/note_model.dart';
import 'package:note/Screen/note_card.dart';
import 'package:note/Screen/screen.dart';

class DeletedNotesScreen extends StatefulWidget {
  @override
  _DeletedNotesScreenState createState() => _DeletedNotesScreenState();
}

class _DeletedNotesScreenState extends State<DeletedNotesScreen> {
  final CollectionReference myNotes = FirebaseFirestore.instance.collection('notes');

  Stream<QuerySnapshot> getDeletedNotesStream() {
    return myNotes.where('deleted', isEqualTo: true).snapshots();
  }

  void _restoreNote(String noteId) {
    myNotes.doc(noteId).update({
      'deleted': false,
      'deletedAt': null,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deleted Notes'),
      ),
      body: StreamBuilder(
        stream: getDeletedNotesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final notes = snapshot.data!.docs;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              var note = notes[index];
              var data = note.data() as Map<String, dynamic>?;
              if (data != null) {
                Note noteObject = Note(
                  id: note.id,
                  title: data['title'] ?? "",
                  note: data['note'] ?? "",
                  createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
                  updatedAt: data['updatedAt']?.toDate() ?? DateTime.now(),
                  color: data['color'] ?? 0xFFFFFFFF,
                  archived: data['archived'] ?? false,
                );
                return NoteCard(
                  note: noteObject,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoteScreen(note: noteObject),
                      ),
                    );
                  },
                  onArchive: () {},
                  onDelete: () => _restoreNote(note.id), // Use restore action here
                );
              }
              return const SizedBox.shrink();
            },
            padding: const EdgeInsets.all(10),
          );
        },
      ),
    );
  }
}
