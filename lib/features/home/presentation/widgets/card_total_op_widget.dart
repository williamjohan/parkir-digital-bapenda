import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/components/pb_primary_button.dart';
import 'package:parkir_digital_bapenda/core/utils/number_formatter.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';

class CardTotalOpWidget extends StatelessWidget {
  final int totalObjekPajak;
  final int totalOpDigitalisasi;
  final int totalOpNonDigitalisasi;
  final int totalOpFreeDigitalisasi;
  final int totalOpNonFreeDigitalisasi;
  final int totalOpFreeNonDigitalisasi;
  final int totalOpNonFreeNonDigitalisasi;
  final VoidCallback? lihatSemuaOnPressed;
  final VoidCallback? onTapDigitalisasi;
  final VoidCallback? onTapNonDigital;
  final double digitalPercent;
  final double nonDigitalPercent;

  const CardTotalOpWidget({
    super.key,
    required this.totalObjekPajak,
    required this.totalOpDigitalisasi,
    required this.totalOpNonDigitalisasi,
    required this.totalOpFreeDigitalisasi,
    required this.totalOpNonFreeDigitalisasi,
    required this.totalOpFreeNonDigitalisasi,
    required this.totalOpNonFreeNonDigitalisasi,
    required this.lihatSemuaOnPressed,
    required this.onTapDigitalisasi,
    required this.onTapNonDigital,
    required this.digitalPercent,
    required this.nonDigitalPercent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24), // Diperbesar sedikit agar tidak sesak
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.grey.shade200,
        ), // Tambahan border tipis
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04), // Shadow dihaluskan
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// === HEADER ===
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "TOTAL OBJEK PAJAK PARKIR",
                      style: AppTypography.bodySemiBold.copyWith(
                        color: Colors.grey.shade600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      NumberFormatter.format(totalObjekPajak.toString()),
                      style: AppTypography.heading1.copyWith(
                        color: AppColors.primary,
                        fontSize: 32, // Angka diperbesar
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Objek terdaftar di sistem",
                      style: AppTypography.caption.copyWith(
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.primary.withValues(alpha: 0.1),
                ),
                child: Icon(
                  Icons.domain_outlined, // Icon gedung lebih representatif
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1),
          ),

          /// === LIST ITEM DIGITALISASI ===
          _statusItem(
            icon: Icons.check_circle_outline,
            iconColor: AppColors.success,
            bgColor: AppColors.success.withValues(alpha: 0.12),
            title: "Digitalisasi",
            subtitle: "Sudah terhubung sistem",
            total: totalOpDigitalisasi,
            percentage: digitalPercent,
            onTap: onTapDigitalisasi,
          ),
          const SizedBox(height: 12),

          /// === LIST ITEM NON-DIGITAL ===
          _statusItem(
            icon: Icons.cancel_outlined,
            iconColor: AppColors.error,
            bgColor: AppColors.error.withValues(alpha: 0.12),
            title: "Belum Digitalisasi",
            subtitle: "Belum terhubung sistem",
            total: totalOpNonDigitalisasi,
            percentage: nonDigitalPercent,
            freeCount: totalOpFreeNonDigitalisasi,
            paidCount: totalOpNonFreeNonDigitalisasi,
            onTap: onTapNonDigital,
          ),

          const SizedBox(height: 24),

          /// === TOMBOL LIHAT SEMUA ===
          PbPrimaryButton(
            text: "Lihat Semua Objek Pajak",
            size: PbButtonSize.medium,
            variant: PbButtonVariant.outlinedPrimary,
            onPressed: lihatSemuaOnPressed,
          ),
        ],
      ),
    );
  }
}

/// WIDGET ANAK STATUS ITEM
Widget _statusItem({
  required IconData icon,
  required Color iconColor,
  required Color bgColor,
  required String title,
  required String subtitle,
  required int total,
  required double percentage,
  int? freeCount,
  int? paidCount,
  required VoidCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade100),
        color: Colors.grey.shade50,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.bodySemiBold),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTypography.caption.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    NumberFormatter.format(total.toString()),
                    style: AppTypography.heading2,
                  ),
                  Text(
                    "${percentage.toStringAsFixed(1)}%",
                    style: AppTypography.caption.copyWith(
                      color: iconColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),

          if (paidCount != null || freeCount != null) ...[
            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: _miniInfoCard(
                    icon: Icons.payments_rounded,
                    title: "Berbayar",
                    value: paidCount!,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _miniInfoCard(
                    icon: Icons.money_off_rounded,
                    title: "Gratis",
                    value: freeCount!,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    ),
  );
}

Widget _miniInfoCard({
  required IconData icon,
  required String title,
  required int value,
  required Color color,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: color.withValues(alpha: 0.15)),
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: AppTypography.caption.copyWith(
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  NumberFormatter.format(value.toString()),
                  style: AppTypography.bodySemiBold.copyWith(color: color),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
