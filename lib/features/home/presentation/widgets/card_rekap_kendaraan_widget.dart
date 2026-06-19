import 'package:flutter/material.dart';

import '../../../../core/design_system/tokens/app_typography.dart';

class CardRekapKendaraanWidget extends StatelessWidget {
  final int motorCount;
  final int mobilCount;

  const CardRekapKendaraanWidget({
    super.key,
    required this.motorCount,
    required this.mobilCount,
  });

  @override
  Widget build(BuildContext context) {
    final totalKendaraan = motorCount + mobilCount;

    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // === HEADER KARTU ===
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.analytics_outlined,
                  color: Colors.orange.shade700,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "Volume Kendaraan Hari Ini",
                style: AppTypography.bodySemiBold,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // === METRIK KENDARAAN ===
          Row(
            children: [
              // 1. RODA DUA (MOTOR)
              Expanded(
                child: _MetricItem(
                  title: "Roda 2",
                  value: motorCount.toString(),
                  icon: Icons.two_wheeler,
                  color: Colors.teal.shade600,
                  bgColor: Colors.teal.shade50,
                ),
              ),
              const SizedBox(width: 12),

              // 2. RODA EMPAT (MOBIL)
              Expanded(
                child: _MetricItem(
                  title: "Roda 4",
                  value: mobilCount.toString(),
                  icon: Icons.directions_car,
                  color: Colors.blue.shade700,
                  bgColor: Colors.blue.shade50,
                ),
              ),
              const SizedBox(width: 12),

              // 3. TOTAL SEMUA KENDARAAN
              Expanded(
                child: _MetricItem(
                  title: "Total",
                  value: totalKendaraan.toString(),
                  icon: Icons.local_parking, // Ikon parkir lebih representatif
                  color: Colors.white,
                  bgColor:
                      Colors.orange.shade600, // Warna solid untuk penekanan
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// === WIDGET ANAK KHUSUS (METRIC BOX) ===
class _MetricItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final Color? textColor;

  const _MetricItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.bgColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTextColor = textColor ?? Colors.black87;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor ?? color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: effectiveTextColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: effectiveTextColor.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
