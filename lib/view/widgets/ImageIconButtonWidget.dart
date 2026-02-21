import 'package:flutter/material.dart';

class ImageIconButton extends StatelessWidget {
  final String imagePath;
  final VoidCallback? onPressed;
  final double size;

  const ImageIconButton({
    super.key,
    required this.imagePath,
    this.onPressed,
    this.size = 22,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Image.asset(
        imagePath,
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
      onPressed: onPressed,
    );
  }
}