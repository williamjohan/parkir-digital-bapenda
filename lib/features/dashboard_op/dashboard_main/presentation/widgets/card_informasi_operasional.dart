import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import '../../../../../core/design_system/tokens/app_typography.dart';
import '../../../../../core/utils/currency_formatter.dart';

class CardInformasiOperasional extends StatelessWidget {
  final String jamOperasional;
  final int tarifMotor;
  final int tarifMobil;

  const CardInformasiOperasional({
    super.key,
    required this.jamOperasional,
    required this.tarifMotor,
    required this.tarifMobil,
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
        ],
      ),
    );
  }
}
