import 'dart:math' as math;
import 'package:animated_stack/animated_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nobel_app/provider/backlog_provider.dart';
import 'package:flutter_nobel_app/provider/database_provider.dart';
import 'package:flutter_nobel_app/provider/save_provider.dart';
import 'package:flutter_nobel_app/provider/story_provider.dart';
import 'package:flutter_nobel_app/widget/fab_icon_widget.dart'; // ※パスを適切に調整してください
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart'; // 👈 追加します！
import 'package:go_router/go_router.dart';

class AnimationStackWidget extends ConsumerWidget {
  final Widget foregroundWidget;
  const AnimationStackWidget({super.key, required this.foregroundWidget});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = ref.read(databaseProvider);
    final saveUsecase = ref.read(saveUsecaseProvider);
    final storyState = ref.read(storyUsecaseProvider);
    final backlogUsecase = ref.read(backlogUsecaseProvider);
    final storyUsecase = ref.read(storyUsecaseProvider.notifier);
    final allStory = storyState.allStory;

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationX(math.pi),
      child: AnimatedStack(
        buttonIcon: Icons.menu,
        fabIconColor: Colors.white,
        animateButton: false,
        enableClickToDismiss: true,
        preventForegroundInteractions: true,
        slideAnimationDuration: const Duration(milliseconds: 600),
        buttonAnimationDuration: const Duration(milliseconds: 600),
        backgroundColor: Colors.black,
        fabBackgroundColor: Colors.orangeAccent,
        bottomWidget: const SizedBox.shrink(),
        columnWidget: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationX(math.pi),
          child: Column(
            children: [
              FabIconWidget(
                width: 100,
                height: 60,
                iconData: Icons.save,
                label: 'セーブ',
                onPressed: () async {
                  final newSaveId = await saveUsecase.saveStory(
                    database,
                    allStory[storyState.currentIndex].id,
                  );
                  storyUsecase.initGameScreen(storyState.currentIndex, newSaveId);
                  
                  // 👈 fluttertoast を使って表示します！
                  Fluttertoast.showToast(
                    msg: "ストーリーを保存しました",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM, // 画面下に表示
                    backgroundColor: Colors.grey[800],
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                },
              ),
              const SizedBox(height: 20),
              FabIconWidget(
                width: 60,
                height: 60,
                iconData: Icons.low_priority,
                label: 'バックログ',
                onPressed: () {
                  context.push('/backlog');
                },
              ),
              const SizedBox(height: 20),
              FabIconWidget(
                width: 60,
                height: 60,
                label: 'TOP',
                iconData: Icons.home,
                onPressed: () {
                  showDialog<bool>(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: const Text('確認'),
                      content: const Text('ホーム画面に戻りますか？'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                          },
                          child: const Text('いいえ'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            backlogUsecase.deleteBackLog();
                            storyUsecase.stopBgm();
                            context.go('/title');
                          },
                          child: const Text('はい'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        foregroundWidget: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationX(math.pi),
          child: foregroundWidget,
        ),
      ),
    );
  }
}