import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:parkir_digital_bapenda/core/design_system/components/pb_primary_button.dart';
import 'package:parkir_digital_bapenda/features/home/presentation/widgets/dashboard_item.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/routes/app_routes.dart';
import '../cubit/home_cubit.dart';

class DashboardWidget extends StatelessWidget {
  // <--- Public Class
  final double totalPendapatan;
  final int totalTransaksi;
  final int motorCount;
  final int mobilCount;
  final bool isFree;

  const DashboardWidget({
    super.key,
    required this.totalPendapatan,
    required this.totalTransaksi,
    required this.motorCount,
    required this.mobilCount,
    required this.isFree,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryDark, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Rp$totalPendapatan",
                style: AppTypography.heading1.copyWith(
                  color: AppColors.surface,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${motorCount + mobilCount} transaksi",
                  style: AppTypography.caption.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(color: AppColors.surface),
          const SizedBox(height: 8),
          Row(
            children: [
              DashboardItem(
                title: "Roda 2",
                value: motorCount.toString(),
                icon: Icons.two_wheeler,
              ),

              SizedBox(width: 4),
              DashboardItem(
                title: "Roda 4",
                value: mobilCount.toString(),
                icon: Icons.directions_car,
              ),
            ],
          ),
          const SizedBox(height: 16),
          PbPrimaryButton(
            text: "Tambah Transaksi",
            variant: PbButtonVariant.outlinedSecondaryLight,
            onPressed: () async {
              final result = await context.push<bool?>(
                AppRoutes.transaction,
                extra: isFree,
              );

              if (!context.mounted) return;
              if (result == true) {
                context.read<HomeCubit>().loadDashboardData();
              }
            },
          ),
        ],
      ),
    );
  }
}
