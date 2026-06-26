import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_typography.dart';

enum PbButtonVariant {
  primary,
  secondary,
  outlinedPrimary,
  outlinedSecondaryLight,
  outlinedSecondaryDark,
}

enum PbButtonSize { regular, small, medium }

class PbPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? iconLeft;
  final IconData? iconRight;
  final PbButtonVariant variant;
  final PbButtonSize size;

  const PbPrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.iconLeft,
    this.iconRight,
    this.variant = PbButtonVariant.primary,
    this.size = PbButtonSize.regular,
  });

  @override
  Widget build(BuildContext context) {
    late Color backgroundColor;
    late Color textColor;
    late Color borderColor;

    switch (variant) {
      case PbButtonVariant.primary:
        backgroundColor = AppColors.primary;
        textColor = Colors.white;
        borderColor = Colors.transparent;
        break;

      case PbButtonVariant.secondary:
        backgroundColor = AppColors.background;
        textColor = AppColors.primary;
        borderColor = Colors.transparent;
        break;

      case PbButtonVariant.outlinedPrimary:
        backgroundColor = Colors.transparent;
        textColor = AppColors.primary;
        borderColor = AppColors.primary;
        break;

      case PbButtonVariant.outlinedSecondaryLight:
        backgroundColor = Colors.transparent;
        textColor = Colors.white;
        borderColor = Colors.white;
        break;

      case PbButtonVariant.outlinedSecondaryDark:
        backgroundColor = Colors.transparent;
        textColor = Colors.grey.shade700;
        borderColor = Colors.grey.shade400;
        break;
    }

    final double height = size == PbButtonSize.small ? 40 : 52;
    final double fontSize = size == PbButtonSize.small ? 12 : 14;
    final double iconSize = size == PbButtonSize.small ? 16 : 20;

    final bool isOutlined =
        variant == PbButtonVariant.outlinedPrimary ||
        variant == PbButtonVariant.outlinedSecondaryLight ||
        variant == PbButtonVariant.outlinedSecondaryDark;

    final bool isTextEmpty = text.trim().isEmpty;
    final bool useSpaceBetween = iconRight != null;

    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          disabledBackgroundColor: isOutlined
              ? Colors.transparent
              : AppColors.textHint,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: borderColor, width: isOutlined ? 1.5 : 0),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                height: iconSize,
                width: iconSize,
                child: CircularProgressIndicator(
                  color: textColor,
                  strokeWidth: 3,
                ),
              )
            : isTextEmpty
            ? Center(
                child: iconLeft != null
                    ? Icon(iconLeft, color: textColor, size: iconSize)
                    : iconRight != null
                    ? Icon(iconRight, color: textColor, size: iconSize)
                    : const SizedBox(),
              )
            : Row(
                mainAxisAlignment: useSpaceBetween
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (iconLeft != null) ...[
                        Icon(iconLeft, color: textColor, size: iconSize),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        text,
                        style: AppTypography.buttonText.copyWith(
                          color: textColor,
                          fontSize: fontSize,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),

                  if (iconRight != null)
                    Icon(iconRight, color: textColor, size: iconSize),
                ],
              ),
      ),
    );
  }
}
