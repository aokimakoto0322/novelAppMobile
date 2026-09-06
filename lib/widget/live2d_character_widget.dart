import 'package:flutter/material.dart';
import 'package:flutter_nobel_app/provider/live2d_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Live2DCharacterWidget extends ConsumerWidget {
  const Live2DCharacterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final live2dState = ref.watch(live2dProvider);

    if (!live2dState.isInitialized || live2dState.controller == null) {
      return const SizedBox.shrink(); // 準備中は何も表示しない
    }

    // タップ位置を検知するために Listener または GestureDetector を使う
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
      // 完全に下にタップを透過させたい場合は HitTestBehavior を調整します
      behavior: HitTestBehavior.translucent, 
      child: WebViewWidget(controller: live2dState.controller!),
    );
  }
}