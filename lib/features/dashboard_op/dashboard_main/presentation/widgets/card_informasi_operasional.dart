import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import '../../../../../core/design_system/tokens/app_typography.dart';
import '../../../../../core/utils/currency_formatter.dart';

class CardInformasiOperasional extends StatelessWidget {
  final String jamOperasional;
  final int tarifMotor;
  final int tarifMobil;
  // 🚀 BARU
  final bool hasCctv;
  final bool hasEdc;
  final bool hasTs;
  final bool hasQrisRompi;

  const CardInformasiOperasional({
    super.key,
    required this.jamOperasional,
    required this.tarifMotor,
    required this.tarifMobil,
    this.hasCctv = false,
    this.hasEdc = false,
    this.hasTs = false,
    this.hasQrisRompi = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: .06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.timelapse_outlined,
                size: 18,
                color: AppColors.primary,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Informasi Operasional",
                  style: AppTypography.bodySemiBold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Jam Operasional", style: AppTypography.caption),
              const SizedBox(height: 6),
              Text("$jamOperasional  WIB", style: AppTypography.heading2),
            ],
          ),

          const Divider(color: AppColors.border),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Tarif Motor", style: AppTypography.caption),
                    const SizedBox(height: 6),
                    Text(
                      CurrencyFormatter.toIdr(tarifMotor),
                      style: AppTypography.bodySemiBold.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 52, color: AppColors.border),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Tarif Mobil", style: AppTypography.caption),
                      const SizedBox(height: 6),
                      Text(
                        CurrencyFormatter.toIdr(tarifMobil),
                        style: AppTypography.bodySemiBold.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 🚀 BARU: section fasilitas — pola sama kayak Tarif di atas
          // (Divider dulu, baru label kecil, baru kontennya)
          const Divider(color: AppColors.border),
          const Text("Fasilitas", style: AppTypography.caption),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 3.2,
            children: [
              _FacilityChip(
                label: 'EDC',
                icon: Icons.credit_card_rounded,
                isAvailable: hasEdc,
              ),
              _FacilityChip(
                label: 'QRIS Rompi',
                icon: Icons.qr_code_2_rounded,
                isAvailable: hasQrisRompi,
              ),
              _FacilityChip(
                label: 'CCTV',
                icon: Icons.videocam_rounded,
                isAvailable: hasCctv,
              ),
              _FacilityChip(
                label: 'TS',
                icon: Icons.touch_app_rounded,
                isAvailable: hasTs,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 🚀 BARU: chip pill kecil — solid + icon putih kalau tersedia,
// outline abu pudar kalau enggak (biar beda jelas tanpa keliatan "kosong/error")
// 🚀 GANTI: badge lingkaran sekarang nampilin status (check/close),
// icon fasilitas (CCTV/EDC/dst) dipindah jadi aksen kecil di sebelah teks
class _FacilityChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isAvailable;

  const _FacilityChip({
    required this.label,
    required this.icon,
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isAvailable
            ? AppColors.success.withValues(alpha: .10)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isAvailable
              ? AppColors.success.withValues(alpha: .3)
              : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          // 🚀 GANTI: badge sekarang nunjukin status (✓ / ✕), bukan icon fasilitas
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isAvailable ? AppColors.success : Colors.grey.shade300,
            ),
            child: Icon(
              isAvailable ? Icons.check_rounded : Icons.close_rounded,
              size: 13,
              color: isAvailable ? Colors.white : Colors.grey.shade500,
            ),
          ),
          const SizedBox(width: 6),

          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.caption.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 11.5,
                color: isAvailable
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
