import 'package:flutter/material.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';

class DashboardItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;

  const DashboardItem({
    super.key,
    required this.title,
    required this.value,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.3),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: 20, color: AppColors.surface),
                      const SizedBox(width: 4),
                      Text(
                        value,
                        style: AppTypography.heading3.copyWith(
                          color: AppColors.surface,
                        ),
                      ),
                    ],
                  )
                : Text(
                    value,
                    style: AppTypography.heading3.copyWith(
                      color: AppColors.surface,
                    ),
                  ),
            Text(
              title,
              style: AppTypography.bodySmall.copyWith(color: AppColors.surface),
            ),
          ],
        ),
      ),
    );
  }
}
