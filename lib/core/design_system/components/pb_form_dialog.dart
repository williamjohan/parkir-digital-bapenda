import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_typography.dart';

class FormResultDialog {
  FormResultDialog._();

  static Future<void> showSuccess(
    BuildContext context, {
    required String title,
    required String description,
    String buttonText = 'OK',
    VoidCallback? onConfirm,
  }) {
    return _show(
      context,
      title: title,
      description: description,
      icon: Icons.check_circle_rounded,
      color: AppColors.success,
      buttonText: buttonText,
      onConfirm: onConfirm,
    );
  }

  static Future<void> showError(
    BuildContext context, {
    required String title,
    required String description,
    String buttonText = 'Coba Lagi',
    VoidCallback? onConfirm,
  }) {
    return _show(
      context,
      title: title,
      description: description,
      icon: Icons.error_rounded,
      color: AppColors.error,
      buttonText: buttonText,
      onConfirm: onConfirm,
    );
  }

  static Future<void> _show(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required String buttonText,
    VoidCallback? onConfirm,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 52),
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTypography.heading3.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyRegular.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      onConfirm?.call();
                    },
                    child: Text(
                      buttonText,
                      style: AppTypography.bodySemiBold.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
