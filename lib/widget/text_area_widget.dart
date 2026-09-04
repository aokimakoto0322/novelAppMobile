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
  late Animation<double> _bounceAnimation;
  late Animation<double> _pulseScaleAnimation;
  late Animation<double> _pulseOpacityAnimation;
  bool _isTextFinished = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: 0.0, end: -6.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _pulseScaleAnimation = Tween<double>(begin: 0.9, end: 1.25).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _pulseOpacityAnimation = Tween<double>(begin: 0.5, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
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

    final hasValidStory = allStory.isNotEmpty &&
        storyState.currentIndex >= 0 &&
        storyState.currentIndex < allStory.length;

    return Positioned(
      left: 12,
      right: 12,
      bottom: 12,
      child: GestureDetector(
        onTap: _handleTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: 190 + bottomPadding,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            border: Border.all(
              color: Colors.white.withAlpha(35), // 邪魔しない超薄い境界線
              width: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF64FFDA).withAlpha(20), // 非常に控えめな光
                blurRadius: 16,
                spreadRadius: 0,
                offset: const Offset(0, -1),
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withAlpha(50), // かなり透明度を高く（キャラクターがしっかり見える）
                Colors.black.withAlpha(100),
                Colors.black.withAlpha(140),
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // すりガラス効果
              child: Stack(
                children: [

                // 上部ネオンアクセントライン
                Positioned(
                  top: 0,
                  left: 30,
                  right: 30,
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          const Color(0xFF64FFDA).withAlpha(180),
                          Colors.white.withAlpha(220),
                          const Color(0xFF64FFDA).withAlpha(180),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // テキスト表示エリア
                Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 24,
                    bottom: bottomPadding + 28,
                  ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: storyState.isWaiting || !hasValidStory
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
                                      fontSize: 17,
                                      height: 1.4,
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 2.5
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
                                      fontSize: 17,
                                      height: 1.4,
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

                // テキスト表示完了時の「TAP ▼」バウンス & パルス波紋インジケータ
                if (_isTextFinished && !storyState.isChoice && !storyState.isWaiting)
                  Positioned(
                    right: 16,
                    bottom: bottomPadding + 12,
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            // パルス波紋
                            Transform.scale(
                              scale: _pulseScaleAnimation.value,
                              child: Container(
                                width: 72,
                                height: 28,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: const Color(0xFF64FFDA)
                                      .withValues(alpha: _pulseOpacityAnimation.value),
                                ),
                              ),
                            ),
                            // バウンスする「TAP ▼」本体
                            Transform.translate(
                              offset: Offset(0, _bounceAnimation.value),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withAlpha(180),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: const Color(0xFF64FFDA).withAlpha(200),
                                    width: 1.2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF64FFDA).withAlpha(90),
                                      blurRadius: 8,
                                      spreadRadius: 0.5,
                                    ),
                                  ],
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'TAP',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF64FFDA),
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      '▼',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                // テキスト再生中の「SKIP ▶」案内ヒント
                if (!_isTextFinished && !storyState.isChoice && !storyState.isWaiting)
                  Positioned(
                    right: 16,
                    bottom: bottomPadding + 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(100),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white.withAlpha(40),
                          width: 0.8,
                        ),
                      ),
                      child: Text(
                        'TAP TO SKIP',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withAlpha(140),
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  }
}