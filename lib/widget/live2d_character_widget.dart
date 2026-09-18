import 'package:flutter/material.dart';
import 'package:flutter_nobel_app/provider/live2d_provider.dart';
import 'package:flutter_nobel_app/provider/story_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Live2DCharacterWidget extends ConsumerWidget {
  const Live2DCharacterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final live2dState = ref.watch(live2dProvider);
    final storyState = ref.watch(storyUsecaseProvider);

    final allStory = storyState.allStory;
    final currentIndex = storyState.currentIndex;

    // character1や背景画像の状態変化を監視して、Unity側へ通知する
    ref.listen(storyUsecaseProvider, (previous, next) {
      final prevStory = (previous != null &&
              previous.allStory.isNotEmpty &&
              previous.currentIndex < previous.allStory.length)
          ? previous.allStory[previous.currentIndex]
          : null;
      final nextStory = (next.allStory.isNotEmpty &&
              next.currentIndex < next.allStory.length)
          ? next.allStory[next.currentIndex]
          : null;

      final prevChar = prevStory?.character1.trim() ?? '';
      final nextChar = nextStory?.character1.trim() ?? '';
      final nextEffect = nextStory?.character1Effect.trim() ?? '';
      final prevEffect = prevStory?.character1Effect.trim() ?? '';

      if (prevChar != nextChar || prevEffect != nextEffect) {
        // Unity(CharacterManager)側へキャラクター名および演出名を送信
        ref.read(live2dProvider.notifier).changeCharacter(
              nextChar,
              effect: nextEffect,
            );
      }

      final prevBg = previous?.backGroundImage ?? '';
      final nextBg = next.backGroundImage;
      if (prevBg != nextBg) {
        // Unity(BackgroundManager)側へ背景画像名を送信
        ref.read(live2dProvider.notifier).changeBackground(nextBg);
      }
    });

    // Unityのロード完了時に初期データ(背景・キャラクター)を送信し、キャンバスを表示する
    ref.listen(live2dProvider, (previous, next) {
      if ((previous == null || !previous.isUnityLoaded) && next.isUnityLoaded) {
        final currentStory = (allStory.isNotEmpty && currentIndex < allStory.length)
            ? allStory[currentIndex]
            : null;
        final currentChar = currentStory?.character1.trim() ?? '';
        final currentEffect = currentStory?.character1Effect.trim() ?? '';
        final currentBg = storyState.backGroundImage;

        ref.read(live2dProvider.notifier).changeCharacter(
              currentChar,
              effect: currentEffect,
            );
        ref.read(live2dProvider.notifier).changeBackground(currentBg);
        ref.read(live2dProvider.notifier).showCanvas();
      }
    });

    if (!live2dState.isInitialized || live2dState.controller == null) {
      return const SizedBox.shrink(); // 準備中は何も表示しない
    }

    // WebView全体は背景を描画するために常に表示し、キャラクターのみUnity側でSetActive制御する
    return Listener(
      onPointerDown: (PointerDownEvent event) {
        // Unityのロードが完了していない場合はJS呼び出しを行わない
        if (!live2dState.isUnityLoaded) {
          return;
        }

        final localPosition = event.localPosition;
        final x = localPosition.dx;
        final y = localPosition.dy;

        print('Live2Dがタップされたよ！ 座標: X=$x, Y=$y');

        // WebView（Unity内）のJavaScript関数を呼んで座標を伝える
        live2dState.controller!.runJavaScript('''
          if (typeof window.onScreenTap === "function") {
            window.onScreenTap($x, $y);
          }
        ''');
      },
      behavior: HitTestBehavior.translucent, 
      child: WebViewWidget(controller: live2dState.controller!),
    );
  }
}