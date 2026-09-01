import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_nobel_app/widget/live2d_character_widget.dart';
import 'package:go_router/go_router.dart';

class UnitySplashScreen extends StatefulWidget {
  const UnitySplashScreen({super.key});

  @override
  State<UnitySplashScreen> createState() => _UnitySplashScreenState();
}

class _UnitySplashScreenState extends State<UnitySplashScreen> {
  Timer? _timer;
  bool _hasNavigated = false;
  bool _isFadingOut = false;

  @override
  void initState() {
    super.initState();

    // 2.2秒後に暗転（フェードアウト）開始
    _timer = Timer(const Duration(milliseconds: 2200), () {
      _startFadeOut();
    });
  }

  void _startFadeOut() {
    if (_hasNavigated || !mounted) return;
    setState(() {
      _isFadingOut = true;
    });

    // 500msの暗転アニメーション完了後に画面遷移
    Future.delayed(const Duration(milliseconds: 500), () {
      _navigateToNext();
    });
  }

  void _navigateToNext() {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;
    _timer?.cancel();
    context.go('/splash');
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (!_isFadingOut) {
            _startFadeOut();
          } else {
            _navigateToNext();
          }
        },
        child: Stack(
          children: [
            const Positioned.fill(
              child: Live2DCharacterWidget(),
            ),
            // キャラクター表示前の暗転用オーバーレイ
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: _isFadingOut ? 1.0 : 0.0,
                  child: const SizedBox.expand(
                    child: ColoredBox(color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
