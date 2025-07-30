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
  bool _isWaiting = false; // ロード状態を管理
  Choice _selectedChoice = Choice(id: 0, storyId: 0, word: '', nextStoryId: 0, returnStoryId: 0); // 選択された選択肢情報を格納

  int get currentIndex => _currentIndex;
  String get backGroundImage => _backGroundImage;
  List<Choice> get currentChoice => _currentChoices;
  bool get isChoice => _isChoice;
  bool get isWaiting => _isWaiting;
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
    // 話の終わりを判定
    if (_currentIndex + 1 >= allStory.length) return;

    _currentIndex++;
    _backGroundImage = allStory[_currentIndex].imageName;

    
    // 選択肢出現チェック
    var isChoice = _currentChoices.where((choice) => choice.storyId == _currentIndex);
    if (isChoice.length > 1) {
      _isChoice = true;
    }

    print(allStory[_currentIndex]);

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
  Future<void> tabSelect(Choice choice, List<Story> allStory) async {
    _selectedChoice = choice;
    _isWaiting = true; // ロード状態を開始

    // シーン切り替え処理で画像を先に切り替えて後から文字を出す
    // ①画像だけ先に切り替える
    _backGroundImage = allStory[choice.nextStoryId].imageName;
    _isChoice = false;
    notifyListeners();

    // ②4秒待つ
    // TODO: この秒数はStoryテーブルの値を見て判断するようにする
    await Future.delayed(Duration(seconds: 4));

    // ③currentIndexを切り替え、テキストも切り替わる
    _currentIndex = choice.nextStoryId;
    _isWaiting = false; // ロード状態を終了
    notifyListeners();
  }
}