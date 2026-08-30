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
      left: 10,
      right: 10,
      bottom: MediaQuery.of(context).padding.bottom,
      child: Container(
        height: 180,
        // 外側の青背景＆角丸
        child: Material(
          color: Colors.blue.withAlpha(100),
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            // 外枠から 2px 内側に配置するための余白
            padding: const EdgeInsets.all(2),
            child: Container(
              // 2px 内側の内枠（1px幅の半透明な線）
              decoration: BoxDecoration(
                // 2px内側に配置されるため、角丸も少し小さめ（14）にすると綺麗に沿います
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.white.withAlpha(120), // 白の半透明線（お好みで透明度を調整できます）
                  width: 1, // 1px幅
                ),
              ),
              child: Padding(
                // テキストの配置位置調整（外枠からの余白感にあわせています）
                padding: const EdgeInsets.only(left: 18, right: 18, top: 8),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: storyState.isWaiting
                      ? const SizedBox.shrink()
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
          ),
        ),
      ),
    );
  }
}