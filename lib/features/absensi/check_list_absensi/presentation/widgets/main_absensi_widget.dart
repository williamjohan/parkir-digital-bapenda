import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';
import '../../../../../core/enums/app_enums.dart';
import '../../../../home/domain/entities/dashboard_summary_pengawas.entity.dart';
import '../../../../home/presentation/cubit/home/home_cubit.dart';
import '../../../../../core/routes/app_routes.dart';
import 'checkin_card_widget.dart';
import 'checkout_card_widget.dart';

class MainAbsensiWidget extends StatelessWidget {
  final CheckInOutEntity absensiData;
  final String pengawasanSequence;

  const MainAbsensiWidget({
    super.key,
    required this.absensiData,
    required this.pengawasanSequence,
  });

  Future<void> _openForm(BuildContext context, AbsenFormType type) async {
    final homeState = context.read<HomeCubit>().state;
    final result = await context.pushNamed<bool>(
      AppRoutes.absensi,
      extra: {
        'type': type,
        'jenis': homeState.jenisPengawasan,
        'nop': homeState.nop,
        'shift': homeState.shiftPengawasan,
      },
    );

    if (!context.mounted) return;

    if (result == true) {
      final cubit = context.read<HomeCubit>();
      final currentState = cubit.state;

      cubit.loadDashboardPengawas(
        nomorObjek: currentState.nop,
        // shift: currentState.shiftPengawasan!.id,
        jenisPengawasan: currentState.jenisPengawasan!.id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isCheckedIn = absensiData.checkInString.isNotEmpty;
    final bool isCheckedOut = absensiData.checkOutString.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildShiftStatus(
          isCheckedIn: isCheckedIn,
          isCheckedOut: isCheckedOut,
          pengawasanSequence: pengawasanSequence,
        ),
        const SizedBox(height: 12),

        // CARD CHECK IN
        CheckInCardWidget(
          isCheckedIn: isCheckedIn,
          checkInTimeString: isCheckedIn ? absensiData.checkInString : null,
          totalMotor: absensiData.checkInJmlMotor,
          totalMobil: absensiData.checkInJmlMobil,
          detailAlat: absensiData.detailAlatCheckIn,
          onTapCheckIn: () => _openForm(context, AbsenFormType.checkIn),
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
          onTapCheckOut: isCheckedIn
              ? () => _openForm(context, AbsenFormType.checkOut)
              : null,
        ),
      ],
    );
  }

  Widget _buildShiftStatus({
    required bool isCheckedIn,
    required bool isCheckedOut,
    required String pengawasanSequence,
  }) {
    final bool isDone = isCheckedIn && isCheckedOut;
    final bool isOngoing = isCheckedIn && !isCheckedOut;

    final Color color;
    final IconData icon;
    final String label;

    if (isDone) {
      color = AppColors.primary;
      icon = Icons.verified_rounded;
      label = "Selesai, Pengawasan Ke : $pengawasanSequence";
    } else if (isOngoing) {
      color = AppColors.success;
      icon = Icons.radio_button_checked_rounded;
      label = "Berlangsung Pengawasan Ke : $pengawasanSequence";
    } else {
      color = Colors.grey.shade400;
      icon = Icons.radio_button_unchecked_rounded;
      label = "Pengawasan Ke : $pengawasanSequence, Belum Mulai";
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
