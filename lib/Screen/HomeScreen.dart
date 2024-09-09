import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note/Model/note_model.dart';
import 'package:note/Screen/archive.dart';
import 'package:note/Screen/deleted.dart';
import 'package:note/Screen/note_card.dart';
import 'package:note/Screen/screen.dart';
import 'package:note/services/database_services.dart';

class NotesHomeScreen extends StatefulWidget {
  const NotesHomeScreen({super.key});

  @override
  State<NotesHomeScreen> createState() => _NotesHomeScreenState();
}

class _NotesHomeScreenState extends State<NotesHomeScreen> {

  final  DatabaseServices _databaseServices = DatabaseServices.instance;
  final CollectionReference myNotes =
      FirebaseFirestore.instance.collection('notes');
  User? user;
  String? profilePicUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        user = currentUser;
        profilePicUrl = user?.photoURL; 
      });
    }
  }

  Stream<QuerySnapshot> getNotesStream() {
    return myNotes
        .where('archived', isEqualTo: false)
        .where('deleted', isEqualTo: false)
        .snapshots();
  }

  signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void _archiveNote(String noteId) {
    myNotes.doc(noteId).update({'archived': true});
  }

  void _deleteNote(String noteId) {
    myNotes.doc(noteId).update({
      'deleted': true,
      'deletedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes App'),
        actions: [
          SizedBox(width: 16),
          PopupMenuButton<String>(
            icon: CircleAvatar(
              backgroundImage: profilePicUrl != null
                  ? NetworkImage(profilePicUrl!)
                  : AssetImage('assets/default_profile_pic.png') as ImageProvider, // Fallback image
              radius: 16,
            ),
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
            onSelected: (value) { if (value == 'logout') {
                signOut();
              }
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Notes App',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.archive),
              title: Text('Archived Notes'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArchivedNotesScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Deleted Notes'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DeletedNotesScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                signOut();
                Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
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
                        builder: (context) => NoteScreen(note: noteObject),
                      ),
                    );
                  },
                  onArchive: () => _archiveNote(note.id),
                  onDelete: () => _deleteNote(note.id),
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
