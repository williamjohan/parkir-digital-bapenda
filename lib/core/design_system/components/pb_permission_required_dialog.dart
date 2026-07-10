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
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: .12),
              blurRadius: 40,
              offset: const Offset(0, 18),
              spreadRadius: -8,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: .04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --- Icon badge with soft glow ---
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withValues(alpha: .16),
                      AppColors.primary.withValues(alpha: .06),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: .18),
                      blurRadius: 24,
                      spreadRadius: -4,
                    ),
                  ],
                ),
                child: Icon(icon, size: 34, color: AppColors.primary),
              ),
              const SizedBox(height: 22),

              // --- Title ---
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTypography.heading4.copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 10),

              // --- Description ---
              Text(
                description,
                textAlign: TextAlign.center,
                style: AppTypography.bodyRegular.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),

              // --- Primary CTA: solid, elevated, unmistakably the main action ---
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    if (onConfirm != null) {
                      onConfirm!();
                    } else {
                      openAppSettings();
                    }
                  },
                  style:
                      ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shadowColor: AppColors.primary.withValues(alpha: .35),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ).copyWith(
                        elevation: WidgetStateProperty.resolveWith(
                          (states) =>
                              states.contains(WidgetState.pressed) ? 0 : 6,
                        ),
                        overlayColor: WidgetStateProperty.all(
                          Colors.white.withValues(alpha: .08),
                        ),
                      ),
                  child: Text(
                    confirmText,
                    style: AppTypography.bodyRegular.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: .2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // --- Secondary action: quiet text button, no visual competition ---
              SizedBox(
                width: double.infinity,
                height: 48,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    overlayColor: AppColors.primary.withValues(alpha: .05),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    "Nanti",
                    style: AppTypography.bodyRegular.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
