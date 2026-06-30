import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import '../../../../../../core/design_system/components/shimmer/shimmer_box.dart';
import '../../../../../../core/design_system/components/shimmer/shimmer_wrapper.dart';

class DashboardIncomeSummaryShimmer extends StatelessWidget {
  const DashboardIncomeSummaryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withValues(alpha: .06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              children: [
                const ShimmerBox(width: 18, height: 18, borderRadius: 9),
                const SizedBox(width: 8),
                const Expanded(child: ShimmerBox(height: 16, width: 140)),
                const SizedBox(width: 12),
                const ShimmerBox(width: 70, height: 28, borderRadius: 16),
              ],
            ),

            const SizedBox(height: 16),

            const ShimmerBox(width: 200, height: 34, borderRadius: 10),

            const SizedBox(height: 10),

            const ShimmerBox(width: 120, height: 14),

            const SizedBox(height: 16),

            Divider(color: AppColors.border),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      ShimmerBox(width: 80, height: 12),
                      SizedBox(height: 8),
                      ShimmerBox(width: 100, height: 18),
                    ],
                  ),
                ),

                Container(width: 1, height: 52, color: AppColors.border),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        ShimmerBox(width: 120, height: 12),
                        SizedBox(height: 8),
                        ShimmerBox(width: 120, height: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
