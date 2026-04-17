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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: AppTypography.caption.copyWith(color: AppColors.textPrimary),
          ),
          Text(
            value,
            style: AppTypography.heading4.copyWith(color: AppColors.primary),
          ),
          Text(subTitle, style: AppTypography.caption),
        ],
      ),
    );
  }
}
