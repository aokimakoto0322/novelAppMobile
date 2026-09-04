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

    // タップイベントを後ろに通すためIgnorePointerで囲む
    return IgnorePointer(
      child: WebViewWidget(controller: live2dState.controller!),
    );
  }
}