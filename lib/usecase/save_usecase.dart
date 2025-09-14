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
  Future<void> saveStory(MyDatabase db, int storyId) async {
    // 進行状況をセーブ
    var saveId = await saveRepository.insertSaveStory(db, storyId);

    // セーブした進行状況と、バックログを紐づける
    backlogRepository.linkSaveAndBacklog(saveId);
    print('紐づけ完了');
  }

  // 進行状況を取得する
  Future<List<SaveViewModel>> fetchSaveList(MyDatabase db) async {
    var result = await saveRepository.fetchSaveList(db);
    return result;
  }
}