import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/design_system/components/pb_primary_button.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/di/injection.dart';
import '../cubit/check_update_cubit.dart';
import '../cubit/check_update_state.dart';
import '../widgets/update_progress_dialog.dart';

class UpdatePage extends StatelessWidget {
  const UpdatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          locator<CheckUpdateCubit>()
            ..checkNow(), // 🚀 Otomatis tembak API saat halaman dibuka
      child: Scaffold(
        // backgroundColor: Colors.white,
        appBar: AppBar(
          title: Center(
            child: const Text(
              "Pembaruan Aplikasi",
              style: AppTypography.heading5,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: SafeArea(
          bottom: true,
          top: false,
          child: BlocBuilder<CheckUpdateCubit, CheckUpdateState>(
            builder: (context, state) {
              if (state is CheckUpdateLoading) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: AppColors.primary),
                      SizedBox(height: 16),
                      Text(
                        "Mengecek versi terbaru...",
                        style: AppTypography.bodyRegular,
                      ),
                    ],
                  ),
                );
              }

              if (state is CheckUpdateUpToDate) {
                return _buildUpToDate();
              }

              if (state is CheckUpdateAvailable) {
                return _buildUpdateAvailable(context, state);
              }

              if (state is CheckUpdateError) {
                return _buildError(context, state.message);
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  // 🚀 TAMPILAN JIKA APLIKASI SUDAH TERBARU
  Widget _buildUpToDate() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.verified_user_rounded,
            size: 100,
            color: Colors.green.shade400,
          ),
          const SizedBox(height: 24),
          const Text("Sistem Mutakhir!", style: AppTypography.heading3),
          const SizedBox(height: 8),
          const Text(
            "Aplikasi Bapenda Anda sudah dalam versi terbaru.",
            style: AppTypography.bodyRegular,
          ),
        ],
      ),
    );
  }

  // 🚀 TAMPILAN JIKA ADA UPDATE (CHANGELOG)
  Widget _buildUpdateAvailable(
    BuildContext context,
    CheckUpdateAvailable state,
  ) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            Icons.system_update_tv_rounded,
            size: 80,
            color: AppColors.primary,
          ),
          const SizedBox(height: 16),
          Text(
            "Versi ${state.update.versionName} Tersedia!",
            textAlign: TextAlign.center,
            style: AppTypography.heading3,
          ),
          const SizedBox(height: 24),
          const Text("Apa yang baru?", style: AppTypography.heading5),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Text(
                  state.update.changelog,
                  style: AppTypography.bodyRegular.copyWith(height: 1.6),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          PbPrimaryButton(
            text: "Unduh & Install",
            onPressed: () {
              // 🚀 TRIGGER MODAL DOWNLOAD
              UpdateProgressDialog.show(
                context,
                state.update.downloadUrl,
                state.update.versionName,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 80, color: AppColors.error),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTypography.bodyRegular,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () => context.read<CheckUpdateCubit>().checkNow(),
            child: const Text(
              "Coba Lagi",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
