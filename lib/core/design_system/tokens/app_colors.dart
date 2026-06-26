import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color primary = Color(0xFFe48901);
  static const Color primaryLight = Color(0xFFfeb74d);
  static const Color primaryDark = Color(0xFFbf7200);
  static const Color background = Color(
    0xFFF5F7FA,
  ); // Abu-abu sangat muda untuk background
  static const Color surface = Colors.white; // Background card/container
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA000);
  static const Color info = Color(0xFF2196F3);
  static const Color disabled = Color(0xFFC7C7C7);

  static const Color border = Color(0xFFE0E0E0);

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryDark, primary],
  );
}
