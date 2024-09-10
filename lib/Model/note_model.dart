import 'dart:math';

class Note{
  String id;
  String title;
  String note;
  int color;
  final DateTime createdAt;
  final DateTime updatedAt;
  late final bool archived;
  final bool deleted;

  Note({
    required this.id,
    required this.title,
    required this.note,
    this.color = 0xFFFFFFFF,
    required this.createdAt,
    required this.updatedAt,
    this.archived = false,
    this.deleted = false,
  });

    Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'color': color,
      'archived': archived ? 1 : 0,
      'deleted': deleted ? 1 : 0,
    };
  }

  static Note fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      note: map['note'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      color: map['color'],
      archived: map['archived'] == 1,
      deleted: map['deleted'] == 1,
    );
  }
}

int generateRandomLightColor(){
  Random random = Random();
  int red = 200 + random.nextInt(56);
  int green = 200 + random.nextInt(56);
  int blue = 200 + random.nextInt(56);
  return (0xFF << 24) | (red << 16) | (green << 8) | blue;
}
