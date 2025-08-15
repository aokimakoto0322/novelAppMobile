import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_nobel_app/provider/story_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextAreaWidget extends ConsumerWidget {
  const TextAreaWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyState = ref.read(storyUsecaseProvider);
    final allStory = storyState.allStory;

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
            child: storyState.isWaiting
                ? SizedBox.shrink()
                : AnimatedTextKit(
                    key: ValueKey<String>(allStory[storyState.currentIndex].word),
                    animatedTexts: [
                      TyperAnimatedText(
                        allStory[storyState.currentIndex].word,
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