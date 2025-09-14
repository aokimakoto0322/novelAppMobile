import 'package:flutter/material.dart';
import 'package:flutter_nobel_app/provider/story_provider.dart';
import 'package:flutter_nobel_app/usecase/admob_usecase.dart';
import 'package:flutter_nobel_app/widget/animation_stack_widget.dart';
import 'package:flutter_nobel_app/widget/choose_screen_widget.dart';
import 'package:flutter_nobel_app/widget/image_screen_widget.dart';
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

class _GameScreenState extends ConsumerState<GameScreen> {
  AdmobUsecase admobUsecase = AdmobUsecase();

  @override
  void initState() {
    admobUsecase.loadInterstitialAd();
    
    final usecase = ref.read(storyUsecaseProvider.notifier);
    usecase.initGameScreen(widget.savedIndex, widget.saveId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final usecase = ref.watch(storyUsecaseProvider.notifier);
    final state = ref.watch(storyUsecaseProvider);
    final allStory = state.allStory;


    return PopScope(
      canPop: false,
      child: AnimationStackWidget(
        foregroundWidget: Scaffold(
          body: GestureDetector(
            onTap: (state.isChoice || state.isWaiting)
              ? null
              : () {
                usecase.showNextItem(usecase.db, allStory, admobUsecase);
              },
            behavior: HitTestBehavior.deferToChild,
            child: Stack(
              children: <Widget>[
                // 画像表示エリア
                ImageScreenWidget(
                  backgroundImage: state.backGroundImage
                ),
                      
                // テキストエリア
                TextAreaWidget(),
                
                // しゃべっている人ラベル表示エリア
                if (allStory[state.currentIndex].speaker != '')
                  SpeakerAreaWidget(),
                                  
                // 選択肢表示エリア
                ChooseScreenWidget()
              ],
            ),
          )
        ),
      ),
    );
  }
}