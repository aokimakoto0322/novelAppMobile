import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_nobel_app/provider/story_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextAreaWidget extends ConsumerWidget {
  const TextAreaWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyUsecase = ref.read(storyUsecaseProvider.notifier);
    final storyState = ref.watch(storyUsecaseProvider);
    final allStory = storyState.allStory;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        color: Colors.blue.withAlpha(100),
        alignment: Alignment.topLeft,
        height: 180,
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Align(
            alignment: Alignment.topLeft,
            child: storyState.isWaiting
                ? SizedBox.shrink()
                : Stack(
                  children: [
                    // 袋文字のふち（黒）
                    AnimatedTextKit(
                      key: ValueKey<String>('stroke_${allStory[storyState.currentIndex].word}'),
                      animatedTexts: [
                        TyperAnimatedText(
                          allStory[storyState.currentIndex].word,
                          textStyle: TextStyle(
                            fontSize: 18,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 2
                              ..color = Colors.black,
                          ),
                        )
                      ],
                      totalRepeatCount: 1,
                      displayFullTextOnTap: true,
                      onTap: () {
                        if (storyState.isDisplayingChoicePrompt) {
                          storyUsecase.displayChoiceScreen();
                        }
                      },
                    ),

                    // 袋文字の本体（白）
                    AnimatedTextKit(
                      key: ValueKey<String>('fill_${allStory[storyState.currentIndex].word}'),
                      animatedTexts: [
                        TyperAnimatedText(
                          allStory[storyState.currentIndex].word + '[${storyState.currentIndex + 1}]',
                          textStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        )
                      ],
                      totalRepeatCount: 1,
                      displayFullTextOnTap: true,
                      onFinished: () {
                        if (storyState.isDisplayingChoicePrompt) {
                          storyUsecase.displayChoiceScreen();
                        }
                      },
                    ),
                  ],
                ),
          ),
        ),
      ),
    );
  }
}