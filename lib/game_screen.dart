import 'package:flutter/material.dart';
import 'package:flutter_nobel_app/models/common_story.dart';
import 'package:flutter_nobel_app/usecase/save_usecase.dart';
import 'package:sqflite/sqflite.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class GameScreen extends StatefulWidget {
  final Database database;
  final List<CommonStory> allStory;
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
  int currentIndex = 0;

  @override
  void initState() {
    _setCurrentIndex();
    super.initState();
  }
  
  void _showItem() {
    setState(() {
      currentIndex = (currentIndex + 1);
    });
  }

  // セーブされたデータがあるのであれば、セーブ時の状態から表示する
  void _setCurrentIndex() {
    if (widget.savedIndex != 0) {
      currentIndex = widget.savedIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: GestureDetector(
        onTap: () {
          _showItem();
        },
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/sample.jpg'),
              fit: BoxFit.cover
            )
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
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
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          saveUsecase.saveStory(widget.database, widget.allStory[currentIndex].storyId);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}