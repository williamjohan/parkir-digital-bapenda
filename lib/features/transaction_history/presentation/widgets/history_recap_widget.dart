import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';

import '../../../../core/utils/currency_formatter.dart';
import 'history_item_widget.dart';

class HistoryRecapWidget extends StatelessWidget {
  final String roda2;
  final String roda4;
  final String totalPendapatan;
  final bool isFree;

  const HistoryRecapWidget({
    super.key,
    required this.roda2,
    required this.roda4,
    required this.totalPendapatan,
    this.isFree = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 16),
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
          Text("REKAP HARI INI", style: AppTypography.caption),
          SizedBox(height: 8),
          Row(
            children: [
              HistoryRecapItem(
                title: "Roda 2",
                subTitle: "Transaksi",
                value: roda2,
              ),
              HistoryRecapItem(
                title: "Roda 4",
                subTitle: "Transaksi",
                value: roda4,
              ),
              if (!isFree)
                HistoryRecapItem(
                  title: "Total",
                  subTitle: "Pendapatan",
                  value: CurrencyFormatter.toIdr(totalPendapatan),
                ),
            ],
          ),
          Row(),
        ],
      ),
    );
  }
}
