import 'package:flutter/material.dart';

import '../../../../../core/design_system/components/shimmer/shimmer_box.dart';
import '../../../../../core/design_system/components/shimmer/shimmer_wrapper.dart';

class CardRiwayatPendapatanShimmer extends StatelessWidget {
  const CardRiwayatPendapatanShimmer({super.key});

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
                ShimmerBox(width: 180, height: 18),
                Spacer(),
                ShimmerBox(width: 80, height: 16),
              ],
            ),

            const SizedBox(height: 20),

            ...List.generate(
              3,
              (_) => const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: ShimmerBox(width: double.infinity, height: 16),
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(child: ShimmerBox(height: 60, borderRadius: 12)),
                SizedBox(width: 8),
                Expanded(child: ShimmerBox(height: 60, borderRadius: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
