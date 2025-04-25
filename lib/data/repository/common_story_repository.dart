import 'dart:async';
import 'package:flutter_nobel_app/models/common_story.dart';
import 'package:sqflite/sqflite.dart';

class CommonStoryRepository {
  // 全件データ取得
  Future<List<CommonStory>> fetchAllStory(Database db) async {
    final List<Map<String, dynamic>> result = await db.query('common_story');
    return result.map((map) => CommonStory.fromMap(map)).toList();
  }

  // IDを指定してデータ取得
  Future<List<CommonStory>> getStoryById(Database db, int id) async {
    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT * FROM common_story WHERE story_id = $id');
    return result.map((map) => CommonStory.fromMap(map)).toList();
  }

  Future<int> getStoryCount(Database db) async {
    var rawQuery = "SELECT COUNT(*) FROM common_story";
    final result = await db.rawQuery(rawQuery);

    return Sqflite.firstIntValue(result) ?? 0;
  }

  // データをリストで取得し、common_storyテーブルに格納
  Future<void> insertStory(Database db, List<Map<String, dynamic>> storyList) async {
    Batch batch = db.batch();

    for (var story in storyList) {
      batch.insert('common_story', story);
    }
    await batch.commit(noResult: true);
  }
}

