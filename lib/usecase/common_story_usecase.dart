

import 'package:flutter_nobel_app/data/repository/story_repository.dart';
import 'package:flutter_nobel_app/database/database.dart';
import '../data/sources/story_api.dart';

class CommonStoryUsecase {
  StoryRepository commonStoryRepository = StoryRepository();
  CommonStoryApi commonStoryApi = CommonStoryApi();

  Future<List<Story>> getAllStory(MyDatabase db) async {
    List<Story> result = [];

    // DBの話の数を取得
    var storyCount = await commonStoryRepository.getStoryCount(db);

    // DBの話のカウントが0の場合、初期ストーリーデータをサーバーから取得する
    if (storyCount == 0) {
      // APIで話を取得
      List<Story> apiStoryList = await commonStoryApi.fetchAllStory();

      commonStoryRepository.insertStory(db, apiStoryList);
    }
    
    // DBから話を取得する
    result = await commonStoryRepository.fetchAllStory(db);

    return result;
  }
}