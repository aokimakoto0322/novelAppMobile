

import 'package:flutter_nobel_app/data/repository/common_story_repository.dart';
import 'package:flutter_nobel_app/models/common_story.dart';
import 'package:sqflite/sqflite.dart';
import '../data/sources/story_api.dart';

class CommonStoryUsecase {
  CommonStoryRepository commonStoryRepository = CommonStoryRepository();
  CommonStoryApi commonStoryApi = CommonStoryApi();

  Future<List<CommonStory>> getAllStory(Database db) async {
    List<CommonStory> result = [];

    // DBの話の数を取得
    var storyCount = await commonStoryRepository.getStoryCount(db);

    // DBの話のカウントが0の場合、初期ストーリーデータをサーバーから取得する
    if (storyCount == 0) {
      // APIで話を取得
      var apiStoryList = await commonStoryApi.fetchAllStory();

      // common_storyテーブルにまとめてデータを格納
      var storyList = apiStoryList.map((story) => story.toMap()).toList();

      commonStoryRepository.insertStory(db, storyList);
    }
    
    // DBから話を取得する
    result = await commonStoryRepository.fetchAllStory(db);
    
    // 話をsort順に並び替え
    result.sort((a, b) => a.storyId.compareTo(b.storyId));

    return result;
  }
}