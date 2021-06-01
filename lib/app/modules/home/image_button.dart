import 'package:flutter/material.dart';
import 'package:teenyTinyOm/app/widgets/custom_button.dart';

class ImageButton extends CustomButton {
  ImageButton({
    required this.path,
    this.onTap,
  }) : super(
          child: Image.asset(
            path,
            height: 50.0,
            filterQuality: FilterQuality.high,
          ),
          onTap: onTap,
        );

  final String path;
  final VoidCallback? onTap;
}
