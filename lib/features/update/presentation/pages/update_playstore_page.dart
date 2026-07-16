import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/design_system/components/pb_primary_button.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/app_logger.dart';
import '../cubit/check_update_cubit.dart';
import '../cubit/check_update_state.dart';

class UpdatePlaystorePage extends StatelessWidget {
  const UpdatePlaystorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<CheckUpdateCubit>()..checkNow(),
      child: const _UpdatePlaystorePageContent(),
    );
  }
}

class _UpdatePlaystorePageContent extends StatelessWidget {
  const _UpdatePlaystorePageContent();

  Future<String> _getCurrentVersion() async {
    final info = await PackageInfo.fromPlatform();
    return "${info.version} (Build ${info.buildNumber})";
  }

  Future<void> _launchPlayStore() async {
    final Uri playStoreUrl = Uri.parse(
      "https://play.google.com/store/apps/details?id=id.go.surabaya.tsparkbapenda",
    );
    try {
      if (await canLaunchUrl(playStoreUrl)) {
        await launchUrl(playStoreUrl, mode: LaunchMode.externalApplication);
      } else {
        AppLogger.error("Gagal membuka Google Play Store");
      }
    } catch (e, stackTrace) {
      AppLogger.error("Exception", e, stackTrace);
    }
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
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: FutureBuilder<String>(
        future: _getCurrentVersion(),
        builder: (context, snapshot) {
          final currentVersion = snapshot.data ?? "Memuat...";
          return RefreshIndicator(
            onRefresh: () async => context.read<CheckUpdateCubit>().checkNow(),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Info Versi (Sama persis dengan UI lama Anda)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    "Versi Terpasang: $currentVersion",
                    style: AppTypography.bodySemiBold,
                  ),
                ),
                const SizedBox(height: 24),
                BlocBuilder<CheckUpdateCubit, CheckUpdateState>(
                  builder: (context, state) {
                    if (state is CheckUpdateAvailable) {
                      return Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Versi v${state.update.versionName} Tersedia!",
                              style: AppTypography.heading5,
                            ),
                            const SizedBox(height: 16),
                            PbPrimaryButton(
                              text: "Perbarui via Google Play",
                              onPressed:
                                  _launchPlayStore, // 🚀 AMAN DARI REGULASI
                            ),
                          ],
                        ),
                      );
                    } else if (state is CheckUpdateUpToDate) {
                      return const Center(
                        child: Text("Aplikasi Sudah Versi Terbaru"),
                      );
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
}
