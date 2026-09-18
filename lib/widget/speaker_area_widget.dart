import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_nobel_app/provider/story_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpeakerAreaWidget extends ConsumerWidget {
  const SpeakerAreaWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyState = ref.watch(storyUsecaseProvider);
    final allStory = storyState.allStory;

    if (allStory.isEmpty ||
        storyState.currentIndex < 0 ||
        storyState.currentIndex >= allStory.length) {
      return const SizedBox.shrink();
    }

    final speaker = allStory[storyState.currentIndex].speaker;
    if (speaker.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Positioned(
      left: 20,
      bottom: 190 + bottomPadding + 10,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            // 深いアンビエントシャドウ（macOSの浮遊感と馴染み）
            BoxShadow(
              color: Colors.black.withAlpha(80),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
            // 天面ライン自体の外側への上品な発光オーラ（アウターグロー）
            BoxShadow(
              color: Colors.white.withAlpha(140),
              blurRadius: 8,
              spreadRadius: 0.5,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 32.0, sigmaY: 32.0), // macOS風 Liquid Glass すりガラス効果
            child: Stack(
              children: [
                // 本体（パディング・ガラスグラデーション背景・境界線）
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                  constraints: const BoxConstraints(
                    minWidth: 80,
                    minHeight: 32,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withAlpha(90), // ガラスフレーム全周の縁取り
                      width: 1.0,
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withAlpha(65), // 天面輝きハイライト
                        Colors.white.withAlpha(20), // 中間の透明感
                        Colors.black.withAlpha(45), // 自然な深み
                        Colors.black.withAlpha(75), // 文字コントラスト保証
                      ],
                      stops: const [0.0, 0.35, 0.7, 1.0],
                    ),
                  ),
                  child: Text(
                    speaker,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.8,
                      shadows: [
                        Shadow(
                          color: Colors.black.withAlpha(140),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),

                // 上部エッジ最先端にぴったり配置された鮮烈な発光リムライン
                Positioned(
                  top: 0,
                  left: 12,
                  right: 12,
                  child: Container(
                    height: 1.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1),
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.white.withAlpha(180),
                          Colors.white, // 中心部は密度の高い純白
                          Colors.white.withAlpha(180),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withAlpha(220), // リムライン自体の強力なネオン発光効果
                          blurRadius: 5,
                          spreadRadius: 0.5,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}