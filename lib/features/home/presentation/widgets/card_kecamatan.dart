import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';

import '../../../../core/constants/app_asset_constant.dart';

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

  int get _total => totalObjekPajak + totalTju;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        image: const DecorationImage(
          image: AssetImage(AppAssetImages.patternCard),
          fit: BoxFit.cover,
          opacity: 1,
        ),
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
          _buildTotalHero(), // BARU — pindah ke atas, jadi headline
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
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
                    child: _StatBlock(
                      value: totalTju,
                      label: 'TJU',
                      labelColor: AppColors.success,
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

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      color: AppColors.primary.withValues(alpha: 0.08),
      child: Row(
        children: [
          const Icon(
            Icons.location_on_rounded,
            size: 17,
            color: AppColors.primary,
          ),
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

  // BARU — total sebagai headline, angka besar + gradient tipis di background
  Widget _buildTotalHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Text(
            'TOTAL KESELURUHAN',
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$_total',
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(),
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: labelColor.withValues(
              alpha: 0.10,
            ), // BARU — badge pill di belakang label
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.caption.copyWith(
              color: labelColor,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
              fontSize: 11,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$value',
          style: const TextStyle(
            fontSize:
                22, // BARU — dikecilin dari 30, biar gak menyaingi total di atas
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            height: 1.1,
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
