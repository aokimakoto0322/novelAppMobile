import 'package:flutter/material.dart';

class ImageScreenWidget extends StatelessWidget {
  final String backgroundImage;

  const ImageScreenWidget({
    super.key,
    required this.backgroundImage
  });
  
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(seconds: 2),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: Container(
        key: ValueKey(backgroundImage),
        child: Image.asset(
          'images/$backgroundImage',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}