// lib/core/design_system/components/primary_button.dart

import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_typography.dart';

class PbPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool isOutlined;
  final bool isSecondary;

  const PbPrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.isOutlined = false,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    Color borderColor;

    if (isOutlined) {
      backgroundColor = Colors.transparent;
      textColor = AppColors.primary;
      borderColor = AppColors.primary;
    } else if (isSecondary) {
      backgroundColor = AppColors.background; // tambahin di AppColors
      textColor = AppColors.primary;
      borderColor = Colors.transparent;
    } else {
      backgroundColor = AppColors.primary;
      textColor = Colors.white;
      borderColor = Colors.transparent;
    }

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          disabledBackgroundColor: isOutlined
              ? Colors.transparent
              : AppColors.primaryLight,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: borderColor, width: isOutlined ? 1.5 : 0),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: textColor,
                  strokeWidth: 3,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: textColor, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      text,
                      style: AppTypography.buttonText.copyWith(
                        color: textColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
