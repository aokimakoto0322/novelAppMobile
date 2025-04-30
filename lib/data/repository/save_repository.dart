import 'package:drift/drift.dart';
import 'package:flutter_nobel_app/database/database.dart';
import 'package:flutter_nobel_app/views/save_view_model.dart';
import 'package:intl/intl.dart';

class SaveRepository {
  // 進行状況をセーブ
  Future<void> insertSaveStory(MyDatabase db, int storyId) async {
    DateTime now = DateTime.now();
    String formatDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    await db.into(db.saveTable).insert(
      SaveTableCompanion(
        storyId: Value(storyId),
        saveDate: Value(formatDate)
      )
    );
  }

  // 進行状態を取得
  Future<List<SaveViewModel>> fetchSaveList(MyDatabase db) async {
    final query = db.select(db.saveTable).join([
      innerJoin(db.commonStoryTable, db.saveTable.storyId.equalsExp(db.commonStoryTable.id))
    ]);

    final results = await query.get();

    return results.map((row) {
      final save = row.readTable(db.saveTable);
      final story = row.readTable(db.commonStoryTable);

      return SaveViewModel(id: save.id, storyId: story.id, saveDate: save.saveDate, word: story.word);
    }).toList();
  }
}