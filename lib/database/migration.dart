import 'dart:async';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

Future<Database> initializeDatabase() async {
  final dbPath = await getDatabasesPath();
  return openDatabase(
    join(dbPath, 'nobel.db'),
    version: 2, // アップデートしたい場合はバージョンを変更する
    onCreate: (db, version) async {
      // common_storyテーブル作成
      var createStoryTableQuery = '''
        CREATE TABLE IF NOT EXISTS common_story (
          story_id INTEGER PRIMARY KEY AUTOINCREMENT,
          sort_id TEXT,
          word TEXT NOT NULL,
          image_name TEXT NOT NULL
        )
      ''';
      await db.execute(createStoryTableQuery);


      var saveTableQuery = '''
        CREATE TABLE IF NOT EXISTS save (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          story_id INTEGER,
          save_date TEXT
        )
      ''';

      // セーブ状態を管理するsaveテーブル作成
      await db.execute(saveTableQuery);
    }
  );
}