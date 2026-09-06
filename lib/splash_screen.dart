import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  Timer? _timer;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeInAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();

    // 2.5秒後に自動でタイトル画面へ遷移
    _timer = Timer(const Duration(milliseconds: 2500), () {
      _navigateToTitle();
    });
  }

  Future<void> _navigateToTitle() async {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;
    _timer?.cancel();
    
    // スプラッシュ要素をゆっくりフェードアウトさせる (800ms)
    await _controller.animateTo(0, duration: const Duration(milliseconds: 800));
    if (!mounted) return;
    
    context.go('/title');
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F12),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _navigateToTitle,
        child: FadeTransition(
          opacity: _fadeInAnimation,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.15),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.volume_up_rounded,
                      size: 56,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    '音量にご注意ください',
                    style: GoogleFonts.kosugiMaru(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '本ゲームは音声・BGMが再生されます。\nイヤホン等のご使用をおすすめいたします。',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.kosugiMaru(
                      fontSize: 14,
                      color: Colors.white60,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 48),
                  Text(
                    'タップしてスキップ',
                    style: GoogleFonts.kosugiMaru(
                      fontSize: 12,
                      color: Colors.white38,
                      letterSpacing: 1.0,
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
