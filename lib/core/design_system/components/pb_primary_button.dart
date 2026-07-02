import 'dart:ui';

import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_typography.dart';

enum PbButtonVariant {
  primary,
  secondary,
  secondaryLight, // Varian baru yang ditambahkan
  outlinedPrimary,
  outlinedSecondaryLight,
  outlinedSecondaryDark,
  glassmorphism,
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

      case PbButtonVariant.secondaryLight:
        backgroundColor = Colors.white.withValues(
          alpha: 0.2,
        ); // Putih dengan opacity 0.2
        textColor = Colors.white;
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

      case PbButtonVariant.glassmorphism:
        backgroundColor = Colors.transparent;
        textColor = Colors.white;
        borderColor = Colors.white.withValues(alpha: 0.3);
        break;
    }

    final double height = size == PbButtonSize.small ? 40 : 52;
    final double fontSize = size == PbButtonSize.small ? 12 : 14;
    final double iconSize = size == PbButtonSize.small ? 16 : 20;

    final bool isOutlined =
        variant == PbButtonVariant.outlinedPrimary ||
        variant == PbButtonVariant.outlinedSecondaryLight ||
        variant == PbButtonVariant.outlinedSecondaryDark;

    final bool isGlass = variant == PbButtonVariant.glassmorphism;

    final bool isTextEmpty = text.trim().isEmpty;
    final bool useSpaceBetween = iconRight != null;

    final BorderRadius buttonRadius = isGlass
        ? BorderRadius.circular(100)
        : BorderRadius.circular(12);

    return SizedBox(
      width: double.infinity,
      height: height,
      child: isGlass
          ? ClipRRect(
              borderRadius: buttonRadius,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Material(
                  color: Colors.transparent,
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: 0.15),
                          Colors.white.withValues(alpha: 0.02),
                        ],
                      ),
                      borderRadius: buttonRadius,
                      border: Border.all(color: borderColor, width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: InkWell(
                      borderRadius: buttonRadius,
                      onTap: isLoading ? null : onPressed,
                      child: Center(
                        child: _buildChild(
                          textColor,
                          fontSize,
                          iconSize,
                          useSpaceBetween,
                          isTextEmpty,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                disabledBackgroundColor: isOutlined
                    ? Colors.transparent
                    : AppColors.textHint,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: buttonRadius,
                  side: BorderSide(
                    color: borderColor,
                    width: isOutlined ? 1.5 : 0,
                  ),
                ),
                elevation: 0,
              ),
              child: _buildChild(
                textColor,
                fontSize,
                iconSize,
                useSpaceBetween,
                isTextEmpty,
              ),
            ),
    );
  }

  Widget _buildChild(
    Color textColor,
    double fontSize,
    double iconSize,
    bool useSpaceBetween,
    bool isTextEmpty,
  ) {
    if (isLoading) {
      return SizedBox(
        height: iconSize,
        width: iconSize,
        child: CircularProgressIndicator(color: textColor, strokeWidth: 3),
      );
    }

    if (isTextEmpty) {
      return Center(
        child: iconLeft != null
            ? Icon(iconLeft, color: textColor, size: iconSize)
            : iconRight != null
            ? Icon(iconRight, color: textColor, size: iconSize)
            : const SizedBox(),
      );
    }

    return Row(
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
    );
  }
}
