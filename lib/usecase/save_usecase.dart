import 'package:flutter_nobel_app/data/repository/save_repository.dart';
import 'package:flutter_nobel_app/database/database.dart';
import 'package:flutter_nobel_app/views/save_view_model.dart';

class SaveUsecase {
  SaveRepository saveRepository = SaveRepository();

  // 進行状態をセーブする
  Future<void> saveStory(MyDatabase db, int storyId) async {
    saveRepository.insertSaveStory(db, storyId);
  }

  // 進行状況を取得する
  Future<List<SaveViewModel>> fetchSaveList(MyDatabase db) async {
    var result = await saveRepository.fetchSaveList(db);
    return result;
  }
}