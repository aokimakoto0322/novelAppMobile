import 'package:flutter/material.dart';
import 'package:flutter_nobel_app/database/database.dart';
import 'package:flutter_nobel_app/usecase/choice_usecase.dart';
import 'package:flutter_nobel_app/usecase/save_usecase.dart';
import 'package:flutter_nobel_app/usecase/story_usecase.dart';
import 'package:flutter_nobel_app/widget/image_screen_widget.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
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
  late StoryUsecase storyUsecase;

  @override
  void initState() {
    storyUsecase = StoryUsecase();
    storyUsecase.initGameScreen(widget.database, widget.allStory, widget.savedIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (_) => storyUsecase,
        child: Consumer<StoryUsecase>(
          builder: (context, usecase, child) {
            return GestureDetector(
              onTap: () {
                if (!usecase.isChoice && !usecase.isWaiting) {
                  usecase.showNextItem(widget.database, widget.allStory);
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
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      color: Colors.brown.withAlpha(200),
                      alignment: Alignment.topLeft,
                      height: 150,
                      child: Container(
                        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: usecase.isWaiting
                              ? SizedBox.shrink()
                              : AnimatedTextKit(
                                  key: ValueKey<String>(widget.allStory[storyUsecase.currentIndex].word),
                                  animatedTexts: [
                                    TyperAnimatedText(
                                      widget.allStory[storyUsecase.currentIndex].word,
                                      textStyle: const TextStyle(
                                        fontSize: 18
                                      ),
                                    )
                                  ],
                                  totalRepeatCount: 1,
                                  displayFullTextOnTap: true
                                ),
                        ),
                      ),
                    ),
                  ),

                  // しゃべっている人ラベル表示エリア
                  if (widget.allStory[storyUsecase.currentIndex].speaker != '')
                    Positioned(
                      left: 10,
                      bottom: 155,
                      child: Container(
                        alignment: Alignment.center,
                        height: 30,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.amber.withAlpha(200),
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(20),
                            right: Radius.circular(20)
                          )
                        ),
                        child: Text(
                          widget.allStory[storyUsecase.currentIndex].speaker
                        ),
                      ),
                    ),
                  
                  // 選択肢表示エリア
                  AnimatedOpacity(
                    opacity: usecase.isChoice ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 1000),
                    child: IgnorePointer(
                      ignoring: !usecase.isChoice,
                      child: Container(
                        color: Colors.black.withAlpha(180),
                        width: double.infinity,
                        height: double.infinity,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ...usecase.currentChoice.map((choice) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      usecase.tabSelect(choice, widget.allStory);
                                    },
                                    child: Text(choice.word)
                                  ),
                                );
                              })
                            ]
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          saveUsecase.saveStory(widget.database, widget.allStory[storyUsecase.currentIndex].id);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}