import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import 'history_item_widget.dart';

class HistoryRecapWidget extends StatelessWidget {
  final String title;
  final String roda2;
  final String roda4;
  final String totalPendapatan;
  final bool isFree;

  const HistoryRecapWidget({
    super.key,
    required this.title,
    required this.roda2,
    required this.roda4,
    required this.totalPendapatan,
    this.isFree = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title.toUpperCase(), style: AppTypography.caption),
          const SizedBox(height: 12),

          if (!isFree) ...[
            Text(
              "Total Pendapatan",
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                CurrencyFormatter.toIdr(totalPendapatan),
                style: AppTypography.heading2.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1),
            ),
          ],

          // 🚀 2. JUMLAH KENDARAAN DIBAGI 2 DI BAWAHNYA
          Row(
            children: [
              Expanded(
                child: HistoryRecapItem(
                  title: "Roda 2",
                  subTitle: "Transaksi",
                  value: roda2,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: AppColors.border,
              ), // Garis pemisah estetik
              const SizedBox(width: 12),
              Expanded(
                child: HistoryRecapItem(
                  title: "Roda 4",
                  subTitle: "Transaksi",
                  value: roda4,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
