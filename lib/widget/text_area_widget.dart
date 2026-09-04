import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_nobel_app/provider/story_provider.dart';
import 'package:flutter_nobel_app/state/story_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextAreaWidget extends ConsumerStatefulWidget {
  final VoidCallback? onTap;

  const TextAreaWidget({
    super.key,
    this.onTap,
  });

  @override
  ConsumerState<TextAreaWidget> createState() => _TextAreaWidgetState();
}

class _TextAreaWidgetState extends ConsumerState<TextAreaWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isTextFinished = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!_isTextFinished) {
      setState(() {
        _isTextFinished = true;
      });
    } else {
      widget.onTap?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final storyUsecase = ref.read(storyUsecaseProvider.notifier);
    final storyState = ref.watch(storyUsecaseProvider);
    final allStory = storyState.allStory;

    ref.listen<StoryState>(storyUsecaseProvider, (previous, next) {
      if (previous?.currentIndex != next.currentIndex) {
        if (mounted) {
          setState(() {
            _isTextFinished = false;
          });
        }
      }
    });

    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: GestureDetector(
        onTap: _handleTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: 200 + bottomPadding,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withAlpha(220),
                Colors.black.withAlpha(160),
                Colors.black.withAlpha(60),
                Colors.transparent,
              ],
              stops: const [0.0, 0.45, 0.8, 1.0],
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 48,
                  bottom: bottomPadding + 16,
                ),
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
                                  '${allStory[storyState.currentIndex].word}[${storyState.currentIndex + 1}]',
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                              totalRepeatCount: 1,
                              displayFullTextOnTap: true,
                              onFinished: () {
                                if (mounted) {
                                  setState(() {
                                    _isTextFinished = true;
                                  });
                                }
                                if (storyState.isDisplayingChoicePrompt) {
                                  storyUsecase.displayChoiceScreen();
                                }
                              },
                            ),
                          ],
                        ),
                ),
              ),

              // テキスト表示完了時の「▼」点滅インジケータ
              if (_isTextFinished && !storyState.isChoice && !storyState.isWaiting)
                Positioned(
                  right: 24,
                  bottom: bottomPadding + 16,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Stack(
                      children: [
                        Text(
                          '▼',
                          style: TextStyle(
                            fontSize: 18,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 2
                              ..color = Colors.black,
                          ),
                        ),
                        const Text(
                          '▼',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}