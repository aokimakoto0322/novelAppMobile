import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_nobel_app/provider/live2d_provider.dart';
import 'package:flutter_nobel_app/widget/live2d_character_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UnitySplashScreen extends ConsumerStatefulWidget {
  const UnitySplashScreen({super.key});

  @override
  ConsumerState<UnitySplashScreen> createState() => _UnitySplashScreenState();
}

class _UnitySplashScreenState extends ConsumerState<UnitySplashScreen> {
  Timer? _fallbackTimer;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();

    // 万が一のタイムアウト（20秒経過しても検知できない場合のフォールバック）
    _fallbackTimer = Timer(const Duration(seconds: 20), () {
      if (!_hasNavigated && mounted) {
        _navigateToNext();
      }
    });
  }

  void _navigateToNext() {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;
    _fallbackTimer?.cancel();
    ref.read(live2dProvider.notifier).hideCanvas();
    context.go('/splash');
  }

  @override
  void dispose() {
    _fallbackTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final live2dState = ref.watch(live2dProvider);

    // JSから 「Made with Unity」 の終了通知（unity_splash_finished）を受け取ったら音量注意画面へ遷移
    if (live2dState.isUnitySplashFinished && !_hasNavigated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateToNext();
      });
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // Unityのロード完了後であればタップでスキップ可能
          if (live2dState.isUnityLoaded) {
            _navigateToNext();
          }
        },
        child: const Stack(
          children: [
            Positioned.fill(
              child: Live2DCharacterWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
