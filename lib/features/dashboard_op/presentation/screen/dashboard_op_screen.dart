import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/features/dashboard_op/presentation/widgets/header_dashboard_op_widget.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';

class DashboardOpScreen extends StatefulWidget {
  final Map<String, dynamic> item;

  const DashboardOpScreen({super.key, required this.item});

  @override
  State<DashboardOpScreen> createState() => _DashboardOpScreenState();
}

class _DashboardOpScreenState extends State<DashboardOpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(widget.item['nama_op'], style: AppTypography.heading5),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HeaderDashboardOp(
              item: widget.item,
              totalPendapatan: 66000,
              pajakPercent: 10,
              pendapatanBersih: 59400,
              totalMotor: 8,
              totalMobil: 10,
              isDigital: true,
            ),
          ],
        ),
      ),
    );
  }
}
