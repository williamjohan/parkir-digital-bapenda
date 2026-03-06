// lib/core/design_system/components/pb_status_snackbar.dart

import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_typography.dart';

class PbStatusSnackbar {
  /// Menampilkan notifikasi elegan di bagian atas layar.
  /// Memiliki proteksi dari overlay keyboard dan komponen lain.
  static void show(
    BuildContext context, {
    required String message,
    bool isError = false,
    Duration duration = const Duration(seconds: 3), // Property durasi dinamis
    IconData? customIcon, // Property icon dinamis
  }) {
    final overlayState = Overlay.of(context);
    late OverlayEntry overlayEntry;

    // Menentukan warna dan ikon berdasarkan tipe status
    final backgroundColor = isError ? AppColors.error : AppColors.success;
    final iconData =
        customIcon ??
        (isError ? Icons.error_outline : Icons.check_circle_outline);

    overlayEntry = OverlayEntry(
      builder: (context) {
        // TweenAnimationBuilder untuk efek animasi turun (drop-down) dan fade-in
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutBack, // Animasi membal yang elegan
          builder: (context, value, child) {
            return Positioned(
              // Jarak dari atas layar ditambah margin agar tidak tertutup notch/status bar
              top: MediaQuery.of(context).padding.top + (16 * value),
              left: 24,
              right: 24,
              child: Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: backgroundColor.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(iconData, color: Colors.white, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            message,
                            style: AppTypography.bodyRegular.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    // Memasukkan widget ke lapisan paling atas (Overlay)
    overlayState.insert(overlayEntry);

    // Menghapus otomatis setelah durasi habis
    Future.delayed(duration, () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}
