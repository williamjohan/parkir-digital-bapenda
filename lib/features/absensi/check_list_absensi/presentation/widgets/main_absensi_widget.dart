import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';

import '../../data/models/absensi_model.dart';
import '../cubit/absensi_cubit.dart';
import '../cubit/absensi_state.dart';
import '../screens/absensi_checklist_screen.dart'; // sesuaikan path ke lokasi ShiftFormScreen
// Sesuaikan path & nama constant route kamu.
import '../../../../../core/routes/app_routes.dart';

import 'checkin_card_widget.dart';
import 'checkout_card_widget.dart';

/// Widget ini sekarang self-contained: dia yang manggil GET
/// `/absensi/hari-ini` sendiri lewat [AbsensiCubit], dan buka
/// [ShiftFormScreen] ketika card check-in/out di-tap. Setelah form
/// submit sukses (return `true`), data di-refresh otomatis.
class MainAbsensiWidget extends StatelessWidget {
  const MainAbsensiWidget({super.key});

  Future<void> _openForm(
    BuildContext context,
    ShiftFormType type,
    AbsensiCubit cubit,
  ) async {
    final result = await context.pushNamed<bool>(
      AppRoutes.absensi,
      extra: type,
    );

    // ShiftFormScreen pop(true) kalau submit-nya sukses (lihat listener
    // di ShiftFormScreen). Kalau user cancel/back biasa, result null.
    if (result == true) {
      cubit.fetchAbsensiHariIni();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<AbsensiCubit>()..fetchAbsensiHariIni(),
      child: Builder(
        builder: (context) {
          final cubit = context.read<AbsensiCubit>();

          return BlocBuilder<AbsensiCubit, AbsensiState>(
            builder: (context, state) {
              return state.when(
                initial: () => const SizedBox.shrink(),
                loading: _buildLoadingSkeleton,
                error: (message) => _buildError(context, message, cubit),
                loaded: (data) {
                  final checklistModel = data.checkList != null
                      ? AbsensiCheckListModel.fromEntity(data.checkList!)
                      : null;

                  // TODO: AbsensiEntity belum ada field khusus "sudah
                  // check out". Kalau BE nanti nambahin field ini di
                  // response GET, tinggal map ke sini biar
                  // _buildShiftStatus & CheckOutCardWidget akurat.
                  const isCheckedOut = false;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildShiftStatus(
                        isCheckedIn: data.isPresent,
                        isCheckedOut: isCheckedOut,
                      ),
                      const SizedBox(height: 12),
                      CheckInCardWidget(
                        isCheckedIn: data.isPresent,
                        checkInTime: data.isPresent ? data.date : null,
                        checklist: checklistModel,
                        onTapCheckIn: () =>
                            _openForm(context, ShiftFormType.checkIn, cubit),
                      ),
                      const SizedBox(height: 10),
                      CheckOutCardWidget(
                        isCheckedIn: data.isPresent,
                        isCheckedOut: isCheckedOut,
                        checkOutTime: null,
                        checklist: checklistModel,
                        onTapCheckOut: () =>
                            _openForm(context, ShiftFormType.checkOut, cubit),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
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

  Widget _buildLoadingSkeleton() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildError(BuildContext context, String message, AbsensiCubit cubit) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: AppTypography.bodySmall.copyWith(color: AppColors.error),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: cubit.fetchAbsensiHariIni,
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text('Coba lagi'),
          ),
        ],
      ),
    );
  }
}
