import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class PbShimmer extends StatelessWidget {
  final Widget child;

  const PbShimmer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(milliseconds: 1400),
      interval: const Duration(milliseconds: 100),
      color: Colors.white,
      colorOpacity: 0.8,
      enabled: true,
      direction: const ShimmerDirection.fromLTRB(),
      child: child,
    );
  }
}
