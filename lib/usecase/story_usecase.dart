

import 'package:flutter/material.dart';
import 'package:flutter_nobel_app/data/repository/choice_repository.dart';
import 'package:flutter_nobel_app/data/repository/story_repository.dart';
import 'package:flutter_nobel_app/database/database.dart';
import '../data/sources/story_api.dart';

class StoryUsecase extends ChangeNotifier {
  ChoiceRepository choiceRepository = ChoiceRepository();
  StoryRepository commonStoryRepository = StoryRepository();
  CommonStoryApi commonStoryApi = CommonStoryApi();

  int _currentIndex = 0;
  String _backGroundImage = '';
  List<Choice> _currentChoices = [];

  int get currentIndex => _currentIndex;
  String get backGroundImage => _backGroundImage;
  List<Choice> get currentChoice => _currentChoices;


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

  // ロードした場合、ロードしたところからスタートする
  // 新規の場合は最初からスタートする
  Future<void> initGameScreen(MyDatabase db, List<Story> allStory, int savedIndex) async {
    if (savedIndex != 0) {
      _currentIndex = savedIndex;
    }
    _backGroundImage = allStory[_currentIndex].imageName;
  }

  // ゲーム画面クリック時の業務処理
  Future<void> showNextItem(MyDatabase db, List<Story> allStory) async {

    _currentIndex++;
    _backGroundImage = allStory[_currentIndex].imageName;
    _currentChoices = await choiceRepository.fetchChoiceList(db, allStory[_currentIndex].id);

    // 変数の変更を通知(画面側のChangeNotifierProviderでこのクラスのメンバ変数の変更を取得している)
    notifyListeners();
  }
}