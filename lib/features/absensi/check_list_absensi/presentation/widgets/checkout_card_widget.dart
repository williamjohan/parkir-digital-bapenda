import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';
import '../../../../home/domain/entities/dashboard_summary_pengawas.entity.dart';
import 'instrument_badge_widget.dart';

class CheckOutCardWidget extends StatelessWidget {
  final bool isCheckedIn;
  final bool isCheckedOut;
  final String? checkOutTimeString;
  final int totalMotor;
  final int totalMobil;
  final List<DetailAlatEntity> detailAlat;
  final VoidCallback? onTapCheckOut; // 🔥 jadi nullable, sama seperti CheckIn

  const CheckOutCardWidget({
    super.key,
    required this.isCheckedIn,
    required this.isCheckedOut,
    required this.onTapCheckOut, // 🔥 tetap required, tapi tipe nullable
    this.checkOutTimeString,
    this.totalMotor = 0,
    this.totalMobil = 0,
    this.detailAlat = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    size: 18,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Check Out",
                    style: AppTypography.bodySemiBold.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                _buildActionArea(),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade100),
          Padding(
            padding: const EdgeInsets.all(16),
            child: isCheckedOut
                ? _buildCheckedOutContent()
                : _buildEmptyContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionArea() {
    if (isCheckedOut) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_rounded,
                size: 14,
                color: AppColors.error,
              ),
              const SizedBox(width: 4),
              Text(
                "Sudah Check Out",
                style: AppTypography.caption.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          if (checkOutTimeString != null && checkOutTimeString!.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              _formatDateTimeString(checkOutTimeString!),
              style: AppTypography.caption.copyWith(
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ],
      );
    }

    // Belum checkout: disabled jika belum checkin ATAU onTapCheckOut null
    final bool isDisabled = !isCheckedIn || onTapCheckOut == null;

    return GestureDetector(
      onTap: isDisabled ? null : onTapCheckOut,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isDisabled
              ? Colors.grey.shade200
              : AppColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDisabled
                ? Colors.grey.shade300
                : AppColors.error.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              !isCheckedIn ? Icons.lock_outline_rounded : Icons.add_rounded,
              size: 14,
              color: isDisabled ? Colors.grey.shade400 : AppColors.error,
            ),
            const SizedBox(width: 4),
            Text(
              !isCheckedIn ? "Check In Dulu" : "Input Check Out",
              style: AppTypography.caption.copyWith(
                color: isDisabled ? Colors.grey.shade400 : AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckedOutContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildVehicleCount(
                icon: Icons.two_wheeler_rounded,
                label: "Motor",
                count: totalMotor,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildVehicleCount(
                icon: Icons.directions_car_rounded,
                label: "Mobil",
                count: totalMobil,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          "Instrumen",
          style: AppTypography.caption.copyWith(
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        _buildInstrumentBadges(),
      ],
    );
  }

  Widget _buildEmptyContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Icon(Icons.logout_rounded, size: 32, color: Colors.grey.shade300),
            const SizedBox(height: 8),
            Text(
              isCheckedIn
                  ? "Belum melakukan check out"
                  : "Lakukan check in terlebih dahulu",
              style: AppTypography.bodySmall.copyWith(
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleCount({
    required IconData icon,
    required String label,
    required int count,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTypography.caption.copyWith(color: Colors.grey.shade500),
          ),
          const Spacer(),
          Text(
            "$count",
            style: AppTypography.bodySemiBold.copyWith(
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTimeString(String dtString) {
    try {
      final dt = DateTime.parse(dtString);
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Ags',
        'Sep',
        'Okt',
        'Nov',
        'Des',
      ];
      final h = dt.hour.toString().padLeft(2, '0');
      final m = dt.minute.toString().padLeft(2, '0');
      return "${dt.day} ${months[dt.month - 1]} ${dt.year} • $h:$m";
    } catch (e) {
      return dtString;
    }
  }

  Widget _buildInstrumentBadges() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 8.0;
        const columns = 3;
        final itemWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: detailAlat
              .map(
                (alat) => SizedBox(
                  width: itemWidth,
                  child: _buildInstrumentChip(alat.namaAlat, alat.isBawa),
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildInstrumentChip(String label, bool tersedia) {
    final color = tersedia ? AppColors.success : AppColors.textHint;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: tersedia
            ? AppColors.success.withValues(alpha: 0.08)
            : AppColors.surface,
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
