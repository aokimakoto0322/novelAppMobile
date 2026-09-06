import 'package:flutter/material.dart';

class TitleButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const TitleButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      height: 50,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.white, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          backgroundColor: Colors.black.withOpacity(0.3),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            shadows: [Shadow(color: Colors.black, blurRadius: 4)],
          ),
        ),
      ),
    );
  }
}
