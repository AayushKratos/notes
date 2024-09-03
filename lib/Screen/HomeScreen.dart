import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note/Model/note_model.dart';
import 'package:note/Screen/archive.dart';
import 'package:note/Screen/note_card.dart';
import 'package:note/Screen/screen.dart'; // Make sure you have this import

class NotesHomeScreen extends StatefulWidget {
  const NotesHomeScreen({super.key});

  @override
  State<NotesHomeScreen> createState() => _NotesHomeScreenState();
}

class _NotesHomeScreenState extends State<NotesHomeScreen> {
  final CollectionReference myNotes =
      FirebaseFirestore.instance.collection('notes');

  Stream<QuerySnapshot> getNotesStream() {
    return myNotes.where('archived', isEqualTo: false).snapshots();
  }

  signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void _archiveNote(String noteId) {
    myNotes.doc(noteId).update({'archived': true});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.archive),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ArchivedNotesScreen(), // Implement this screen
                ),
              );
            },
          ),
          SizedBox(width: 16),
          IconButton(
              onPressed: () => signOut(), icon: Icon(Icons.login_rounded))
        ],
      ),
      body: StreamBuilder(
        stream: getNotesStream(),
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
                        builder: (context) => NoteScreen(
                            note: noteObject), // Implement NoteScreen
                      ),
                    );
                  },
                  onArchive: () => _archiveNote(note.id),
                );
              }
              return const SizedBox.shrink();
            },
            padding: const EdgeInsets.all(10),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteScreen(
                note: Note(
                  id: '',
                  title: '',
                  note: '',
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                ),
              ),
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
