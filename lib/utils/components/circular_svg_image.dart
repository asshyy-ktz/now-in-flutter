import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CircularSvgImage extends StatelessWidget {
  final String imagePath;
  final double size;

  const CircularSvgImage({
    super.key,
    required this.imagePath,
    this.size = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: SvgPicture.asset(
        imagePath,
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}
