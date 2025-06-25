

import 'package:flutter/material.dart';
import 'package:flutter_nobel_app/data/repository/choice_repository.dart';
import 'package:flutter_nobel_app/data/repository/story_repository.dart';
import 'package:flutter_nobel_app/database/database.dart';
import '../data/sources/story_api.dart';

class StoryUsecase extends ChangeNotifier {
  ChoiceRepository choiceRepository = ChoiceRepository();
  StoryRepository commonStoryRepository = StoryRepository();
  CommonStoryApi commonStoryApi = CommonStoryApi();

  int _currentIndex = 0; // 現在の話のIndexを取得
  String _backGroundImage = '';
  List<Choice> _currentChoices = []; // 選択肢リスト
  bool _isChoice = false; // 話が選択肢に来た場合を格納
  Choice _selectedChoice = Choice(id: 0, storyId: 0, word: '', nextStoryId: 0, returnStoryId: 0); // 選択された選択肢情報を格納

  int get currentIndex => _currentIndex;
  String get backGroundImage => _backGroundImage;
  List<Choice> get currentChoice => _currentChoices;
  bool get isChoice => _isChoice;
  Choice get selectedChoice => _selectedChoice;


  Future<List<Story>> getAllStory(MyDatabase db) async {
    List<Story> result = [];

    // データを一括削除してから新しいデータを取得する
    commonStoryRepository.deleteAllStory(db);

    // APIで話を取得し格納
    List<Story> apiStoryList = await commonStoryApi.fetchAllStory();
    commonStoryRepository.insertStory(db, apiStoryList);
    
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

    // 選択肢リストの取得
    _currentChoices = await choiceRepository.fetchChoiceList(db);

    // 選択肢出現チェック
    var isChoice = _currentChoices.where((choice) => choice.storyId == _currentIndex);
    if (isChoice.length > 1) {
      _isChoice = true;
    }

    // 変数の変更を通知(画面側のChangeNotifierProviderでこのクラスのメンバ変数の変更を取得している)
    notifyListeners();
  }

  // ゲーム画面クリック時の業務処理
  Future<void> showNextItem(MyDatabase db, List<Story> allStory) async {
    _currentIndex++;
    _backGroundImage = allStory[_currentIndex].imageName;

    
    // 選択肢出現チェック
    var isChoice = _currentChoices.where((choice) => choice.storyId == _currentIndex);
    if (isChoice.length > 1) {
      _isChoice = true;
    }

    // 選択肢に応じたストーリーの場合
    if (_selectedChoice.id != 0) {
      // 選択肢に応じたストーリーが終わった場合
      if (_currentIndex == _selectedChoice.returnStoryId) {
        _currentIndex = _selectedChoice.storyId + 1;
        _backGroundImage = allStory[_currentIndex].imageName;

        // 選択した選択肢情報を初期化
        _selectedChoice = Choice(id: 0, storyId: 0, word: '', nextStoryId: 0, returnStoryId: 0);
      }
    }

    // 変数の変更を通知(画面側のChangeNotifierProviderでこのクラスのメンバ変数の変更を取得している)
    notifyListeners();
  }

  // 選択肢がクリックされたとき
  // クリックされた選択肢状態を保存し、選択肢に応じた話にジャンプする
  void tabSelect(Choice choice, List<Story> allStory) {
    // 全体ストーリーから、選択された選択肢の箇所にジャンプする
    _selectedChoice = choice;

    _currentIndex = choice.nextStoryId;
    _backGroundImage = allStory[_currentIndex].imageName;

    // ジャンプ後は選択肢画面を閉じる
    _isChoice = false;

    // 変数の変更を通知(画面側のChangeNotifierProviderでこのクラスのメンバ変数の変更を取得している)
    notifyListeners();
  }
}