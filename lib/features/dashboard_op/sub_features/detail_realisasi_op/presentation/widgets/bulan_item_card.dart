import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';

class BulanItemCard extends StatelessWidget {
  final String bulan;
  final String sspd;
  final String nominal;

  const BulanItemCard({
    super.key,
    required this.bulan,
    required this.sspd,
    required this.nominal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                bulan,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
              Text(
                sspd,
                style: const TextStyle(fontSize: 12, color: Color(0xFF95A5A6)),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: Color(0xFFEBEBEB)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Realisasi',
                style: AppTypography.caption.copyWith(fontSize: 14),
              ),
              Text(nominal, style: AppTypography.bodySemiBold),
            ],
          ),
        ],
      ),
    );
  }
}
