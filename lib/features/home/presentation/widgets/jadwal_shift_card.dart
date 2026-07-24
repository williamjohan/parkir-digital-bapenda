import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';

class JadwalShiftCard extends StatelessWidget {
  const JadwalShiftCard({super.key});

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
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 18),
            child: Column(
              children: [
                _ShiftRow(
                  label: 'Shift 1',
                  jamMulai: '10.00',
                  jamSelesai: '14.00',
                ),
                SizedBox(height: 14),
                Divider(color: AppColors.border, height: 1),
                SizedBox(height: 14),
                _ShiftRow(
                  label: 'Shift 2',
                  jamMulai: '17.00',
                  jamSelesai: '21.00',
                ),
              ],
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
          const Icon(Icons.schedule_rounded, size: 17, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            'Jadwal Shift',
            style: AppTypography.bodySemiBold.copyWith(
              color: AppColors.primary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _ShiftRow extends StatelessWidget {
  final String label;
  final String jamMulai;
  final String jamSelesai;

  const _ShiftRow({
    required this.label,
    required this.jamMulai,
    required this.jamSelesai,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.textSecondary.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.access_time_filled_rounded,
            size: 18,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: AppTypography.bodySemiBold.copyWith(
              color: AppColors.textPrimary,
              fontSize: 14,
            ),
          ),
        ),
        Text(
          '$jamMulai - $jamSelesai',
          style: AppTypography.bodySemiBold.copyWith(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
