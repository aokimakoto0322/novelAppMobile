import 'package:flutter_nobel_app/database/database.dart';

class ChoiceRepository {
  Future<List<Choice>> fetchChoiceList(MyDatabase db) async {
    var result = await db.select(db.choiseTable).get();

    return result;
  }
}