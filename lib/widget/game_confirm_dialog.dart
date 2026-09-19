import 'dart:ui';
import 'package:flutter/material.dart';

/// ゲーム風でおしゃれなすりガラス（Liquid Glass）仕様の確認ダイアログを表示する関数
Future<bool?> showGameConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  String cancelText = 'いいえ',
  String confirmText = 'はい',
}) {
  return showGeneralDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black.withAlpha(120),
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (buildContext, animation, secondaryAnimation) {
      return GameConfirmDialog(
        title: title,
        message: message,
        cancelText: cancelText,
        confirmText: confirmText,
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutBack,
      );
      return ScaleTransition(
        scale: Tween<double>(begin: 0.85, end: 1.0).animate(curvedAnimation),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
  );
}

class GameConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String cancelText;
  final String confirmText;

  const GameConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.cancelText = 'いいえ',
    this.confirmText = 'はい',
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      elevation: 0,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 340),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            // 深いアンビエントシャドウ
            BoxShadow(
              color: Colors.black.withAlpha(100),
              blurRadius: 36,
              spreadRadius: 0,
              offset: const Offset(0, 8),
            ),
            // 天面のエッジグロー
            BoxShadow(
              color: Colors.white.withAlpha(25),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 32.0, sigmaY: 32.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withAlpha(80),
                  width: 1.0,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withAlpha(48),
                    Colors.white.withAlpha(16),
                    Colors.black.withAlpha(80),
                    Colors.black.withAlpha(180),
                  ],
                  stops: const [0.0, 0.25, 0.65, 1.0],
                ),
              ),
              child: Stack(
                children: [
                  // ガラス天面の光の屈折ライン（リムハイライト）
                  Positioned(
                    top: 0,
                    left: 20,
                    right: 20,
                    child: Container(
                      height: 1.5,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.white.withAlpha(160),
                            Colors.white.withAlpha(230),
                            Colors.white.withAlpha(160),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                        ),
                      ),
                    ),
                  ),

                  // ダイアログコンテンツ
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 24,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // タイトル表示
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            shadows: [
                              Shadow(
                                color: Colors.black87,
                                blurRadius: 4,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // メッセージ表示
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withAlpha(230),
                            fontSize: 14,
                            height: 1.4,
                            shadows: const [
                              Shadow(
                                color: Colors.black54,
                                blurRadius: 2,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ボタンエリア
                        Row(
                          children: [
                            // キャンセルボタン（いいえ）
                            Expanded(
                              child: _DialogButton(
                                label: cancelText,
                                isAccent: false,
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                              ),
                            ),
                            const SizedBox(width: 12),

                            // 決定ボタン（はい）
                            Expanded(
                              child: _DialogButton(
                                label: confirmText,
                                isAccent: true,
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
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

class _DialogButton extends StatelessWidget {
  final String label;
  final bool isAccent;
  final VoidCallback onPressed;

  const _DialogButton({
    required this.label,
    required this.isAccent,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFF64FFDA);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        splashColor: isAccent
            ? accentColor.withAlpha(60)
            : Colors.white.withAlpha(40),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isAccent
                ? Colors.black.withAlpha(180)
                : Colors.black.withAlpha(100),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isAccent
                  ? accentColor.withAlpha(200)
                  : Colors.white.withAlpha(60),
              width: isAccent ? 1.2 : 0.8,
            ),
            boxShadow: isAccent
                ? [
                    BoxShadow(
                      color: accentColor.withAlpha(80),
                      blurRadius: 8,
                      spreadRadius: 0.5,
                    ),
                  ]
                : [],
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isAccent ? FontWeight.bold : FontWeight.w500,
              color: isAccent ? accentColor : Colors.white.withAlpha(220),
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}

