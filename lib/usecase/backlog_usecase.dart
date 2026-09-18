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
      // saveIdが0以外の場合は、指定されたsaveIdに紐づくバックログと、
      // 現在セーブデータに紐づいていないバックログを結合して表示
      final savedBacklog = await backlogRepository.getSavedBacklog(saveId);
      final unlinkedBacklog = await backlogRepository.getBacklog();

      // 重複を排除し、時系列順にソート
      // idはautoIncrementなので、idでソートすれば時系列順になる
      final combinedBacklog = [...savedBacklog, ...unlinkedBacklog];
      combinedBacklog.sort((a, b) => a.id.compareTo(b.id));
      result = combinedBacklog;
    }
    
    return result.reversed.toList();
  }

  // セーブデータに紐づいていないバックログをゲーム開始時に削除する
  Future<void> deleteBackLog() async {
    await backlogRepository.deleteBackLog();
  }
}