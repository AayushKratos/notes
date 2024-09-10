// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

// class DatabaseServices {
//   static Database? _db;
//   static final DatabaseServices instance = DatabaseServices._constructor();

//   final String _tasksTableName = "tasks";
//   final String _tasksIdColumnName = "id";
//   final String _tasksContentColumnName = "content";
//   final String _tasksStatusColumnName = "status";

//   DatabaseServices._constructor();

//   Future<Database> get database async {
//     if (_db != null) return _db!;
//     _db = await getDatabase();
//     return _db!;
//   }

//   Future<Database> getDatabase() async {
//     final databaseDirPath = await getDatabasesPath();
//     final databasePath = join(databaseDirPath, "master_db.db");
//     final database = await openDatabase(
//       databasePath,
//       version: 1, // Always set a version number for migrations.
//       onCreate: (db, version) {
//         return db.execute('''
//           CREATE TABLE $_tasksTableName(
//             $_tasksIdColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
//             $_tasksContentColumnName TEXT NOT NULL,
//             $_tasksStatusColumnName INTEGER NOT NULL
//           )
//         ''');
//       },
//     );
//     return database;
//   }

//   Future<void> addTask(String content) async {
//     final db = await database;
//     await db.insert(
//       _tasksTableName,
//       {
//         _tasksContentColumnName: content,
//         _tasksStatusColumnName: 0, // 0 means task is pending
//       },
//     );
//   }

//   Future<List<Map<String, dynamic>>> getTasks() async {
//     final db = await database;
//     return await db.query(_tasksTableName);
//   }
// Future<void> updateTask(int id, String title, String content, int color) async {
//   final db = await database;
//   await db.update(
//     'tasks',
//     {
//       'title': title,
//       'content': content,
//       'color': color,
//       'updatedAt': DateTime.now().toString(),
//     },
//     where: 'id = ?',
//     whereArgs: [id],
//   );
// }


//   Future<void> deleteTask(int id) async {
//     final db = await database;
//     await db.delete(
//       _tasksTableName,
//       where: '$_tasksIdColumnName =   ?',
//       whereArgs: [id],
//     );
//   }
// }
