import 'package:flutter/material.dart';
import '../../../../../core/design_system/tokens/app_colors.dart';
import '../../../../../core/design_system/tokens/app_typography.dart';

// 🚧 DUMMY MODEL — nanti diganti entity asli pas backend-nya siap
class TaxSurveillanceItemData {
  final String kategori; // 'Motor' | 'Mobil'
  final int nominal;
  final DateTime tanggal;

  const TaxSurveillanceItemData({
    required this.kategori,
    required this.nominal,
    required this.tanggal,
  });
}

class TaxSurveillanceItemCard extends StatelessWidget {
  final TaxSurveillanceItemData item;

  const TaxSurveillanceItemCard({super.key, required this.item});

  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Ags',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  String _formatDate(DateTime date) {
    return '${date.day} ${_months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isMotor = item.kategori.toLowerCase() == 'motor';
    final color = isMotor ? AppColors.success : AppColors.info;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: .05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: .1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isMotor
                  ? Icons.two_wheeler_rounded
                  : Icons.directions_car_rounded,
              size: 20,
              color: color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.kategori,
                  style: AppTypography.bodySemiBold.copyWith(color: color),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDate(item.tanggal),
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Rp ${_formatThousand(item.nominal)}',
            style: AppTypography.bodySemiBold.copyWith(
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatThousand(int value) {
    final str = value.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i != 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return buffer.toString();
  }
}
