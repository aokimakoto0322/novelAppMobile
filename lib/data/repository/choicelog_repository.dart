
import 'package:drift/drift.dart';
import 'package:flutter_nobel_app/database/database.dart';

class ChoicelogRepository {
  final MyDatabase db;

  ChoicelogRepository(
    this.db
  );

  Future<void> insertChoiceLog(Choice choice) async {
    await db.transaction(() async {
      final choiceLogId = await db.into(db.choiceLogTable).insert(
        ChoiceLogTableCompanion(
          saveId: const Value(0),
          choiceId: Value(choice.id)
        )
      );

      await db.into(db.choiceLogSelectTable).insert(
        ChoiceLogSelectTableCompanion(
          choiceLogId: Value(choiceLogId),
          order: const Value(0)
        )
      );

      print('選択肢情報格納');
      print('選択肢ログID: $choiceLogId');
    });
  }
}