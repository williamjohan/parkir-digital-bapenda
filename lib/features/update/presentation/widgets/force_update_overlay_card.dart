import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/design_system/components/pb_primary_button.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../domain/entities/update_entity.dart';
import '../cubit/update_progress_cubit.dart';
import '../cubit/update_progress_state.dart';

class ForceUpdateOverlayCard extends StatefulWidget {
  final UpdateEntity update;

  const ForceUpdateOverlayCard({super.key, required this.update});

  @override
  State<ForceUpdateOverlayCard> createState() => _ForceUpdateOverlayCardState();
}

class _ForceUpdateOverlayCardState extends State<ForceUpdateOverlayCard> {
  bool _isDownloading = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(28.0),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: _isDownloading
                ? _InlineProgressEnterprise(
                    url: widget.update.downloadUrl,
                    version: widget.update.versionName,
                  )
                : _buildWarningContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildWarningContent() {
    return Column(
      key: const ValueKey('WarningUI'),
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.system_update_alt_rounded,
            size: 48,
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Pembaruan Sistem Wajib",
          style: AppTypography.heading5,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "Versi Terbaru v${widget.update.versionName}",
            style: AppTypography.caption.copyWith(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Demi menjaga keamanan data dan stabilitas layanan Parkir Surabaya, aplikasi Anda harus diperbarui ke versi terbaru.",
          textAlign: TextAlign.center,
          style: AppTypography.bodyRegular.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: const Border(
              left: BorderSide(color: AppColors.primary, width: 4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Peningkatan pada versi ini:",
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.update.changelog.isNotEmpty
                    ? widget.update.changelog
                    : "- Perbaikan performa dan keamanan sistem",
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        PbPrimaryButton(
          text: "Perbarui Sekarang",
          onPressed: () => setState(() => _isDownloading = true),
        ),
      ],
    );
  }
}

class _InlineProgressEnterprise extends StatelessWidget {
  final String url;
  final String version;

  const _InlineProgressEnterprise({required this.url, required this.version});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UpdateProgressCubit(downloadUrl: url, version: version)..start(),
      child: BlocBuilder<UpdateProgressCubit, UpdateProgressState>(
        builder: (context, state) {
          if (state is UpdateError) {
            return Column(
              key: const ValueKey('ErrorUI'),
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  size: 48,
                  color: AppColors.error,
                ),
                const SizedBox(height: 16),
                const Text("Gagal Mengunduh", style: AppTypography.heading5),
                const SizedBox(height: 8),
                Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                PbPrimaryButton(
                  text: "Coba Lagi",
                  onPressed: () => context.read<UpdateProgressCubit>().retry(),
                ),
              ],
            );
          }

          double progress = 0.0;
          String message = "Menghubungkan ke Server Bapenda...";

          if (state is UpdateDownloading) {
            progress = state.progress;
            message = state.message;
          } else if (state is UpdateInstalling || state is UpdateCompleted) {
            progress = 1.0;
            message = "Membuka Installer Android...";
          }

          return Column(
            key: const ValueKey('ProgressUI'),
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: progress > 0 ? progress : null,
                      strokeWidth: 6,
                      backgroundColor: AppColors.border,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                    const Icon(
                      Icons.cloud_download_rounded,
                      size: 36,
                      color: AppColors.primaryDark,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text("Mengunduh Paket v$version", style: AppTypography.heading5),
              const SizedBox(height: 6),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor: AppColors.background,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "${(progress * 100).toStringAsFixed(0)}%",
                style: AppTypography.bodyRegular.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
