import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';
import 'package:parkir_digital_bapenda/core/utils/currency_formatter.dart';

class CardRealisasiOp extends StatelessWidget {
  final int nonDigital;
  final int digital;
  final int totalRealisasi;
  final VoidCallback? onLihatSemua;

  const CardRealisasiOp({
    super.key,
    required this.nonDigital,
    required this.digital,
    required this.totalRealisasi,
    this.onLihatSemua,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          /// Header
          Row(
            children: [
              const Icon(
                Icons.bar_chart_outlined,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Realisasi tahun ini',
                  style: AppTypography.bodySemiBold,
                ),
              ),
              InkWell(
                onTap: onLihatSemua,
                child: Row(
                  children: [
                    Text(
                      'Lihat semua',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(Icons.chevron_right, size: 18, color: Colors.orange),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// Digital & Non Digital
          Row(
            children: [
              Expanded(
                child: _RealisasiItem(
                  title: 'Non digital',
                  value: CurrencyFormatter.toIdr(nonDigital),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _RealisasiItem(
                  title: 'Digital',
                  value: CurrencyFormatter.toIdr(digital),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          /// Total
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F4ED),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total realisasi',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  CurrencyFormatter.toIdr(totalRealisasi),
                  style: AppTypography.heading1.copyWith(
                    color: Color(0xFF009688),
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

class _RealisasiItem extends StatelessWidget {
  const _RealisasiItem({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F4ED),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.bodyRegular.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
