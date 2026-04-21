import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/design_system/tokens/app_colors.dart';
import '../../../../../core/design_system/tokens/app_typography.dart';
import '../cubit/update_progress_cubit.dart';
import '../cubit/update_progress_state.dart';

class UpdateProgressDialog extends StatelessWidget {
  final String url;
  final String version;

  const UpdateProgressDialog({
    super.key,
    required this.url,
    required this.version,
  });

  static void show(BuildContext context, String url, String version) {
    showDialog(
      context: context,
      barrierDismissible: false, // 🚀 Cegah user kabur dengan ketuk di luar
      builder: (_) => UpdateProgressDialog(url: url, version: version),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UpdateProgressCubit(downloadUrl: url, version: version)..start(),
      child: PopScope(
        canPop: false, // 🚀 Cegah tombol back HP ditekan saat download
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: BlocBuilder<UpdateProgressCubit, UpdateProgressState>(
              builder: (context, state) {
                if (state is UpdateError) {
                  return _buildError(context, state.message);
                }

                double progress = 0.0;
                String message = "Memulai unduhan...";

                if (state is UpdateDownloading) {
                  progress = state.progress;
                  message = state.message;
                } else if (state is UpdateInstalling) {
                  progress = 1.0;
                  message = "Membuka Installer Android...";
                } else if (state is UpdateCompleted) {
                  progress = 1.0;
                  message = "Selesai!";
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.cloud_download_outlined,
                      size: 64,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Mengunduh Pembaruan",
                      style: AppTypography.heading5.copyWith(
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      message,
                      style: AppTypography.bodyRegular.copyWith(
                        color: AppColors.textHint,
                      ),
                    ),
                    const SizedBox(height: 24),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${(progress * 100).toStringAsFixed(0)}%",
                      style: AppTypography.caption.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.error_outline, size: 64, color: AppColors.error),
        const SizedBox(height: 16),
        Text(
          "Gagal Mengunduh",
          style: AppTypography.heading5.copyWith(color: Colors.black),
        ),
        const SizedBox(height: 8),
        Text(
          message,
          textAlign: TextAlign.center,
          style: AppTypography.bodyRegular.copyWith(color: AppColors.textHint),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          onPressed: () => context.read<UpdateProgressCubit>().retry(),
          child: const Text("Coba Lagi", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
