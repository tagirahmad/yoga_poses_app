import 'package:flutter/material.dart';
import 'package:teenyTinyOm/app/constants/app_colors.dart';
import 'package:teenyTinyOm/app/constants/dimensions.dart';
import 'package:teenyTinyOm/app/widgets/custom_button.dart';

class HomeMenuButton extends CustomButton {
  final String buttonText;
  final VoidCallback? onTap;
  final TextStyle? style;

  HomeMenuButton({
    required this.buttonText,
    this.onTap,
    this.style,
  }) : super(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: Dimensions.SIDE_INDENT,
            ),
            decoration: BoxDecoration(
              color: AppColors.WHITE_GREY,
              border: Border(
                top: BorderSide(
                  color: AppColors.GREY,
                  width: 2.0,
                ),
                bottom: BorderSide(
                  color: AppColors.GREY,
                  width: 2.0,
                ),
              ),
            ),
            child: Text(
              buttonText,
              textAlign: TextAlign.center,
              style: style,
            ),
          ),
        );
}
