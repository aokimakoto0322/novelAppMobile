import 'package:flutter/material.dart';

class FabIconWidget extends StatelessWidget {
  final double width;
  final double height;
  final IconData iconData;
  final VoidCallback onPressed;

  const FabIconWidget({
    super.key,
    required this.width,
    required this.height,
    required this.iconData,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Color(0xff645478),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(
          iconData,
          color: Color(0xffAEA6B6),
        ),
      ),
    );
  }
}