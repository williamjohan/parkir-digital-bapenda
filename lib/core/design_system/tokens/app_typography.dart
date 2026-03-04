// lib/core/design_system/tokens/app_typography.dart

import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract class AppTypography {
  static const String _fontFamily = 'Poppins';

  // Digunakan untuk Judul Halaman (misal: "Pilih Kendaraan")
  static const TextStyle heading1 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700, // Bold
    color: AppColors.textPrimary,
  );

  // Digunakan untuk Sub-judul atau hasil OCR utama
  static const TextStyle heading2 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600, // SemiBold
    color: AppColors.textPrimary,
  );

  // Digunakan untuk teks tombol utama
  static const TextStyle buttonText = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600, // SemiBold
    color: Colors.white,
  );

  // Digunakan untuk body text biasa
  static const TextStyle bodyRegular = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400, // Regular
    color: AppColors.textPrimary,
  );

  // Digunakan untuk caption, error message kecil, atau hint text
  static const TextStyle caption = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
}
