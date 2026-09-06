import 'package:drift/drift.dart';
import 'package:flutter_nobel_app/database/database.dart';

class BacklogRepository {
  final MyDatabase db;

  BacklogRepository(
    this.db
  );

  // クリックするたびにストーリー情報を保存する
  Future<void> insertBackLogStory(Story? story, Choice? choice) async {
    await db.into(db.backLogTable).insert(
      BackLogTableCompanion(
        word: Value(story?.word ?? ''),
        speaker: Value(story?.speaker ?? ''),
        choiceWord: Value(choice?.word ?? ''),
        saveId: Value(0)
      )
    );
  }

  // 保存したセーブデータと紐づいていないバックログを取得する
  Future<List<BackLog>> getBacklog() async {
    var result = await (db.select(db.backLogTable)..where((tbl) => tbl.saveId.equals(0) | tbl.saveId.isNull())).get();

    return result;
  }

  // 保存したセーブデータと紐づいているバックログを取得する
  Future<List<BackLog>> getSavedBacklog(int saveId) async {
    var result = await (db.select(db.backLogTable)..where((tbl) => tbl.saveId.equals(saveId))).get();

    return result;
  }

  // セーブデータと紐づいていないバックログは削除する
  Future<void> deleteBackLog() async {
    await (db.delete(db.backLogTable)..where((tbl) => tbl.saveId.isNull() | tbl.saveId.equals(0))).go();

    // debug ちゃんと削除されているか確認
    final logs = await (db.select(db.backLogTable)..where((tbl) => tbl.saveId.isNull() | tbl.saveId.equals(0))).get();
    print('削除確認');
    print(logs.length);
  }

  // セーブデータとバックログを紐づける
  Future<void> linkSaveAndBacklog(int currentSaveId, int newSaveId) async {
    if (currentSaveId > 0 && currentSaveId != newSaveId) {
      final previousLogs = await getSavedBacklog(currentSaveId);
      for (final log in previousLogs) {
        await db.into(db.backLogTable).insert(
          BackLogTableCompanion(
            word: Value(log.word),
            speaker: Value(log.speaker),
            choiceWord: Value(log.choiceWord),
            saveId: Value(newSaveId),
          ),
        );
      }
    }

    await (db.update(db.backLogTable)
      ..where((tbl) => tbl.saveId.equals(0) | tbl.saveId.isNull()))
      .write(BackLogTableCompanion(
        saveId: Value(newSaveId)
      ));
  }
}