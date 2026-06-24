import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';

import '../../../../../../core/utils/currency_formatter.dart';

class ItemNominalSofWidget extends StatelessWidget {
  final String title;
  final int nominal;
  final int jumlah;
  final Color borderColor;

  const ItemNominalSofWidget({
    super.key,
    required this.title,
    required this.nominal,
    required this.jumlah,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor.withOpacity(.4)),
        borderRadius: BorderRadius.circular(10),
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
          // const SizedBox(height: 8),
          Text(CurrencyFormatter.toIdr(nominal), style: AppTypography.heading4),
          // const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                title == 'Motor' ? Icons.two_wheeler : Icons.directions_car,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(jumlah.toString(), style: AppTypography.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}
