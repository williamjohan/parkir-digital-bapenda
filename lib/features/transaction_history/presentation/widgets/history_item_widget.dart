import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_colors.dart';

// lib/features/transaction_history/presentation/widgets/history_item_widget.dart

class HistoryRecapItem extends StatelessWidget {
  final String title;
  final String subTitle;
  final String value;

  const HistoryRecapItem({
    super.key,
    required this.title,
    required this.subTitle,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          subTitle,
          style: AppTypography.caption.copyWith(color: AppColors.textHint),
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
          child: Text(
            value,
            style: AppTypography.heading4.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
