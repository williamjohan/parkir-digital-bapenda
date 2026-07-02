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

    // 🚀 2. REFRESH MENGGUNAKAN HOME CUBIT, BUKAN ABSENSI CUBIT
    if (result == true) {
      // Panggil fungsi load dashboard pengawas Anda untuk merefresh seluruh halaman
      // Sesuaikan nama fungsinya dengan yang ada di HomeCubit Anda
      context.read<HomeCubit>().loadDashboardPengawas();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🚀 3. LOGIKA PENENTUAN STATUS DARI ENTITY
    // Asumsi: Jika checkInString tidak kosong, berarti sudah check-in
    // Jika checkOutString tidak kosong, berarti sudah check-out
    // Sesuaikan logika ini jika Anda menggunakan properti 'status' (misal status == 1 atau 2)
    final bool isCheckedIn = absensiData.checkInString.isNotEmpty;
    final bool isCheckedOut = absensiData.checkOutString.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildShiftStatus(isCheckedIn: isCheckedIn, isCheckedOut: isCheckedOut),
        const SizedBox(height: 12),

        // CARD CHECK IN
        CheckInCardWidget(
          isCheckedIn: isCheckedIn,
          // Gunakan properti string atau parse ke DateTime jika Card Anda butuh DateTime
          checkInTime: isCheckedIn
              ? DateTime.tryParse(absensiData.checkIn)
              : null,
          // checklist: checklistModel, 🚨 (LIHAT CATATAN AUDITOR DI BAWAH)
          onTapCheckIn: () => _openForm(context, ShiftFormType.checkIn),
        ),

        const SizedBox(height: 10),

        // CARD CHECK OUT
        CheckOutCardWidget(
          isCheckedIn: isCheckedIn,
          isCheckedOut: isCheckedOut,
          checkOutTime: isCheckedOut
              ? DateTime.tryParse(absensiData.checkOut)
              : null,
          // checklist: checklistModel, 🚨 (LIHAT CATATAN AUDITOR DI BAWAH)
          onTapCheckOut: () => _openForm(context, ShiftFormType.checkOut),
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
        color: color.withValues(
          alpha: 0.1,
        ), // Gunakan withOpacity untuk support versi Flutter lama/baru
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25)),
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
