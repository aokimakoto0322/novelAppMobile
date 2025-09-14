import 'package:flutter_nobel_app/data/repository/backlog_repository.dart';
import 'package:flutter_nobel_app/database/database.dart';

class BacklogUsecase {
  BacklogRepository backlogRepository;

  BacklogUsecase({
    required this.backlogRepository
  });

  // クリックするたびにストーリー情報を保存する
  Future<void> insertBackLogStory(Story? story, Choice? choice) async {
    await backlogRepository.insertBackLogStory(story, choice);
  }

  // 保存したバックログを取得する
  Future<List<BackLog>> getBacklog(int saveId) async {
    List<BackLog> result = [];

    if (saveId == 0) {
      result = await backlogRepository.getBacklog();
    } else {
      result = await backlogRepository.getSavedBacklog(saveId);

      // セーブした地点から、話を進めたとする。その場合、セーブIDと紐づいているBacklogのみを取得しているため、セーブ時点でのBacklogしか表示されない
      // そのため、セーブ地点からのBacklogにプラスしてセーブIDと紐づいていないBacklogを追加する
      var unlinkedBacklog = await backlogRepository.getBacklog();

      result.addAll(unlinkedBacklog);
    }
    

    return result.reversed.toList();
  }

  // セーブデータに紐づいていないバックログをゲーム開始時に削除する
  Future<void> deleteBackLog() async {
    await backlogRepository.deleteBackLog();
  }
}