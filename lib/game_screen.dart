import 'package:flutter/material.dart';
import 'package:flutter_nobel_app/provider/story_provider.dart';
import 'package:flutter_nobel_app/usecase/admob_usecase.dart';
import 'package:flutter_nobel_app/widget/animation_stack_widget.dart';
import 'package:flutter_nobel_app/widget/choose_screen_widget.dart';
import 'package:flutter_nobel_app/widget/image_screen_widget.dart';
import 'package:flutter_nobel_app/widget/live2d_character_widget.dart';
import 'package:flutter_nobel_app/widget/speaker_area_widget.dart';
import 'package:flutter_nobel_app/widget/text_area_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameScreen extends ConsumerStatefulWidget {
  final int savedIndex;
  final int saveId;

  const GameScreen({
    super.key,
    this.savedIndex = 0,
    this.saveId = 0
  });

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> with WidgetsBindingObserver {
  AdmobUsecase admobUsecase = AdmobUsecase();
  bool _isVisible = false; // 明転用フラグ

  @override
  void initState() {
    super.initState();
    
    admobUsecase.loadInterstitialAd();

    final usecase = ref.read(storyUsecaseProvider.notifier);
    usecase.initGameScreen(widget.savedIndex, widget.saveId);

    // 明転と待機・文字表示の連鎖処理
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // 1. 明転開始
      if (mounted) setState(() => _isVisible = true);
      
      // 2. 明転にかかる時間（2秒）を待つ
      await Future.delayed(const Duration(milliseconds: 2000));
      
      // 3. 文字表示
      if (mounted) {
        // 次に進めるのではなく、今のページ（0ページ目）を表示開始する
        usecase.startStory();
      }
    });

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState appState) {
    final usecase = ref.read(storyUsecaseProvider.notifier);
    final state = ref.watch(storyUsecaseProvider);

    if (appState == AppLifecycleState.paused || appState == AppLifecycleState.inactive) {
      usecase.stopBgm(); // ← アプリが非アクティブになったらBGM停止
    } else if (appState == AppLifecycleState.resumed) {
      usecase.playBgmIfNeeded(state.allStory[state.currentIndex].bgm);
    }
  }

  @override
  Widget build(BuildContext context) {
    final usecase = ref.watch(storyUsecaseProvider.notifier);
    final state = ref.watch(storyUsecaseProvider);
    final allStory = state.allStory;

    return PopScope(
      canPop: false,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 2000), // 2秒かけて明るく
        opacity: _isVisible ? 1.0 : 0.0,
        child: AnimationStackWidget(
          foregroundWidget: Scaffold(
            body: Stack(
              children: <Widget>[
                // 画像表示エリア
                ImageScreenWidget(
                  backgroundImage: state.backGroundImage
                ),

                // キャラクター表示エリア
                // CharacterWidget(
                //   character1: allStory[state.currentIndex].character1,
                //   character1Effect: allStory[state.currentIndex].character1Effect,
                // ),
                
                // Live2D WebView表示エリア
                const Live2DCharacterWidget(),

                // テキストエリア
                TextAreaWidget(
                  onTap: (state.isChoice || state.isWaiting || state.isDisplayingChoicePrompt)
                    ? null
                    : () {
                      usecase.showNextItem(usecase.db, allStory, admobUsecase);
                    },
                ),
                
                // しゃべっている人ラベル表示エリア
                if (allStory[state.currentIndex].speaker != '')
                  SpeakerAreaWidget(),
                                  
                // 選択肢表示エリア
                ChooseScreenWidget()
              ],
            ),
          ),
        ),
      ),
    );
  }
}