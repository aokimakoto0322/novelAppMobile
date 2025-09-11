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

  // バックログをリストで生成して返却する
  Future<List<Story>> getBacklog(List<Story> allStory, int index) async {
    //indexがallStoryからはみ出ないようにする、また、現在画面に表示されている文言もバックログに含める
    final safeIndex = index.clamp(0, allStory.length) + 1;
    final result = allStory.sublist(0, safeIndex);

    print(allStory);
    return result;
  }
}