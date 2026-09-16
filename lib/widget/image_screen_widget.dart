import 'dart:ui';
import 'package:flutter/material.dart';

class ImageScreenWidget extends StatelessWidget {
  final String backgroundImage;
  final bool isBlurred;

  const ImageScreenWidget({
    super.key,
    required this.backgroundImage,
    this.isBlurred = true,
  });
  
  @override
  Widget build(BuildContext context) {
    if (backgroundImage.isNotEmpty) {
      return AnimatedSwitcher(
        duration: const Duration(seconds: 2),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: Stack(
          key: ValueKey(backgroundImage),
          fit: StackFit.expand,
          children: [
            // 1. 背面のぼかし背景（全画面をカバーして余白を綺麗に埋める）
            if (isBlurred)
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Image.asset(
                  'images/$backgroundImage',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
              ),
            if (isBlurred)
              Container(
                color: Colors.black.withValues(alpha: 0.3),
              ),

            // 2. 前面のメイン背景（アスペクト比維持・縦幅フィット・上端合わせ）
            Image.asset(
              'images/$backgroundImage',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fitHeight,
              alignment: Alignment.topCenter,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}