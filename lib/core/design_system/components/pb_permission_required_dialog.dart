import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_typography.dart';

class PermissionRequiredDialog extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback? onConfirm;
  final String confirmText;

  const PermissionRequiredDialog({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.onConfirm,
    this.confirmText = "Aktifkan",
  });

  static Future<void> show(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    VoidCallback? onConfirm,
    String confirmText = "Aktifkan",
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PermissionRequiredDialog(
        icon: icon,
        title: title,
        description: description,
        onConfirm: onConfirm,
        confirmText: confirmText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 34,
              backgroundColor: AppColors.primary.withValues(alpha: 0.08),
              child: Icon(icon, size: 36, color: AppColors.primary),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.heading4,
            ),
            const SizedBox(height: 10),
            Text(
              description,
              textAlign: TextAlign.center,
              style: AppTypography.bodyRegular.copyWith(
                color: AppColors.textHint,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Nanti",
                      style: AppTypography.bodyRegular.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () async {
                      Navigator.pop(context);

                      if (onConfirm != null) {
                        onConfirm!();
                      } else {
                        openAppSettings();
                      }
                    },
                    child: Text(
                      confirmText,
                      style: AppTypography.bodyRegular.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
