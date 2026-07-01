import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';
import '../../data/models/absensi_model.dart';
import 'instrument_badge_widget.dart';

class CheckInCardWidget extends StatelessWidget {
  final bool isCheckedIn;
  final DateTime? checkInTime;
  final AbsensiCheckListModel? checklist;
  final VoidCallback onTapCheckIn;

  const CheckInCardWidget({
    super.key,
    required this.isCheckedIn,
    required this.onTapCheckIn,
    this.checkInTime,
    this.checklist,
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
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.login_rounded,
                    size: 18,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Check In",
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
            child: isCheckedIn
                ? _buildCheckedInContent()
                : _buildEmptyContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionArea() {
    if (isCheckedIn) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_rounded,
                size: 14,
                color: AppColors.success,
              ),
              const SizedBox(width: 4),
              Text(
                "Sudah Check In",
                style: AppTypography.caption.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          if (checkInTime != null) ...[
            const SizedBox(height: 2),
            Text(
              "${_formatDate(checkInTime!)} - ${_formatTime(checkInTime!)}",
              style: AppTypography.caption.copyWith(
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ],
      );
    }

    return GestureDetector(
      onTap: onTapCheckIn,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_rounded, size: 14, color: AppColors.success),
            const SizedBox(width: 4),
            Text(
              "Input Check In",
              style: AppTypography.caption.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckedInContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildVehicleCount(
                icon: Icons.two_wheeler_rounded,
                label: "Motor",
                count: checklist?.totalMotor ?? 0,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildVehicleCount(
                icon: Icons.directions_car_rounded,
                label: "Mobil",
                count: checklist?.totalMobil ?? 0,
              ),
            ),
          ],
        ),
        if (checklist != null) ...[
          const SizedBox(height: 12),
          Text(
            "Instrumen",
            style: AppTypography.caption.copyWith(
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: InstrumentBadgeWidget(
                  label: "EDC",
                  isActive: checklist!.edc,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: InstrumentBadgeWidget(
                  label: "QRIS",
                  isActive: checklist!.qrisRompi, // ⬅️ nama field baru
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: InstrumentBadgeWidget(
                  label: "CCTV",
                  isActive: checklist!.cctv,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: InstrumentBadgeWidget(
                  label: "TSpark",
                  isActive: checklist!.tsPark,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildEmptyContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Icon(Icons.login_rounded, size: 32, color: Colors.grey.shade300),
            const SizedBox(height: 8),
            Text(
              "Belum melakukan check in",
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

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return "$h:$m";
  }

  String _formatDate(DateTime dt) {
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
    return "${dt.day} ${months[dt.month - 1]} ${dt.year}";
  }
}
