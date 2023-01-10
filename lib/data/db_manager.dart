import 'package:sqflite/sqflite.dart';
import 'package:todo_app/model/project.dart';
import 'package:todo_app/model/todo.dart';

class DBManager {
  static Database? _db;

  static Future<Database?> getDB() async {
    _db ??= await openDatabase("todo.db", onCreate: (db, version) {
      db.execute(TABLE_CREATE_SQL_PROJECT);
      db.execute(TABLE_CREATE_SQL_TODO);
    }, version: 1);
    return _db;
  }
}
