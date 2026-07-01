import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';
import '../../data/models/absensi_model.dart';
import 'checkin_card_widget.dart';
import 'checkout_card_widget.dart';

class MainAbsensiWidget extends StatelessWidget {
  final bool isCheckedIn;
  final DateTime? checkInTime;
  final AbsensiCheckListModel? checkInChecklist;
  final VoidCallback onTapCheckIn;

  final bool isCheckedOut;
  final DateTime? checkOutTime;
  final AbsensiCheckListModel? checkOutChecklist;
  final VoidCallback onTapCheckOut;

  const MainAbsensiWidget({
    super.key,
    required this.isCheckedIn,
    required this.onTapCheckIn,
    required this.isCheckedOut,
    required this.onTapCheckOut,
    this.checkInChecklist,
    this.checkInTime,
    this.checkOutChecklist,
    this.checkOutTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        CheckInCardWidget(
          isCheckedIn: isCheckedIn,
          checkInTime: checkInTime,
          checklist: checkInChecklist,
          onTapCheckIn: onTapCheckIn,
        ),
        const SizedBox(height: 10),
        CheckOutCardWidget(
          isCheckedIn: isCheckedIn,
          isCheckedOut: isCheckedOut,
          checkOutTime: checkOutTime,
          checklist: checkOutChecklist,
          onTapCheckOut: onTapCheckOut,
        ),
      ],
    );
  }

  Widget _buildShiftStatus() {
    final bool isDone = isCheckedIn && isCheckedOut;
    final bool isOngoing = isCheckedIn && !isCheckedOut;

    final Color color;
    final IconData icon;
    final String label;

    if (isDone) {
      color = AppColors.primary;
      icon = Icons.verified_rounded;
      label = "Selesai";
    } else if (isOngoing) {
      color = AppColors.success;
      icon = Icons.radio_button_checked_rounded;
      label = "Berlangsung";
    } else {
      color = Colors.grey.shade400;
      icon = Icons.radio_button_unchecked_rounded;
      label = "Belum Mulai";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
