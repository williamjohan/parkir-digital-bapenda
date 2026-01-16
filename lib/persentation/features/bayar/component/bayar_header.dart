// lib/presentation/features/bayar/component/bayar_header.dart
import 'package:flutter/material.dart';

class BayarHeader extends StatelessWidget {
  const BayarHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IntrinsicHeight(
      child: Row(
        children: [
          Image.asset('assets/images/logosby.png', height: 50),

          const SizedBox(width: 8),
          const VerticalDivider(
            color: Colors.white,
            thickness: 2,
            width: 20,
            indent: 5,
            endIndent: 5,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Digital Parkir Surabaya",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
