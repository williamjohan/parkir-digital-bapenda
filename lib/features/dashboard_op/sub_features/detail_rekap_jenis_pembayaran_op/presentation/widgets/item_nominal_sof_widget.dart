import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';

import '../../../../../../core/utils/currency_formatter.dart';

class ItemNominalSofWidget extends StatelessWidget {
  final int nominal;
  final int jumlah;
  final Color borderColor;
  final bool isMotor;

  const ItemNominalSofWidget({
    super.key,
    required this.nominal,
    required this.jumlah,
    required this.borderColor,
    required this.isMotor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMotor
            ? Colors.teal.shade600.withValues(alpha: 0.1)
            : Colors.blue.shade700.withValues(alpha: 0.1),
        border: Border.all(color: borderColor.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isMotor ? 'Motor' : 'Mobil',
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(CurrencyFormatter.toIdr(nominal), style: AppTypography.heading4),
          Row(
            children: [
              Icon(
                isMotor ? Icons.two_wheeler : Icons.directions_car,
                size: 20,
                color: isMotor ? Colors.teal.shade600 : Colors.blue.shade700,
              ),
              const SizedBox(width: 4),
              Text(
                jumlah.toString(),
                style: AppTypography.bodySemiBold.copyWith(
                  color: isMotor ? Colors.teal.shade600 : Colors.blue.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
