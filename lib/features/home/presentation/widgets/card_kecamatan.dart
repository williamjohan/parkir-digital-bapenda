import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';

class KecamatanStatCard extends StatelessWidget {
  final String namaKecamatan;
  final int totalObjekPajak;
  final int totalTju;

  const KecamatanStatCard({
    super.key,
    required this.namaKecamatan,
    required this.totalObjekPajak,
    required this.totalTju,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
            spreadRadius: -4,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _StatBlock(
                      value: totalObjekPajak,
                      label: 'Objek Pajak',
                      labelColor: AppColors.info,
                    ),
                  ),
                  const _VerticalStatDivider(),
                  Expanded(
                    child: _StatBlock(value: totalTju, label: 'TJU', labelColor: AppColors.success,),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      color: AppColors.primary.withValues(alpha: 0.08),
      child: Row(
        children: [
          Icon(Icons.location_on_rounded, size: 17, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Kecamatan $namaKecamatan',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySemiBold.copyWith(
                color: AppColors.primary,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBlock extends StatelessWidget {
  final int value;
  final String label;
  final Color labelColor;

  const _StatBlock({
    required this.value,
    required this.label,
    required this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$value',
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTypography.caption.copyWith(
            color: labelColor,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}

class _VerticalStatDivider extends StatelessWidget {
  const _VerticalStatDivider();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      child: Column(
        children: [
          _dot(filled: false),
          Expanded(child: Container(width: 1.2, color: AppColors.border)),
          _dot(filled: true),
          Expanded(child: Container(width: 1.2, color: AppColors.border)),
          _dot(filled: false),
        ],
      ),
    );
  }

  Widget _dot({required bool filled}) {
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? AppColors.primary : AppColors.surface,
        border: Border.all(color: AppColors.primary, width: filled ? 0 : 1.4),
      ),
    );
  }
}
