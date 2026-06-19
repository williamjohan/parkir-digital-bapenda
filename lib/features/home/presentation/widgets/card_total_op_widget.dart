import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/components/pb_primary_button.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';

class CardTotalOpWidget extends StatelessWidget {
  final int totalObjekPajak;
  final int totalOpDigitalisasi;
  final int totalOpNonDigitalisasi;
  final VoidCallback? lihatSemuaOnPressed;

  const CardTotalOpWidget({
    super.key,
    required this.totalObjekPajak,
    required this.totalOpDigitalisasi,
    required this.totalOpNonDigitalisasi,
    required this.lihatSemuaOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    final digitalPercent = totalObjekPajak == 0
        ? 0.0
        : totalOpDigitalisasi / totalObjekPajak;

    final nonDigitalPercent = totalObjekPajak == 0
        ? 0.0
        : totalOpNonDigitalisasi / totalObjekPajak;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "TOTAL OBJEK PAJAK",
                          style: AppTypography.bodySemiBold,
                        ),
                      ],
                    ),
                    // const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              totalObjekPajak.toString(),
                              style: AppTypography.heading1.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            Text(
                              "Objek terdaftar di sistem",
                              style: AppTypography.caption,
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: const LinearGradient(
                              colors: [Color(0xffF3A51D), Color(0xffD57D00)],
                            ),
                          ),
                          child: const Icon(
                            Icons.inventory_2_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// Komposisi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "KOMPOSISI STATUS",
                style: AppTypography.bodyRegular.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                "$totalOpDigitalisasi + $totalOpNonDigitalisasi",
                style: AppTypography.bodyRegular.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 8,
              child: Row(
                children: [
                  Expanded(
                    flex: totalOpDigitalisasi,
                    child: Container(color: AppColors.success),
                  ),
                  Expanded(
                    flex: totalOpNonDigitalisasi,
                    child: Container(color: AppColors.error),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          _statusItem(
            icon: Icons.check,
            iconColor: AppColors.success,
            bgColor: AppColors.success.withOpacity(0.12),
            title: "Digitalisasi",
            subtitle: "Sudah terhubung sistem",
            total: totalOpDigitalisasi,
            percentage: digitalPercent * 100,
          ),

          const SizedBox(height: 14),

          _statusItem(
            icon: Icons.close,
            iconColor: AppColors.error,
            bgColor: AppColors.error.withOpacity(0.12),
            title: "Non-Digital",
            subtitle: "Belum terhubung sistem",
            total: totalOpNonDigitalisasi,
            percentage: nonDigitalPercent * 100,
          ),

          const SizedBox(height: 16),
          PbPrimaryButton(
            text: "Lihat Semua Objek Pajak",
            size: PbButtonSize.small,
            onPressed: lihatSemuaOnPressed,
          ),
        ],
      ),
    );
  }
}

Widget _statusItem({
  required IconData icon,
  required Color iconColor,
  required Color bgColor,
  required String title,
  required String subtitle,
  required int total,
  required double percentage,
}) {
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Row(
      children: [
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: iconColor, size: 28),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.bodySemiBold),
              Text(subtitle, style: AppTypography.caption),
            ],
          ),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(total.toString(), style: AppTypography.heading1),
            Text(
              "${percentage.toStringAsFixed(1)}%",
              style: AppTypography.bodySmall.copyWith(color: iconColor),
            ),
          ],
        ),
      ],
    ),
  );
}
