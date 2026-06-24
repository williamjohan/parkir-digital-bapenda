import 'package:flutter/material.dart';

import '../../../../../core/design_system/components/shimmer/shimmer_box.dart';
import '../../../../../core/design_system/components/shimmer/shimmer_wrapper.dart';

class CardRealisasiShimmer extends StatelessWidget {
  const CardRealisasiShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Row(
              children: const [
                ShimmerBox(width: 160, height: 18),
                Spacer(),
                ShimmerBox(width: 80, height: 16),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: const [
                Expanded(child: ShimmerBox(height: 80, borderRadius: 12)),
                SizedBox(width: 8),
                Expanded(child: ShimmerBox(height: 80, borderRadius: 12)),
              ],
            ),

            const SizedBox(height: 8),

            const ShimmerBox(height: 100, borderRadius: 12),
          ],
        ),
      ),
    );
  }
}
