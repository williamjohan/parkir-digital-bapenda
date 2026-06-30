import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import '../../../../../core/design_system/tokens/app_typography.dart';
import '../../../../../core/utils/currency_formatter.dart';

class DashboardIncomeSummary extends StatelessWidget {
  final int totalPendapatan;
  final double pajakPercent;
  final int pendapatanBersih;

  const DashboardIncomeSummary({
    super.key,
    required this.totalPendapatan,
    required this.pajakPercent,
    required this.pendapatanBersih,
  });

  @override
  Widget build(BuildContext context) {
    final pajakNominal = (totalPendapatan * (pajakPercent / 100)).round();

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
          Row(
            children: [
              const Icon(
                Icons.payments_rounded,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  "Ringkasan Pendapatan",
                  style: AppTypography.bodySemiBold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: .08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Hari Ini",
                  style: AppTypography.caption.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),
          Text(
            CurrencyFormatter.toIdr(totalPendapatan),
            style: AppTypography.heading1.copyWith(
              fontSize: 30,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            "Total Pendapatan",
            style: AppTypography.bodyRegular.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 4),

          Divider(color: AppColors.border),

          const SizedBox(height: 4),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pajak (${pajakPercent.toStringAsFixed(0)}%)",
                      style: AppTypography.caption,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      CurrencyFormatter.toIdr(pajakNominal),
                      style: AppTypography.bodySemiBold.copyWith(
                        color: AppColors.error,
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
                      const Text(
                        "Pendapatan Bersih",
                        style: AppTypography.caption,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        CurrencyFormatter.toIdr(pendapatanBersih),
                        style: AppTypography.bodySemiBold.copyWith(
                          color: Colors.green.shade700,
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
