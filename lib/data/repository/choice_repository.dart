import 'package:flutter_nobel_app/database/database.dart';

class ChoiceRepository {
  final MyDatabase db;

  ChoiceRepository(
    this.db
  );

  Future<List<Choice>> fetchChoiceList() async {
    var result = await db.select(db.choiseTable).get();

    return result;
  }
}