import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:parkir_digital_bapenda/core/design_system/components/pb_primary_button.dart';
import 'package:parkir_digital_bapenda/features/home/presentation/widgets/dashboard_item.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/routes/app_routes.dart';

class DashboardWidget extends StatelessWidget {
  // <--- Public Class
  final int totalPendapatan;
  final int totalTransaksi;
  final int motorCount;
  final int mobilCount;

  const DashboardWidget({
    super.key,
    required this.totalPendapatan,
    required this.totalTransaksi,
    required this.motorCount,
    required this.mobilCount,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryDark, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOTAL PENDAPATAN',
            style: AppTypography.bodyRegular.copyWith(
              color: AppColors.surface,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(DateTime.now()),
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.surface,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Rp$totalPendapatan",
            style: AppTypography.heading1.copyWith(color: AppColors.surface),
          ),
          const SizedBox(height: 8),
          Divider(color: AppColors.surface),
          const SizedBox(height: 8),
          Row(
            children: [
              DashboardItem(
                title: "Transaksi",
                value: totalTransaksi.toString(),
              ),

              SizedBox(width: 4),
              DashboardItem(
                title: "Motor",
                value: motorCount.toString(),
                icon: Icons.two_wheeler,
              ),

              SizedBox(width: 4),
              DashboardItem(
                title: "Mobil",
                value: mobilCount.toString(),
                icon: Icons.directions_car,
              ),
            ],
          ),
          const SizedBox(height: 16),
          PbPrimaryButton(
            text: "Tambah Transaksi",
            isSecondary: true,
            onPressed: () {
              context.push(AppRoutes.transaction);
            },
          ),
        ],
      ),
    );
  }
}
