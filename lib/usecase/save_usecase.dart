import 'package:flutter_nobel_app/data/repository/backlog_repository.dart';
import 'package:flutter_nobel_app/data/repository/save_repository.dart';
import 'package:flutter_nobel_app/database/database.dart';
import 'package:flutter_nobel_app/views/save_view_model.dart';

class SaveUsecase {
  final SaveRepository saveRepository;
  final BacklogRepository backlogRepository;

  SaveUsecase({
    required this.saveRepository,
    required this.backlogRepository
  });

  // 進行状態をセーブする
  Future<int> saveStory(MyDatabase db, int storyId) async {
    // 進行状況をセーブ
    var saveId = await saveRepository.insertSaveStory(db, storyId);

    // セーブした進行状況と、バックログを紐づける
    await backlogRepository.linkSaveAndBacklog(saveId); // awaitを追加
    return saveId; // saveIdを返す
  }

  // 進行状況を取得する
  Future<List<SaveViewModel>> fetchSaveList(MyDatabase db) async {
    var result = await saveRepository.fetchSaveList(db);
    return result;
  }
}