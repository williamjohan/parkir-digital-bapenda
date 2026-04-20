import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';

class CardTotalPendapatan extends StatelessWidget {
  final String totalPendapatan;

  const CardTotalPendapatan({super.key, required this.totalPendapatan});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4), // bayangan ke bawah
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("TOTAL PENDAPATAN", style: AppTypography.bodySemiBold),
          Text(
            DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(DateTime.now()),
            style: AppTypography.caption,
          ),
          SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Rp$totalPendapatan",
                style: AppTypography.heading2.copyWith(
                  color: AppColors.primary,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.trending_up, color: AppColors.success),
                  SizedBox(width: 8),
                  Text(
                    "10% dari kemarin",
                    style: AppTypography.bodyRegular.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
