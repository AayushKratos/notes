import 'package:flutter/material.dart';
import 'package:note/Model/note_model.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onPressed;
  final VoidCallback onArchive;
  final VoidCallback onDelete;

  const NoteCard({
    Key? key,
    required this.note,
    required this.onPressed,
    required this.onArchive,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: Color(note.color),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title.isEmpty ? 'Untitled' : note.title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  note.note,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 4,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.archive),
                    onPressed: onArchive,
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: onDelete,
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
