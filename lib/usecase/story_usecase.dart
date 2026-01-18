import 'package:flutter_nobel_app/data/repository/choice_repository.dart';
import 'package:flutter_nobel_app/data/repository/story_repository.dart';
import 'package:flutter_nobel_app/database/database.dart';
import 'package:flutter_nobel_app/state/story_state.dart';
import 'package:flutter_nobel_app/usecase/admob_usecase.dart';
import 'package:flutter_nobel_app/usecase/backlog_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../data/sources/story_api.dart';

class StoryUsecase extends StateNotifier<StoryState> {
  final MyDatabase db;
  final ChoiceRepository choiceRepository;
  final StoryRepository storyRepository;
  final CommonStoryApi commonStoryApi;
  final BacklogUsecase backlogUsecase;
  final AudioPlayer audioPlayer;
  bool _isFadingOut = false;


  StoryUsecase({
    required this.db,
    required this.choiceRepository,
    required this.storyRepository,
    required this.commonStoryApi,
    required this.backlogUsecase,
    required this.audioPlayer
  }) : super(StoryState.initial);

  List<Choice> get currentChoice => state.currentChoices;

  Future<void> getAllStory() async {
    List<Story> result = [];

    // データを一括削除してから新しいデータを取得する
    storyRepository.deleteAllStory();

    // APIで話を取得し格納
    List<Story> apiStoryList = await commonStoryApi.fetchAllStory();
    storyRepository.insertStory(db, apiStoryList);
    
    // DBから話を取得する
    result = await storyRepository.fetchAllStory();

    state = state.copyWith(allStory: result);
  }

  void resetState() {
    state = StoryState(
      allStory: state.allStory,
      currentIndex: 0,
      backGroundImage: state.allStory[0].imageName,
      currentChoices: [],
      isChoice: false,
      isWaiting: false,
      selectedChoice: Choice(id: 0, storyId: 0, word: '', choiceGroup: 0, nextStoryId: 0, returnStoryId: 0, warpStoryId: 0),
      saveId: 0,
      character1: '',
      currentBgm: ''
    );
  }

  // 初めからを押したとき、currentIndexを初期化する
  Future<void> setCurrentIndex(int index) async {
    state = state.copyWith(currentIndex: index);
  }

  // ロードした場合、ロードしたところからスタートする
  // 新規の場合は最初からスタートする
  Future<void> initGameScreen(int savedIndex, [int? saveId]) async {
    final index = savedIndex;
    final choice = await choiceRepository.fetchChoiceList();
    final isChoice = choice.where((c) => c.storyId == index).length > 1; // StoryIdで選択肢を検索し、行が取得できたら選択肢がある
    final allStory = state.allStory;

    if (saveId == 0) {
      // バックログ用に話の内容をBacklogテーブルに格納する
      await backlogUsecase.insertBackLogStory(allStory[index], null);
    }
    
    // riverPodで画面に通知
    state = state.copyWith(
      currentIndex: index,
      backGroundImage: allStory[index].imageName,
      currentChoices: choice,
      isChoice: isChoice,
      saveId: saveId
    );

    // BGM再生
    await playBgmIfNeeded(allStory[index].bgm);
  }

  // ゲーム画面クリック時の業務処理
  Future<void> showNextItem(MyDatabase db, List<Story> allStory, AdmobUsecase admobUsecase) async {
    // 広告表示チェック（サンプルで30回に1回表示する）
    if (state.currentIndex == 30) {
      // 広告を表示
      admobUsecase.showInterstitialAd(onAdClosed: () async {
        await Future.delayed(Duration(seconds: 1));
        _advanceStory(allStory);
        admobUsecase.loadInterstitialAd();
      });
      return;
    }

    // 話の終わりを判定
    if (state.currentIndex + 1 >= allStory.length) return;

    await _advanceStory(allStory);
    // BGM再生
    await playBgmIfNeeded(allStory[state.currentIndex].bgm);
  }

