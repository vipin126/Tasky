import 'package:flutter/material.dart';
import 'package:tasky/Const/AppColor.dart';
import 'package:tasky/Const/TextStyle.dart';


class SocialAuthButton extends StatelessWidget {
  final String iconPath; // For local assets or a placeholder for now
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color iconColor;

  const SocialAuthButton({
    super.key,
    required this.iconPath,
    required this.onPressed,
    this.backgroundColor = AppColors.lightGrey,
    this.iconColor = AppColors.darkGrey,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Center(
          // For now, using a placeholder icon, later replace with actual SVG/image
          child: Text(
            iconPath, // Using text as placeholder for icon (e.g., 'f', 'G', 'A')
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}



class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double? width;
  final double height;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColors.primaryPurple,
    this.textColor = AppColors.white,
    this.width,
    this.height = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          elevation: 5, // Shadow
        ),
        child: Text(
          text,
          style: AppTextStyles.buttonText.copyWith(color: textColor),
        ),
      ),
    );
  }
}
