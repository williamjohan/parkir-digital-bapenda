import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
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
      barrierDismissible: false,
      builder: (_) => UpdateProgressDialog(url: url, version: version),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UpdateProgressCubit(downloadUrl: url, version: version)..start(),
      child: PopScope(
        // Tetap false agar user tidak tidak sengaja membatalkan saat proses download berjalan.
        canPop: false,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            // 🚀 PERBAIKAN ARSITEKTUR: Gunakan BlocConsumer menggantikan BlocBuilder[cite: 6]
            child: BlocConsumer<UpdateProgressCubit, UpdateProgressState>(
              // 1. LISTENER: Khusus mengeksekusi perintah non-UI (Side Effects)
              listener: (context, state) {
                // Ketika Cubit memancarkan UpdateCompleted (setelah delay 2 detik dari INSTALLING),
                // kita cabut/tutup dialog Flutter secara otomatis dari stack Navigator.
                if (state is UpdateCompleted) {
                  // 🚀 BEST PRACTICE: Gunakan rootNavigator: true agar yang ditutup
                  // pasti instance showDialog di atas, bukan route halaman di bawahnya.
                  Navigator.of(context, rootNavigator: true).pop();
                }
              },
              // 2. BUILDER: Murni hanya menggambar tampilan[cite: 6]
              builder: (context, state) {
                if (state is UpdateError) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        size: 48,
                        color: AppColors.error,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Gagal Mengunduh",
                        style: AppTypography.heading5,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                        onPressed: () =>
                            context.read<UpdateProgressCubit>().retry(),
                        child: const Text(
                          "Coba Lagi",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  );
                }

                double progress = 0.0;
                String message = "Menghubungkan...";

                if (state is UpdateDownloading) {
                  progress = state.progress;
                  message = state.message;
                } else if (state is UpdateInstalling ||
                    state is UpdateCompleted) {
                  progress = 1.0;
                  message = "Membuka Installer Android...";
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.cloud_download_rounded,
                      size: 56,
                      color: AppColors.primaryDark,
                    ),
                    const SizedBox(height: 16),
                    Text("Mengunduh v$version", style: AppTypography.heading5),
                    const SizedBox(height: 8),
                    Text(
                      message,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: AppColors.background,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
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
}
