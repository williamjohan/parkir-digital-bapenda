import 'package:flutter/material.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';

class ModeItemWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;
  final VoidCallback? onTap;

  const ModeItemWidget({
    super.key,
    required this.title,
    required this.subTitle,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Expanded(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            color: AppColors.textHint.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primaryDark),
              SizedBox(height: 8),
              Text(title, style: AppTypography.bodySemiBold),
              Text(subTitle, style: AppTypography.caption),
              SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    "Ketuk untuk mulai",
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.primaryDark,
                    ),
                  ),
                  SizedBox(width: 2),
                  Icon(
                    Icons.arrow_forward,
                    color: AppColors.primaryDark,
                    size: 15,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
