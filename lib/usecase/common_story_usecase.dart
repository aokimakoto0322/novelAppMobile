

import 'package:flutter_nobel_app/data/repository/common_story_repository.dart';
import 'package:flutter_nobel_app/database/database.dart';
import '../data/sources/story_api.dart';

class CommonStoryUsecase {
  CommonStoryRepository commonStoryRepository = CommonStoryRepository();
  CommonStoryApi commonStoryApi = CommonStoryApi();

  Future<List<CommonStory>> getAllStory(MyDatabase db) async {
    List<CommonStory> result = [];

    // DBの話の数を取得
    var storyCount = await commonStoryRepository.getStoryCount(db);

    // DBの話のカウントが0の場合、初期ストーリーデータをサーバーから取得する
    if (storyCount == 0) {
      // APIで話を取得
      List<CommonStory> apiStoryList = await commonStoryApi.fetchAllStory();

      commonStoryRepository.insertStory(db, apiStoryList);
    }
    
    // DBから話を取得する
    result = await commonStoryRepository.fetchAllStory(db);

    return result;
  }
}