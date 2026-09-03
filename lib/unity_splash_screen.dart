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

    // 万が一のタイムアウト（15秒経過してもUnityの起動が検知できない場合のフォールバック）
    _fallbackTimer = Timer(const Duration(seconds: 15), () {
      if (!_hasNavigated && mounted) {
        _navigateToNext();
      }
    });
  }

  void _onUnityLoaded() {
    if (_hasNavigated || !mounted) return;
    _fallbackTimer?.cancel();
    // Unityのロード完了後、キャラクターを描画させずに即座にSplashScreen（音量注意画面）へ遷移
    _navigateToNext();
  }

  void _navigateToNext() {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;
    _fallbackTimer?.cancel();
    context.go('/splash');
  }

  @override
  void dispose() {
    _fallbackTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Unityの読み込み完了を検知
    final live2dState = ref.watch(live2dProvider);
    if (live2dState.isUnityLoaded && !_hasNavigated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _onUnityLoaded();
      });
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _navigateToNext();
        },
        child: Stack(
          children: [
            const Positioned.fill(
              child: Live2DCharacterWidget(),
            ),
            // Unityのロード完了時（キャラクターが描画される瞬間）、画面遷移までのわずかな隙間も黒で完全に隠す
            if (live2dState.isUnityLoaded)
              const Positioned.fill(
                child: ColoredBox(color: Colors.black),
              ),
          ],
        ),
      ),
    );
  }
}
