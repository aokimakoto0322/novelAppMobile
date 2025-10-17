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

  @override
  void initState() {
    super.initState();

    // フレーム描画後にopacityを変更し、ふわっと表示させる
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _opacity = 1;
      });
    });
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
          child: Image.asset(
            'images/character/${widget.character1}',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}