// lib/core/design_system/components/pb_show_dialog.dart

import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_typography.dart';

class PbShowDialog {
  /// Menampilkan modal dialog yang wajib di-klik oleh pengguna (Anti-Spam/Blocking).
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String description,
    IconData icon = Icons.warning_amber_outlined,
    Color iconColor = AppColors.error, // Default hijau untuk sukses
    String buttonText = 'Keluar',
    VoidCallback? onConfirm, // Aksi tambahan saat tombol ditekan
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // WAJIB tekan tombol, tidak bisa tap di luar
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Sesuaikan tinggi dengan konten
            children: [
              Icon(icon, color: iconColor, size: 80),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTypography.heading2.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: AppTypography.bodyRegular.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        // 1. Selalu tutup modalnya terlebih dahulu
                        Navigator.of(dialogContext).pop();
                      },
                      child: Text(
                        "Batal",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        // 1. Selalu tutup modalnya terlebih dahulu
                        Navigator.of(dialogContext).pop();

                        // 2. Eksekusi fungsi tambahan jika ada (misal: kembali ke Home)
                        if (onConfirm != null) {
                          onConfirm();
                        }
                      },
                      child: Text(
                        buttonText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
