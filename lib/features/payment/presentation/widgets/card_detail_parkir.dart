import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/utils/currency_formatter.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';

class CardDetailParkirWidget extends StatelessWidget {
  final String platNomor;
  final String kategoriKendaraan;
  final int nominal;

  const CardDetailParkirWidget({
    super.key,
    required this.platNomor,
    required this.kategoriKendaraan,
    required this.nominal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8E8E8), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("DETAIL PARKIR", style: AppTypography.heading4),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Plat Nomor",
                style: AppTypography.bodyRegular.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(platNomor),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Jenis Kendaraan",
                style: AppTypography.bodyRegular.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(kategoriKendaraan == 'motor' ? 'Motor' : 'Mobil'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tarif",
                style: AppTypography.bodyRegular.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                CurrencyFormatter.toIdr(nominal),
                style: const TextStyle(color: AppColors.primaryDark),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
