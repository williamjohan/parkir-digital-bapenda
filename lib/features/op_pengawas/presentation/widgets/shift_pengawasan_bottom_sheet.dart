import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/enums/app_enums.dart';

class ShiftPengawasanBottomSheet extends StatelessWidget {
  final Future<void> Function(ShiftPengawasan shift) onSelected;

  const ShiftPengawasanBottomSheet({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...ShiftPengawasan.values.map(
          (shift) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _ShiftItem(
              shift: shift,
              onTap: () async {
                await onSelected(shift);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _ShiftItem extends StatelessWidget {
  final ShiftPengawasan shift;
  final VoidCallback onTap;

  const _ShiftItem({required this.shift, required this.onTap});

  IconData get icon {
    switch (shift) {
      case ShiftPengawasan.shift1:
        return Icons.wb_sunny_rounded;
      case ShiftPengawasan.shift2:
        return Icons.nights_stay_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: .10),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shift.label,
                    style: AppTypography.bodyRegular.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    shift.timeRange,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              child: Icon(Icons.arrow_forward_ios, color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
