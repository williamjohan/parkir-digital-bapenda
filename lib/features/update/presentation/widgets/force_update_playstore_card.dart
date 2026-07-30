import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/design_system/components/pb_primary_button.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/update_entity.dart';

class ForceUpdatePlaystoreCard extends StatelessWidget {
  final UpdateEntity update;

  const ForceUpdatePlaystoreCard({super.key, required this.update});

  Future<void> _launchPlayStore() async {
    final Uri playStoreUrl = Uri.parse(
      "https://play.google.com/store/apps/details?id=id.go.surabaya.tsparkbapenda",
    );
    try {
      if (await canLaunchUrl(playStoreUrl)) {
        await launchUrl(playStoreUrl, mode: LaunchMode.externalApplication);
      } else {
        AppLogger.error("Gagal membuka Google Play Store");
      }
    } catch (e, stackTrace) {
      AppLogger.error("Exception saat membuka Play Store", e, stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(28.0),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shop_rounded, // Ikon Store
                  size: 48,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Pembaruan Sistem Wajib",
                style: AppTypography.heading5,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Versi Terbaru v${update.versionName}",
                  style: AppTypography.caption.copyWith(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Aplikasi Parkir Surabaya versi terbaru telah tersedia di Google Play Store. Harap perbarui aplikasi untuk melanjutkan.",
                textAlign: TextAlign.center,
                style: AppTypography.bodyRegular.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 28),
              PbPrimaryButton(
                text: "Update di Play Store",
                onPressed: _launchPlayStore,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
