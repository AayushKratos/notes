class Note {
  int? id;
  String description;
  String title;
  DateTime createdAt;

  Note({
    this.id,
    required this.description,
    required this.title,
    required this.createdAt
  });
}