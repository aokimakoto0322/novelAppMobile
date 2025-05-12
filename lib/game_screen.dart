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
                usecase.showNextItem(widget.database, widget.allStory);
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
                          child: AnimatedTextKit(
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
                          )
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