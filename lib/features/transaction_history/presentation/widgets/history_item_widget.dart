import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';

import '../../../../core/design_system/tokens/app_colors.dart';

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
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primary),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title, style: AppTypography.caption),
            Text(
              value,
              style: AppTypography.heading1.copyWith(color: AppColors.primary),
            ),
            Text(
              subTitle,
              style: AppTypography.bodySemiBold.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
