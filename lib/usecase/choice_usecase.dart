import 'package:flutter_nobel_app/data/repository/choice_repository.dart';
import 'package:flutter_nobel_app/database/database.dart';

class ChoiceUsecase {
  ChoiceRepository choiceRepository = ChoiceRepository();

  // アプリ初回起動時、選択肢情報がINSERTされているか確認し、
  // 選択肢情報がなければ初期データをINSERTする
  Future<void> setInitialData(MyDatabase db) async {
    var count = await choiceRepository.getChoiceCount(db);

    if (count == 0) {
      List<Choice> initialChoiceList = [
        Choice(id: 1, storyId: 4, word: '選択肢A', nextStoryId: 15, returnStoryId: 2),
        Choice(id: 2, storyId: 4, word: '選択肢B', nextStoryId: 20, returnStoryId: 2)
      ];

      await choiceRepository.setInitialData(db, initialChoiceList);
    }
  }

  // ストーリーIDを受け取って、ストーリーIDと合致する選択肢リストがあれば返却する
  // 選択肢がある場合はリストで返却、ない場合は[](空のリスト)を返却する
  Future<List<Choice>> fetchCoiceList(MyDatabase db, int storyId) async {
    var result = await choiceRepository.fetchChoiceList(db, storyId);

    return result;
  }
}