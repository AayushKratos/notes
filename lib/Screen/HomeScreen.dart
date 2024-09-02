import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note/Model/note_model.dart';
import 'package:note/Screen/note_card.dart';
import 'package:note/Screen/screen.dart';

class NotesHomeScreen extends StatefulWidget {
  const NotesHomeScreen({super.key});

  @override
  State<NotesHomeScreen> createState() => _NotesHomeScreenState();
}

class _NotesHomeScreenState extends State<NotesHomeScreen> {
  final CollectionReference myNotes =
      FirebaseFirestore.instance.collection('notes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Notes App",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
        ),
      ),
      body: ListView(
        children: [
          StreamBuilder(
              stream: myNotes.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final notes = snapshot.data!.docs;
                List<NoteCard> noteCards = [];
                for (var note in notes) {
                  var data = note.data() as Map<String, dynamic>?;
                  if (data != null) {
                    Note noteObject = Note(
                      id: note.id,
                      title: note['title'] ?? "",
                      note: data['note'] ?? "",
                      createdAt: data.containsKey('createdAt')
                          ? (data['createdAt'] as Timestamp).toDate()
                          : DateTime.now(),
                      updatedAt: data.containsKey('updatedAt')
                          ? (data['updatedAt'] as Timestamp).toDate()
                          : DateTime.now(),
                      color: data.containsKey('color')
                          ? data['color']
                          : 0xFFFFFFFF,
                    );
                    noteCards.add(
                      NoteCard(
                        note: noteObject,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  NoteScreen(note: noteObject),
                            ),
                          );
                        },
                      ),
                    );
                  }
                }
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: noteCards.length,
                  itemBuilder: (context, index) {
                    return noteCards[index];
                  },
                  padding: EdgeInsets.all(3),
                );
              })
        ],
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
                            updatedAt: DateTime.now()),
                      )));
        },
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
