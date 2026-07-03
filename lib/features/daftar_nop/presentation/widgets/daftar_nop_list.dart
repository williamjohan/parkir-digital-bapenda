import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';

import '../../domain/entities/daftar_nop_entity.dart';

class DaftarNopList extends StatelessWidget {
  final List<DaftarNopEntity> data;
  final bool isLoading;

  const DaftarNopList({super.key, required this.data, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    if (isLoading && data.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (data.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.inbox_rounded,
                  size: 48,
                  color: AppColors.primary.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Tidak ada data",
                style: AppTypography.bodySemiBold.copyWith(
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Data akan muncul di sini setelah tersedia",
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall.copyWith(
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: data.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (_, index) {
        final item = data[index];

        return ListTile(
          title: Text(item.namaOp),
          subtitle: Text(item.alamatOp),
          trailing: Text(item.nop),
        );
      },
    );
  }
}
