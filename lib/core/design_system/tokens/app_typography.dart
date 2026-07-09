import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract class AppTypography {
  static const String _fontFamily = 'Poppins';
  static const TextStyle heading1 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700, // Bold
    color: AppColors.textPrimary,
  );
  static const TextStyle heading2 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600, // SemiBold
    color: AppColors.textPrimary,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600, // Semi-bold
    letterSpacing: 0.15,
  );

  static const TextStyle heading4 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600, // SemiBold
    color: AppColors.textPrimary,
  );

  static const TextStyle heading5 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500, // Medium
    color: AppColors.textPrimary,
  );

  static const TextStyle heading6 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500, // Medium
    color: AppColors.textPrimary,
  );
  static const TextStyle buttonText = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle bodyRegular = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400, // Regular
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color:
        AppColors.textPrimary, // Sesuaikan dengan variabel warna default Anda
    letterSpacing: 0.25,
    height: 1.5, // Line height standar untuk keterbacaan (readability)
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400, // Regular
    letterSpacing: 0.4,
  );
  static const TextStyle caption = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    color: Color.fromARGB(255, 116, 115, 115),
    letterSpacing: 0.4,
  );

  static const TextStyle bodySemiBold = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600, // Kunci dari SemiBold
  );
}
