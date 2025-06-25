import 'package:flutter_nobel_app/database/database.dart';

class ChoiceRepository {

  // Choiceテーブルのレコード数を取得する
  Future<int> getChoiceCount(MyDatabase db) async {
    var count = await db.select(db.choiseTable).get().then((row) => row.length);
    return count;
  }

  Future<List<Choice>> fetchChoiceList(MyDatabase db, int storyId) async {
    var result = await (db.select(db.choiseTable)
      ..where((tbl) => tbl.storyId.equals(storyId))).get();

    return result;
  }
}