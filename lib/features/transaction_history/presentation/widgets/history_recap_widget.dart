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
  final String persentasePajak;
  final String nominalPajak;
  final String totalBersih;
  final Map<String, int> sofBreakdown;
  final bool isFree;

  const HistoryRecapWidget({
    super.key,
    required this.title,
    required this.roda2,
    required this.roda4,
    required this.totalPendapatan,
    required this.persentasePajak,
    required this.nominalPajak,
    required this.totalBersih,
    this.sofBreakdown = const {},
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title.toUpperCase(), style: AppTypography.caption),
          const SizedBox(height: 12),

          if (!isFree) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildFinancialColumn(
                    label: "Kotor",
                    value: CurrencyFormatter.toIdr(totalPendapatan),
                    valueColor: AppColors.textPrimary,
                  ),
                ),

                _buildVerticalDivider(),
                Expanded(
                  child: _buildFinancialColumn(
                    label: "Pajak ($persentasePajak%)",
                    value: "- ${CurrencyFormatter.toIdr(nominalPajak)}",
                    valueColor: AppColors.error,
                  ),
                ),

                _buildVerticalDivider(),
                Expanded(
                  child: _buildFinancialColumn(
                    label: "Bersih",
                    value: CurrencyFormatter.toIdr(totalBersih),
                    valueColor: AppColors.success,
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(height: 1),
            ),
          ],
          Row(
            children: [
              Expanded(
                child: HistoryRecapItem(
                  title: "Roda 2",
                  subTitle: "Transaksi",
                  value: roda2,
                ),
              ),
              Container(width: 1, height: 40, color: AppColors.border),
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

  Widget _buildFinancialColumn({
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: AppColors.textSecondary,
            fontSize: 11,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: AppTypography.heading4.copyWith(color: valueColor),
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 36,
      color: AppColors.border,
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}
