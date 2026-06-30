import 'package:flutter/material.dart';

class TotalSummaryCard extends StatelessWidget {
  final String tahun;
  final String totalNominal;

  const TotalSummaryCard({
    super.key,
    required this.tahun,
    required this.totalNominal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total realisasi $tahun',
            style: const TextStyle(fontSize: 12, color: Color(0xFFD35400)),
          ),
          const SizedBox(height: 4),
          Text(
            totalNominal,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF009688),
            ),
          ),
        ],
      ),
    );
  }
}
