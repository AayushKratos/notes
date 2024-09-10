import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:note/Model/note_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'notes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
  await db.execute('DROP TABLE IF EXISTS notes');
  await db.execute('''
    CREATE TABLE notes(
      id TEXT PRIMARY KEY,
      title TEXT,
      note TEXT,
      createdAt TEXT,
      updatedAt TEXT,
      color INTEGER,
      archived INTEGER,
      deleted INTEGER
    )
  ''');
}

  Future<int> insertNote(Note note) async {
    Database? db = await database;
    return await db!.insert('notes', note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Note>> getNotes() async {
    Database? db = await database;
    List<Map<String, dynamic>> maps = await db!.query('notes');

    return List.generate(maps.length, (i) {
      return Note(
        id: maps[i]['id'],
        title: maps[i]['title'],
        note: maps[i]['note'],
        createdAt: DateTime.parse(maps[i]['createdAt']),
        updatedAt: DateTime.parse(maps[i]['updatedAt']),
        color: maps[i]['color'],
        archived: maps[i]['archived'] == 1 ? true : false,
        deleted: maps[i]['deleted'] == 1 ? true : false,
      );
    });
  }

  Future<int> updateNote(Note note) async {
    Database? db = await database;
    return await db!.update('notes', note.toMap(),
        where: 'id = ?', whereArgs: [note.id]);
  }

  Future<int> deleteNote(String id) async {
    Database? db = await database;
    return await db!.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
