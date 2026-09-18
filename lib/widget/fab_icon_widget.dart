import 'package:flutter/material.dart';

class FabIconWidget extends StatelessWidget {
  final double width;
  final double height;
  final IconData iconData;
  final String label;
  final VoidCallback onPressed;

  const FabIconWidget({
    super.key,
    required this.width,
    required this.height,
    required this.iconData,
    required this.label,
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
          color: Color.fromARGB(255, 166, 143, 197),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              color: Colors.white,
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            )
          ],
        ),
      ),
    );
  }
}