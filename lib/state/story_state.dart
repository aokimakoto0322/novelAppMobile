import 'package:flutter_nobel_app/database/database.dart';

class StoryState {
  final int currentIndex; // 現在の話のIndexを取得
  final String backGroundImage; // 拡張子込みの背景画像名
  final List<Choice> currentChoices; // 選択肢リスト
  final bool isChoice; // 話が選択肢に来た場合を格納
  final bool isWaiting; // ロード状態を管理
  final Choice selectedChoice; // 選択された選択肢情報を格納
  final List<Story> allStory;

  const StoryState({
    required this.currentIndex,
    required this.backGroundImage,
    required this.currentChoices,
    required this.isChoice,
    required this.isWaiting,
    required this.selectedChoice,
    required this.allStory
  });

  StoryState copyWith({
    int? currentIndex,
    String? backGroundImage,
    List<Choice>? currentChoices,
    bool? isChoice,
    bool? isWaiting,
    Choice? selectedChoice,
    List<Story>? allStory
  }) {
    return StoryState(
      currentIndex: currentIndex ?? this.currentIndex,
      backGroundImage: backGroundImage ?? this.backGroundImage,
      currentChoices: currentChoices ?? this.currentChoices,
      isChoice: isChoice ?? this.isChoice,
      isWaiting: isWaiting ?? this.isWaiting,
      selectedChoice: selectedChoice ?? this.selectedChoice,
      allStory: allStory ?? this.allStory
    );
  }

  static const initial = StoryState(
    currentIndex: 0,
    backGroundImage: '',
    currentChoices: [],
    isChoice: false,
    isWaiting: false,
    selectedChoice: Choice(id: 0, storyId: 0, word: '', choiceGroup: 0, nextStoryId: 0, returnStoryId: 0, warpStoryId: 0),
    allStory: []
  );
}