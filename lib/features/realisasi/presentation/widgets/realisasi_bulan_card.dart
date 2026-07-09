import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/realisasi_entity.dart';

class RealisasiBulanCard extends StatelessWidget {
  final RealisasiEntity item;

  const RealisasiBulanCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final bool isMinus = item.selisih < 0;
    final Color selisihColor = isMinus
        ? Colors.red.shade600
        : Colors.green.shade600;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.bulanNama.toUpperCase(),
            style: AppTypography.bodySemiBold.copyWith(
              color: AppColors.textPrimary,
              letterSpacing: 0.5,
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: AppColors.border),
          ),
          _buildDataRow(
            'Target',
            CurrencyFormatter.toIdr(item.akpTarget.toInt()),
          ),
          const SizedBox(height: 8),

          _buildDataRow(
            'Realisasi',
            CurrencyFormatter.toIdr(item.realisasi.toInt()),
          ),
          const SizedBox(height: 8),

          _buildDataRow('Pencapaian', '${item.pencapaian.toStringAsFixed(2)}%'),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: AppColors.border),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Selisih',
                style: AppTypography.bodySemiBold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                CurrencyFormatter.toIdr(item.selisih.toInt()),
                style: AppTypography.bodySemiBold.copyWith(color: selisihColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodyRegular.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTypography.bodySemiBold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
