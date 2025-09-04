import 'package:flutter_nobel_app/data/repository/choicelog_repository.dart';
import 'package:flutter_nobel_app/database/database.dart';

class ChoicelogUsecase {
  ChoicelogRepository choiceLogRepository;

  ChoicelogUsecase({
    required this.choiceLogRepository
  });

  // 選択肢を選択したとき、選択情報を格納する
  Future<void> insertChoiceLog(Choice choice) async {
    await choiceLogRepository.insertChoiceLog(choice);
  }

  // セーブデータと紐づいていない選択肢選択情報を削除する
  Future<void> deleteChoicelog() async {
    await choiceLogRepository.deleteChoicelog();
  }
}