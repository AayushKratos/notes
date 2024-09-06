import 'package:flutter/material.dart';
import 'package:note/Model/note_model.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onPressed;
  final VoidCallback onArchive;
  final VoidCallback onDelete; // This will be used for restoration

  const NoteCard({
    Key? key,
    required this.note,
    required this.onPressed,
    required this.onArchive,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(note.color),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(note.note),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.archive),
                    onPressed: onArchive,
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: onDelete, // This will now handle restoration
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
