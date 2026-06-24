import 'package:flutter/material.dart';

import '../../../../../core/design_system/components/shimmer/shimmer_box.dart';
import '../../../../../core/design_system/components/shimmer/shimmer_wrapper.dart';

class HeaderDashboardOpShimmer extends StatelessWidget {
  const HeaderDashboardOpShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          color: Color(0xFFE8E8E8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                ShimmerBox(width: 70, height: 28, borderRadius: 20),
                SizedBox(width: 8),
                Expanded(child: ShimmerBox(height: 14)),
              ],
            ),

            const SizedBox(height: 16),

            const ShimmerBox(width: 260, height: 32),

            const SizedBox(height: 12),

            const ShimmerBox(width: double.infinity, height: 1),

            const SizedBox(height: 12),

            const ShimmerBox(width: 140, height: 14),
            const SizedBox(height: 8),
            const ShimmerBox(width: 180, height: 40),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.4),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
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
