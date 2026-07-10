import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';

import '../../../../../core/utils/currency_formatter.dart';

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
    final bool isDisabled = nominal == 0 || jumlah == 0;

    final Color primaryColor = isDisabled
        ? Colors.grey
        : (isMotor ? Colors.teal.shade600 : Colors.blue.shade700);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDisabled
            ? Colors.grey.withValues(alpha: 0.08)
            : (isMotor
                  ? Colors.teal.shade600.withValues(alpha: 0.1)
                  : Colors.blue.shade700.withValues(alpha: 0.1)),
        border: Border.all(
          color: isDisabled
              ? Colors.grey.withValues(alpha: 0.3)
              : borderColor.withValues(alpha: 0.4),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isMotor ? 'Motor' : 'Mobil',
            style: AppTypography.caption.copyWith(
              color: isDisabled ? AppColors.disabled : AppColors.textSecondary,
            ),
          ),
          Text(
            CurrencyFormatter.toIdr(nominal),
            style: AppTypography.heading4.copyWith(
              color: isDisabled ? AppColors.disabled : AppColors.textPrimary,
            ),
          ),
          Row(
            children: [
              Icon(
                isMotor ? Icons.two_wheeler : Icons.directions_car,
                size: 20,
                color: primaryColor,
              ),
              const SizedBox(width: 4),
              Text(
                jumlah.toString(),
                style: AppTypography.bodySemiBold.copyWith(color: primaryColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
