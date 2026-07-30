import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
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
      create: (_) => locator<CheckUpdateCubit>()..checkNow(),
      child: const _UpdatePageContent(),
    );
  }
}

class _UpdatePageContent extends StatelessWidget {
  const _UpdatePageContent();

  Future<String> _getCurrentVersion() async {
    final info = await PackageInfo.fromPlatform();
    return "${info.version} (Build ${info.buildNumber})";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Pembaruan Sistem',
          style: AppTypography.heading5.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        scrolledUnderElevation: 0,
        shape: const Border(
          bottom: BorderSide(color: AppColors.primary, width: 1.0),
        ),
        elevation: 0,
        foregroundColor: Colors.black,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: FutureBuilder<String>(
        future: _getCurrentVersion(),
        builder: (context, snapshot) {
          final currentVersion = snapshot.data ?? "Memuat...";

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              context.read<CheckUpdateCubit>().checkNow();
            },
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // STATUS KARTU DEVICE
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.verified_user_rounded,
                          color: AppColors.primaryDark,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Parkir Digital Bapenda",
                              style: AppTypography.bodySemiBold.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Versi Terpasang: $currentVersion",
                              style: AppTypography.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // AREA HASIL CEK UPDATE
                BlocBuilder<CheckUpdateCubit, CheckUpdateState>(
                  builder: (context, state) {
                    if (state is CheckUpdateLoading) {
                      return _buildLoadingState();
                    } else if (state is CheckUpdateUpToDate) {
                      return _buildUpToDateState(state);
                    } else if (state is CheckUpdateAvailable) {
                      return _buildUpdateAvailableState(context, state);
                    } else if (state is CheckUpdateError) {
                      return _buildErrorState(context, state.message);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text(
            "Mengecek pembaruan ke server Bapenda...",
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpToDateState(CheckUpdateUpToDate state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: AppColors.success,
            size: 64,
          ),
          const SizedBox(height: 16),
          const Text(
            "Aplikasi Sudah Versi Terbaru",
            style: AppTypography.bodySemiBold,
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "v${state.versionName}",
              style: AppTypography.caption.copyWith(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Anda sudah menggunakan versi terbaru dan paling stabil saat ini.",
            textAlign: TextAlign.center,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          // 🚀 FITUR BARU: tampilkan apa yang berubah di versi ini,
          // bukan cuma status "sudah terbaru". Data changelog sudah
          // tersedia dari server, sebelumnya tidak dipakai di UI.
          if (state.changelog.trim().isNotEmpty &&
              state.changelog.trim() != '-') ...[
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border: const Border(
                  left: BorderSide(color: AppColors.success, width: 4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.history_edu_rounded,
                        size: 16,
                        color: AppColors.textPrimary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Pembaruan pada versi ini:",
                        style: AppTypography.caption.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    state.changelog,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUpdateAvailableState(
    BuildContext context,
    CheckUpdateAvailable state,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Pembaruan Tersedia", style: AppTypography.heading5),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "v${state.update.versionName}",
                  style: AppTypography.caption.copyWith(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            state.update.changelog,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          PbPrimaryButton(
            text: "Unduh & Pasang Sekarang",
            onPressed: () {
              // 🚀 PANGGIL DIALOG DARI FILE 2 SECARA AMAN
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

  Widget _buildErrorState(BuildContext context, String message) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.cloud_off_rounded,
            color: AppColors.textHint,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTypography.caption,
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => context.read<CheckUpdateCubit>().checkNow(),
            child: const Text("Coba Lagi"),
          ),
        ],
      ),
    );
  }
}
