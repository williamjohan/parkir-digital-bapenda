import 'package:flutter/material.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../dashboard_main/domain/entities/dashboard_op_entity.dart';
import 'widgets/card_soft_widget.dart';

class DetailRekapJenisPembayaranScreen extends StatelessWidget {
  final List<SofEntity> data;

  const DetailRekapJenisPembayaranScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rekap Jenis Pembayaran',
          style: AppTypography.heading5.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        scrolledUnderElevation: 0,
        shape: const Border(bottom: BorderSide(color: AppColors.primary, width: 1.0)),
        elevation: 0,
        foregroundColor: Colors.black,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: data.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return CardSofWidget(item: data[index]);
        },
      ),
    );
  }
}
