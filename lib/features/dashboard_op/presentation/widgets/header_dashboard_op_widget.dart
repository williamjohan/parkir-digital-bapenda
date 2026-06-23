import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';
import 'package:parkir_digital_bapenda/core/utils/currency_formatter.dart';

class HeaderDashboardOp extends StatelessWidget {
  const HeaderDashboardOp({
    super.key,
    required this.item,
    required this.totalPendapatan,
    required this.pajakPercent,
    required this.pendapatanBersih,
    required this.totalMotor,
    required this.totalMobil,
    required this.isDigital,
  });

  final Map<String, dynamic> item;
  final int totalPendapatan;
  final double pajakPercent;
  final int pendapatanBersih;
  final int totalMotor;
  final int totalMobil;
  final bool isDigital;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.primary),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'UPTB ${item['uptb'] ?? '-'} • '
            '${isDigital ? 'Digitalisasi' : 'Belum Digitalisasi'} • '
            '${item['alamat_op'] ?? '-'}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.caption.copyWith(
              color: AppColors.background.withOpacity(0.7),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            item['nama_op'] ?? '-',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.heading3.copyWith(color: AppColors.background),
          ),

          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.background.withOpacity(.18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pendapatan hari ini (kotor)',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.background.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  CurrencyFormatter.toIdr(totalPendapatan),
                  style: AppTypography.heading1.copyWith(
                    color: AppColors.background,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Bersih setelah pajak ${pajakPercent.toStringAsFixed(0)}%: ${CurrencyFormatter.toIdr(pendapatanBersih)}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _VehicleCard(
                  icon: Icons.two_wheeler,
                  title: 'Roda 2',
                  value: '$totalMotor transaksi',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _VehicleCard(
                  icon: Icons.directions_car,
                  title: 'Roda 4',
                  value: '$totalMobil transaksi',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  const _VehicleCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.18),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: Colors.white70),
              const SizedBox(width: 4),
              Text(
                title,
                style: const TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
