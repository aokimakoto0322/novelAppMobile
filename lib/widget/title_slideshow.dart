import 'dart:async';
import 'package:flutter/material.dart';

class TitleSlideshow extends StatefulWidget {
  const TitleSlideshow({super.key});

  @override
  State<TitleSlideshow> createState() => _TitleSlideshowState();
}

class _TitleSlideshowState extends State<TitleSlideshow> {
  final List<String> _images = [
    'images/sample1.jpg',
    'images/sample2.jpg',
    'images/sample3.jpg',
  ];
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 7), (timer) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _images.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // スライドショーの背景
        AnimatedSwitcher(
          duration: const Duration(seconds: 2),
          child: Image.asset(
            _images[_currentIndex],
            key: ValueKey<int>(_currentIndex),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        // タイトルロゴのオーバーレイ（既存のtitle.png）
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.transparent,
                Colors.black.withOpacity(0.6),
              ],
            ),
          ),
        )
      ],
    );
  }
}
