import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parkir_digital_bapenda/core/routes/app_routes.dart';
import 'package:parkir_digital_bapenda/core/utils/number_formatter.dart';

import '../../../../core/design_system/tokens/app_typography.dart';

class CardRekapKendaraanWidget extends StatelessWidget {
  final int motorCount;
  final int mobilCount;
  final int? laporanPelanggaran;

  const CardRekapKendaraanWidget({
    super.key,
    required this.motorCount,
    required this.mobilCount,
    this.laporanPelanggaran = 0,
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
          Row(
            children: [
              Expanded(
                child: _MetricItem(
                  title: "Roda 2",
                  value: NumberFormatter.format(motorCount.toString()),
                  icon: Icons.two_wheeler,
                  color: Colors.teal.shade600,
                  bgColor: Colors.teal.shade50,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricItem(
                  title: "Roda 4",
                  value: NumberFormatter.format(mobilCount.toString()),
                  icon: Icons.directions_car,
                  color: Colors.blue.shade700,
                  bgColor: Colors.blue.shade50,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricItem(
                  title: "Total",
                  value: NumberFormatter.format(totalKendaraan.toString()),
                  icon: Icons.local_parking, // Ikon parkir lebih representatif
                  color: Colors.white,
                  bgColor:
                      Colors.orange.shade600, // Warna solid untuk penekanan
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.red.shade100),
            ),
            child: InkWell(
              onTap: () {
                context.pushNamed(AppRoutes.laporanPelanggaran);
              },
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.red.shade700,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Laporan Pelanggaran",
                          style: AppTypography.bodySemiBold,
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Jumlah laporan yang masuk hari ini",
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    NumberFormatter.format(laporanPelanggaran.toString()),
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
