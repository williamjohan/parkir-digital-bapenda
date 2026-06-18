import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';

import '../../../../core/design_system/tokens/app_colors.dart';

class CardTotalOpWidget extends StatelessWidget {
  final int totalObjekPajak;
  final int totalOpDigitalisasi;
  final int totalOpNonDigitalisasi;

  const CardTotalOpWidget({
    super.key,
    required this.totalObjekPajak,
    required this.totalOpDigitalisasi,
    required this.totalOpNonDigitalisasi,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: itemCard(
            title: "Total Objek",
            jml: totalObjekPajak,
            icon: Icons.file_copy_outlined,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: itemCard(
            title: "Digitalisasi",
            jml: totalOpDigitalisasi,
            icon: Icons.check_circle_outline,
            color: AppColors.success,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: itemCard(
            title: "Non-Digital",
            jml: totalOpNonDigitalisasi,
            icon: Icons.cancel_outlined,
            color: AppColors.error,
          ),
        ),
      ],
    );
  }
}

Widget itemCard({
  required String title,
  required int jml,
  required IconData icon,
  required Color color,
}) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.border),
      color: Colors.white,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: color.withValues(alpha: 0.15),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTypography.bodySmall,
        ),
        const SizedBox(height: 4),
        Text(
          jml.toString(),
          style: AppTypography.heading4.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