  // 選択肢がクリックされたとき
  // クリックされた選択肢状態を保存し、選択肢に応じた話にジャンプする
  Future<void> tabSelect(Choice choice, List<Story> allStory) async {
    state = state.copyWith(
      selectedChoice: choice,
      isWaiting: true,
      backGroundImage: allStory[choice.nextStoryId].imageName,
      isChoice: false
    );

    // 選択肢情報のみを格納した後、ストーリーを格納する
    await backlogUsecase.insertBackLogStory(null, choice);
    await backlogUsecase.insertBackLogStory(allStory[choice.nextStoryId], null);

    await Future.delayed(const Duration(seconds: 4));

    state = state.copyWith(
      currentIndex: choice.nextStoryId,
      isWaiting: false
    );

    // 選択肢を選択後、すぐにBGM指定があった場合は再生
    await playBgmIfNeeded(allStory[choice.nextStoryId].bgm);
  }


  // 次の話に進める
  Future<void> _advanceStory(List<Story> allStory) async {
    var nextIndex = state.currentIndex + 1;
    var isChoice = state.currentChoices.where((c) => c.storyId == nextIndex).length > 1;

    late StoryState newState;

    // 選択肢が表示されるとき
    if (isChoice == true) {
      newState = state.copyWith(
        currentIndex: nextIndex,
        backGroundImage: allStory[nextIndex].imageName,
        isChoice: isChoice,
        currentChoices: state.currentChoices,
        currentBgm: allStory[nextIndex].bgm
      );
    } else {
      newState = state.copyWith(
        currentIndex: nextIndex,
        backGroundImage: allStory[nextIndex].imageName,
        isChoice: isChoice,
        currentBgm: allStory[nextIndex].bgm
      );
    }
    

    // バックログ用に話の内容をBacklogテーブルに格納する
    await backlogUsecase.insertBackLogStory(allStory[nextIndex], null);

    // 選択肢に応じたストーリーを表示し、表示し終わったとき
    if (state.selectedChoice.id != 0 && nextIndex == state.selectedChoice.returnStoryId) {
      nextIndex = state.selectedChoice.warpStoryId + 1;
      newState = newState.copyWith(
        currentIndex: nextIndex,
        backGroundImage: allStory[nextIndex].imageName,
        selectedChoice: StoryState.initial.selectedChoice,
        currentBgm: allStory[nextIndex].bgm
      );
    }

    state = newState;
  }

  // BGMを流す
  Future<void> playBgmIfNeeded(String? nextBgm) async {
    final currentBgm = state.currentBgm;

    if (nextBgm == null || nextBgm.isEmpty) {
      // BGMを停止する処理
      try {
        await fadeOut(audioPlayer); // フェードアウト
        await audioPlayer.stop();
        state = state.copyWith(currentBgm: null); // 状態を更新
      } catch (e) {
        print('BGM停止エラー: $e');
      }
      return;
    }

    if (currentBgm == nextBgm && audioPlayer.playing) return; // 同じBGMなら何もしない

    try {
      await audioPlayer.stop();
      await audioPlayer.setAsset('bgm/$nextBgm');
      await audioPlayer.setLoopMode(LoopMode.one);
      await audioPlayer.setVolume(1.0);
      await audioPlayer.play();

      // BGMが正常に切り替わったら状態を更新
      state = state.copyWith(currentBgm: nextBgm);
    } catch (e) {
      print('BGM再生エラー: $e');
    }
  }

  Future<void> fadeIn(AudioPlayer player, {double targetVolume = 1.0, Duration duration = const Duration(seconds: 1)}) async {
    const steps = 10;
    final interval = duration ~/ steps;

    for (int i = 0; i <= steps; i++) {
      final volume = (i / steps) * targetVolume;
      await player.setVolume(volume);
      await Future.delayed(interval);
    }
  }

  Future<void> fadeOut(AudioPlayer player, {Duration duration = const Duration(seconds: 1)}) async {
    if (_isFadingOut) return; // すでにフェードアウト中なら処理をスキップ
    _isFadingOut = true;

    const steps = 10;
    final interval = duration ~/ steps;

    for (int i = steps; i >= 0; i--) {
      final volume = i / steps;
      await player.setVolume(volume);
      await Future.delayed(interval);
    }

    // フェードアウトが終わったら終わったことを知らせる
    _isFadingOut = false;
  }

  void stopBgm() {
    audioPlayer.stop();
  }
}