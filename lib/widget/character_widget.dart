import 'package:flutter/material.dart';

class CharacterWidget extends StatefulWidget {
  final String character1;

  const CharacterWidget({
    super.key,
    required this.character1
  });
  
  @override
  State<CharacterWidget> createState() => _CharacterWidgetState();
}

class _CharacterWidgetState extends State<CharacterWidget> {
  double _opacity = 0;
  String? _currentCharacter;

  @override
  void initState() {
    super.initState();
    _currentCharacter = widget.character1.isNotEmpty ? widget.character1 : null;
    _opacity = widget.character1.isNotEmpty ? 1 : 0;
  }

  @override
  void didUpdateWidget(covariant CharacterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.character1 != widget.character1) {
      if (widget.character1.isNotEmpty) {
        setState(() {
          _currentCharacter = widget.character1;
          _opacity = 1;
        });
      } else {
        setState(() {
          _opacity = 0;
        });
        // 画像を消した後に履歴も消す（アニメーション後）
        Future.delayed(Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {
              _currentCharacter = null;
            });
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.center,
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          opacity: _opacity,
          child: _currentCharacter != null
              ? Image.asset(
                  'images/character/$_currentCharacter',
                  fit: BoxFit.contain,
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}