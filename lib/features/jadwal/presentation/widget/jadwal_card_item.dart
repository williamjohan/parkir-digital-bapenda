import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/features/jadwal/presentation/screens/jadwal_screen.dart';
import '../../../../core/design_system/tokens/app_colors.dart'; // TODO: sesuaikan path, ambil AbsensiRecordDummy dari sini

class ObjekAbsensiCard extends StatelessWidget {
  final AbsensiRecordDummy record;

  const ObjekAbsensiCard({super.key, required this.record});

  bool get _sudahCheckOut => record.jamCheckOut != null;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 14),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 12),
          _buildTimeRow(),
          const SizedBox(height: 14),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 12),
          _buildInstrumenSection(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.storefront_rounded,
            size: 21,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                record.namaNop,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'NOP: ${record.nop}',
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        _buildStatusBadge(),
      ],
    );
  }

  Widget _buildStatusBadge() {
    final color = _sudahCheckOut ? AppColors.success : AppColors.warning;
    final label = _sudahCheckOut ? 'Selesai' : 'Bertugas';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _sudahCheckOut
                ? Icons.check_circle_rounded
                : Icons.access_time_filled_rounded,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRow() {
    return Row(
      children: [
        Expanded(
          child: _buildTimeBlock(
            label: 'Check In',
            time: record.jamCheckIn,
            icon: Icons.login_rounded,
            iconColor: AppColors.info,
          ),
        ),
        Expanded(
          child: _buildTimeBlock(
            label: 'Check Out',
            time: record.jamCheckOut ?? '--:--',
            icon: Icons.logout_rounded,
            iconColor: _sudahCheckOut ? AppColors.warning : AppColors.textHint,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeBlock({
    required String label,
    required String time,
    required IconData icon,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 15, color: iconColor),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 10.5,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              time,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInstrumenSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'KETERSEDIAAN ALAT',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildInstrumenChip('EDC', record.edcTersedia),
            const SizedBox(width: 8),
            _buildInstrumenChip('QRIS', record.qrisTersedia),
            const SizedBox(width: 8),
            _buildInstrumenChip('TSpark', record.tsParkTersedia),
          ],
        ),
      ],
    );
  }

  Widget _buildInstrumenChip(String label, bool tersedia) {
    final color = tersedia ? AppColors.success : AppColors.textHint;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: tersedia
              ? AppColors.success.withValues(alpha: 0.08)
              : AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: tersedia
                ? AppColors.success.withValues(alpha: 0.3)
                : AppColors.border,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              tersedia ? Icons.check_circle_rounded : Icons.cancel_rounded,
              size: 15,
              color: color,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
