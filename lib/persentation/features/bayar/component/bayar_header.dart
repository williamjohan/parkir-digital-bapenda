// lib/presentation/features/bayar/component/bayar_header.dart
import 'package:flutter/material.dart';

class BayarHeader extends StatelessWidget {
  const BayarHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      alignment: Alignment.centerLeft,
      child: Image.asset(
        'assets/images/logosby.png',
        fit: BoxFit.fitHeight,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image, color: Colors.grey);
        },
      ),
    );
  }
}
