import 'package:flutter_nobel_app/database/database.dart';

class ChoiceRepository {

  // Choiceテーブルのレコード数を取得する
  Future<int> getChoiceCount(MyDatabase db) async {
    var count = await db.select(db.choiseTable).get().then((row) => row.length);
    return count;
  }

  // Choiceテーブルに初期データをINSERTする
  Future<void> setInitialData(MyDatabase db, List<Choice> initialDataList) async {
    await db.batch((batch) {
      for (final initialData in initialDataList) {
        batch.insert(
          db.choiseTable,
          ChoiseTableCompanion.insert(
            storyId: initialData.storyId,
            word: initialData.word,
            nextStoryId: initialData.nextStoryId,
            returnStoryId: initialData.returnStoryId
          )
        );
      }
    });
  }

  Future<List<Choice>> fetchChoiceList(MyDatabase db, int storyId) async {
    var result = await (db.select(db.choiseTable)
      ..where((tbl) => tbl.storyId.equals(storyId))).get();

    return result;
  }
}