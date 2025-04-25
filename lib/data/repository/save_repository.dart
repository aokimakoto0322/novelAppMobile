import 'package:flutter_nobel_app/views/save_view_model.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class SaveRepository {
  // 進行状況をセーブ
  Future<void> insertSaveStory(Database db, int storyId) async {
    DateTime now = DateTime.now();
     String formatDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    db.rawInsert('INSERT INTO save (story_id, save_date) VALUES (?, ?)', [storyId, formatDate]);
  }

  // 進行状態を取得
  Future<List<SaveViewModel>> fetchSaveList(Database db) async {
    var rawQuery = '''
        SELECT save.id, save.story_id, save.save_date, common_story.word
        FROM save
        LEFT JOIN common_story ON save.story_id = common_story.story_id
      ''';

    final List<Map<String, dynamic>> result = await db.rawQuery(rawQuery);
    return result.map((map) => SaveViewModel.fromMap(map)).toList();
  }
}