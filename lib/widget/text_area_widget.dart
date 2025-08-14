import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../usecase/story_usecase.dart';
import '../database/database.dart';

class TextAreaWidget extends StatelessWidget {
  final StoryUsecase usecase;
  final List<Story> allStory;

  const TextAreaWidget({
    super.key,
    required this.usecase,
    required this.allStory
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        color: Colors.brown.withAlpha(200),
        alignment: Alignment.topLeft,
        height: 180,
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Align(
            alignment: Alignment.topLeft,
            child: usecase.isWaiting
                ? SizedBox.shrink()
                : AnimatedTextKit(
                    key: ValueKey<String>(allStory[usecase.currentIndex].word),
                    animatedTexts: [
                      TyperAnimatedText(
                        allStory[usecase.currentIndex].word,
                        textStyle: const TextStyle(fontSize: 18),
                      )
                    ],
                    totalRepeatCount: 1,
                    displayFullTextOnTap: true,
                  ),
          ),
        ),
      ),
    );
  }
}