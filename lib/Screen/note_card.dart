import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note/Model/note_model.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onPressed;
  final VoidCallback onArchive;

  const NoteCard({
    Key? key,
    required this.note,
    required this.onPressed,
    required this.onArchive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime displayTime = note.updatedAt.isAfter(note.createdAt)
        ? note.updatedAt
        : note.createdAt;

    String formattedDateTime = DateFormat('h:mma MMMM d, y').format(displayTime);

    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: Color(note.color),
        margin: const EdgeInsets.all(8.0),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 5),
              Text(
                formattedDateTime,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: Text(
                  note.note,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  icon: const Icon(Icons.archive),
                  onPressed: onArchive,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
