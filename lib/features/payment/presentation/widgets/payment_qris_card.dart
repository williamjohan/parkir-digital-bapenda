import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../../core/design_system/tokens/app_typography.dart';
import 'payment_countdown_timer.dart';

class PaymentQrisCard extends StatelessWidget {
  final Widget qrWidget;
  final bool isDownloading;
  final bool isCapturing;
  final bool showTimer;
  final VoidCallback onDownloadTap;

  const PaymentQrisCard({
    super.key,
    required this.qrWidget,
    required this.isDownloading,
    required this.isCapturing,
    required this.showTimer,
    required this.onDownloadTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.06,
            ), // Disesuaikan dengan syntaks Anda
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // HEADER ORANYE
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: Column(
              children: [
                Text(
                  'SCAN UNTUK MEMBAYAR',
                  style: AppTypography.caption.copyWith(
                    color: Colors.white,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Gunakan aplikasi mobile banking / dompet digital',
                  style: AppTypography.caption.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          // 🚀 TIMER PLACEMENT
          // Hanya tampil jika showTimer true DAN tidak sedang di-screenshot/download
          if (showTimer && !isCapturing) ...[
            const SizedBox(height: 16),
            const PaymentCountdownTimer(),
          ],

          // QR IMAGE
          Padding(
            // Padding atas di-adjust agar seimbang jika ada timer atau tidak ada
            padding: EdgeInsets.only(
              top: (showTimer && !isCapturing) ? 12 : 20,
              bottom: 20,
              left: 20,
              right: 20,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: qrWidget,
            ),
          ),

          // FOOTER (Resmi + Tombol Download)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.verified_rounded,
                  size: 14,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  'QRIS Resmi Pemerintah Daerah',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                isCapturing
                    ? const SizedBox.shrink()
                    : InkWell(
                        onTap: isDownloading ? null : onDownloadTap,
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: isDownloading
                              ? const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.primary,
                                  ),
                                )
                              : const Icon(
                                  Icons.download_rounded,
                                  size: 22,
                                  color: AppColors.primary,
                                ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
