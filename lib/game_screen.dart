import 'package:flutter/material.dart';
import 'package:flutter_nobel_app/database/database.dart';
import 'package:flutter_nobel_app/usecase/choice_usecase.dart';
import 'package:flutter_nobel_app/usecase/save_usecase.dart';
import 'package:flutter_nobel_app/widget/image_screen_widget.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

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
  List<Choice> currentChoices = [];
  int currentIndex = 0;
  var backgroundImage = '';

  @override
  void initState() {
    _setCurrentIndex();
    super.initState();
  }
  
  Future<void> _showItem() async {
    setState(() {
      currentIndex = (currentIndex + 1);
      backgroundImage = widget.allStory[currentIndex].imageName;
    });
    currentChoices = await choiceUsecase.fetchCoiceList(widget.database, widget.allStory[currentIndex].id);
    print('選択肢リスト$currentChoices');
  }

  // セーブされたデータがあるのであれば、セーブ時の状態から表示する
  void _setCurrentIndex() {
    if (widget.savedIndex != 0) {
      currentIndex = widget.savedIndex;
    }
    backgroundImage = widget.allStory[currentIndex].imageName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          _showItem();
        },
        behavior: HitTestBehavior.deferToChild,
        child: Stack(
          children: <Widget>[
            // 画像表示エリア
            ImageScreenWidget(
              backgroundImage: backgroundImage
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
                      key: ValueKey<String>(widget.allStory[currentIndex].word),
                      animatedTexts: [
                        TyperAnimatedText(
                          widget.allStory[currentIndex].word,
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          saveUsecase.saveStory(widget.database, widget.allStory[currentIndex].id);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}