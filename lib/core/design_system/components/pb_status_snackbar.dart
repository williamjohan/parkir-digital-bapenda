import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_typography.dart';

class PbStatusSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    bool isError = false,
    bool isInfo = false, // 🚀 NEW: Tambahan parameter untuk status Pending/Info
    Duration duration = const Duration(seconds: 3),
    IconData? customIcon,
  }) {
    final overlayState = Overlay.of(context);
    late OverlayEntry overlayEntry;
    final Color backgroundColor;
    final IconData iconData;

    if (isError) {
      backgroundColor = AppColors.error;
      iconData = customIcon ?? Icons.error_outline;
    } else if (isInfo) {
      backgroundColor = Colors.blue.shade600;
      iconData =
          customIcon ??
          Icons.hourglass_top_outlined; // Ikon jam pasir untuk pending
    } else {
      backgroundColor = AppColors.success;
      iconData = customIcon ?? Icons.check_circle_outline;
    }

    overlayEntry = OverlayEntry(
      builder: (context) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutBack, // Animasi membal yang elegan
          builder: (context, value, child) {
            return Positioned(
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
                          color: backgroundColor.withValues(alpha: 0.3),
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
    overlayState.insert(overlayEntry);
    Future.delayed(duration, () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}
