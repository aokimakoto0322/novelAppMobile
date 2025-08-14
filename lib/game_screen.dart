import 'package:flutter/material.dart';
import 'package:flutter_nobel_app/database/database.dart';
import 'package:flutter_nobel_app/usecase/admob_usecase.dart';
import 'package:flutter_nobel_app/usecase/choice_usecase.dart';
import 'package:flutter_nobel_app/usecase/save_usecase.dart';
import 'package:flutter_nobel_app/usecase/story_usecase.dart';
import 'package:flutter_nobel_app/widget/animation_stack_widget.dart';
import 'package:flutter_nobel_app/widget/choose_screen_widget.dart';
import 'package:flutter_nobel_app/widget/image_screen_widget.dart';
import 'package:flutter_nobel_app/widget/speaker_area_widget.dart';
import 'package:flutter_nobel_app/widget/text_area_widget.dart';
import 'package:flutter_nobel_app/widget/will_scope_dialog_widget.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  final MyDatabase database;
  final List<Story> allStory;
  final int savedIndex;

  const GameScreen({
    super.key,
    required this.database,
    required this.allStory,
    this.savedIndex = 0
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  SaveUsecase saveUsecase = SaveUsecase();
  ChoiceUsecase choiceUsecase = ChoiceUsecase();
  AdmobUsecase admobUsecase = AdmobUsecase();
  late StoryUsecase storyUsecase;

  @override
  void initState() {
    admobUsecase.loadInterstitialAd();
    storyUsecase = StoryUsecase();
    storyUsecase.initGameScreen(widget.database, widget.allStory, widget.savedIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<MyDatabase>.value(value: widget.database),
        Provider<List<Story>>.value(value: widget.allStory),
        ChangeNotifierProvider<StoryUsecase>.value(value: storyUsecase),
        Provider<SaveUsecase>.value(value: saveUsecase),
      ],
      child: WillPopScopeDialogWidget(
        child: AnimationStackWidget(
          foregroundWidget: Scaffold(
            body: Consumer<StoryUsecase>( // ConsumerWidgetを使用し、StoryUsecaseの状態を監視
              builder: (context, usecase, child) {
                final database = context.read<MyDatabase>();
                final allStory = context.read<List<Story>>();

                return GestureDetector(
                  onTap: () {
                    if (!usecase.isChoice && !usecase.isWaiting) {
                      usecase.showNextItem(database, allStory, admobUsecase);
                    }
                  },
                  behavior: HitTestBehavior.deferToChild,
                  child: Stack(
                    children: <Widget>[
                      // 画像表示エリア
                      ImageScreenWidget(
                        backgroundImage: usecase.backGroundImage
                      ),
                            
                      // テキストエリア
                      TextAreaWidget(
                        usecase: usecase,
                        allStory: allStory
                      ),
                      
                      // しゃべっている人ラベル表示エリア
                      if (allStory[storyUsecase.currentIndex].speaker != '')
                        SpeakerAreaWidget(
                          allStory: allStory,
                          storyUsecase: storyUsecase
                        ),
                                        
                      // 選択肢表示エリア
                      ChooseScreenWidget(
                        usecase: usecase,
                        allStory: allStory
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}