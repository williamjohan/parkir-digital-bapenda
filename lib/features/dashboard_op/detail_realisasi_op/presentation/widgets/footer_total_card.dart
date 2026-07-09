import 'package:flutter/material.dart';

class FooterTotalCard extends StatelessWidget {
  final String tahun;
  final String totalNominal;

  const FooterTotalCard({
    super.key,
    required this.tahun,
    required this.totalNominal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFE0B2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total $tahun',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFFD35400),
            ),
          ),
          Text(
            totalNominal,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF009688),
            ),
          ),
        ],
      ),
    );
  }
}
