import 'package:flutter/material.dart';
import '../../../../core/design_system/components/shimmer/shimmer_box.dart';
import '../../../../core/design_system/components/shimmer/shimmer_wrapper.dart';

class PendapatanDigitalShimmer extends StatelessWidget {
  const PendapatanDigitalShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const ShimmerBox(height: 48, borderRadius: 12),

            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ShimmerBox(width: 36, height: 36, borderRadius: 8),
                      SizedBox(width: 12),
                      Expanded(child: ShimmerBox(height: 18)),
                    ],
                  ),
                  SizedBox(height: 20),
                  ShimmerBox(width: 120, height: 14),
                  SizedBox(height: 8),
                  ShimmerBox(height: 36),
                  SizedBox(height: 20),
                  Divider(),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerBox(width: 80),
                            SizedBox(height: 8),
                            ShimmerBox(width: 120),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerBox(width: 90),
                            SizedBox(height: 8),
                            ShimmerBox(width: 120),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                children: [
                  Row(
                    children: [
                      ShimmerBox(width: 36, height: 36),
                      SizedBox(width: 12),
                      Expanded(child: ShimmerBox(height: 18)),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ShimmerBox(height: 110, borderRadius: 16),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ShimmerBox(height: 110, borderRadius: 16),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ShimmerBox(height: 110, borderRadius: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Row(
                    children: [
                      ShimmerBox(width: 36, height: 36),
                      SizedBox(width: 12),
                      Expanded(child: ShimmerBox(height: 18)),
                      SizedBox(width: 80, child: ShimmerBox(height: 14)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 20),

                  ...List.generate(
                    5,
                    (index) => const Padding(
                      padding: EdgeInsets.only(bottom: 18),
                      child: Row(
                        children: [
                          Expanded(flex: 3, child: ShimmerBox(height: 20)),
                          SizedBox(width: 12),
                          Expanded(
                            flex: 4,
                            child: ShimmerBox(height: 52, borderRadius: 12),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            flex: 4,
                            child: ShimmerBox(height: 52, borderRadius: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
