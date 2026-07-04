import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';
import '../../../../home/domain/entities/dashboard_summary_pengawas.entity.dart';
import '../../../../home/presentation/cubit/home/home_cubit.dart';
import '../screens/absensi_checklist_screen.dart';
import '../../../../../core/routes/app_routes.dart';
import 'checkin_card_widget.dart';
import 'checkout_card_widget.dart';

class MainAbsensiWidget extends StatelessWidget {
  final CheckInOutEntity absensiData;

  const MainAbsensiWidget({super.key, required this.absensiData});

  Future<void> _openForm(BuildContext context, ShiftFormType type) async {
    final result = await context.pushNamed<bool>(
      AppRoutes.absensi,
      extra: type,
    );

    if (!context.mounted) return;

    if (result == true) {
      context.read<HomeCubit>().loadDashboardPengawas();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isCheckedIn = absensiData.checkInString.isNotEmpty;
    final bool isCheckedOut = absensiData.checkOutString.isNotEmpty;
    final bool hasJadwal = true; //

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildShiftStatus(isCheckedIn: isCheckedIn, isCheckedOut: isCheckedOut),
        const SizedBox(height: 12),

        if (!hasJadwal) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.event_busy_rounded,
                  size: 18,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Belum ada jadwal roster hari ini",
                    style: AppTypography.bodySmall.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],

        // CARD CHECK IN
        CheckInCardWidget(
          isCheckedIn: isCheckedIn,
          checkInTimeString: isCheckedIn ? absensiData.checkInString : null,
          totalMotor: absensiData.checkInJmlMotor,
          totalMobil: absensiData.checkInJmlMobil,
          detailAlat: absensiData.detailAlatCheckIn,
          onTapCheckIn: hasJadwal
              ? () => _openForm(context, ShiftFormType.checkIn)
              : null,
        ),

        const SizedBox(height: 10),

        // CARD CHECK OUT
        CheckOutCardWidget(
          isCheckedIn: isCheckedIn,
          isCheckedOut: isCheckedOut,
          checkOutTimeString: isCheckedOut ? absensiData.checkOutString : null,
          totalMotor: absensiData.checkOutJmlMotor,
          totalMobil: absensiData.checkOutJmlMobil,
          detailAlat: absensiData.detailAlatCheckOut,
          onTapCheckOut: hasJadwal
              ? () => _openForm(context, ShiftFormType.checkOut)
              : null,
        ),
      ],
    );
  }

  Widget _buildShiftStatus({
    required bool isCheckedIn,
    required bool isCheckedOut,
  }) {
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
