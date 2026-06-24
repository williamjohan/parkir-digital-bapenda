import 'package:flutter/material.dart';

import '../../../../../core/design_system/components/shimmer/shimmer_box.dart';
import '../../../../../core/design_system/components/shimmer/shimmer_wrapper.dart';

class CardJenisPembayaranShimmer extends StatelessWidget {
  const CardJenisPembayaranShimmer({super.key});

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

            const SizedBox(height: 20),

            ...List.generate(
              3,
              (_) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  children: [
                    const ShimmerBox(width: 70, height: 18),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        children: const [
                          ShimmerBox(height: 10, borderRadius: 999),
                          SizedBox(height: 10),
                          ShimmerBox(height: 10, borderRadius: 999),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
