import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note/Model/note_model.dart';
import 'package:note/Screen/note_card.dart';
import 'package:note/Screen/screen.dart';

class ArchivedNotesScreen extends StatelessWidget {
  const ArchivedNotesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final CollectionReference myNotes = FirebaseFirestore.instance.collection('notes');
Stream<QuerySnapshot> getArchivedNotesStream() {
  return myNotes.where('archived', isEqualTo: true).snapshots();
}

    return Scaffold(
      appBar: AppBar(
        title: const Text('Archived Notes'),
      ),
      body: StreamBuilder(
        stream: getArchivedNotesStream(),
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
                  onArchive: () {
                    myNotes.doc(noteObject.id).update({'archived': !noteObject.archived});
                  }, onDelete: () {},
                );
              }
              return const SizedBox.shrink();
            },
            padding: const EdgeInsets.all(3),
          );
        },
      ),
    );
  }
}
