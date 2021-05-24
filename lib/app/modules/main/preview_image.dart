import 'package:flutter/material.dart';

class PreviewImage extends StatelessWidget {
  const PreviewImage({
    Key? key,
    required this.imagePath,
    required this.imageHeight,
    this.imageWidth,
  }) : super(key: key);

  final String imagePath;
  final double imageHeight;
  final double? imageWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 5.0),
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: Colors.black12,
        ),
      ),
      child: Center(
        child: Image.asset(
          imagePath,
          height: imageHeight,
          width: imageWidth,
        ),
      ),
    );
  }
}
