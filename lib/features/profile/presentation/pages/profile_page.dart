import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/design_system/components/pb_show_dialog.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/di/injection.dart';
import '../../../../shared/loading/app_loading_widget.dart';
import '../../../auth/presentation/cubit/app_auth/app_auth_cubit.dart';
import '../cubit/profile_cubit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ProfileCubit _profileCubit;

  @override
  void initState() {
    super.initState();
    _profileCubit = locator<ProfileCubit>();
    _profileCubit.loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          centerTitle: true,
          title: Text('Profil Saya', style: AppTypography.heading5),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => context.pop(),
          ),
        ),
        bottomNavigationBar: Container(
          color: AppColors.background,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    final safeNavigator = Navigator.of(
                      context,
                      rootNavigator: true,
                    );
                    final safeContext = safeNavigator.context;

                    PbShowDialog.show(
                      safeContext,
                      showBtnKeluar: true,
                      title: 'Konfirmasi Logout',
                      description:
                          'Apakah Anda yakin ingin keluar dari aplikasi?',
                      onConfirm: () async {
                        showDialog(
                          context: safeContext,
                          barrierDismissible: false,
                          builder: (BuildContext dialogContext) {
                            return const Center(
                              child: AppLoadingWidget(size: 150),
                            );
                          },
                        );
                        await Future.delayed(const Duration(milliseconds: 800));
                        await locator<AppAuthCubit>().forceLogout();
                      },
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    String versionText = 'Version ...';

                    if (snapshot.hasData) {
                      versionText = 'Version ${snapshot.data!.version}';
                    }

                    return Text(
                      versionText,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // --- PERUBAHAN UTAMA DI SINI ---
        body: BlocConsumer<ProfileCubit, ProfileState>(
          bloc: _profileCubit,
          listener: (context, state) {
            // Jika refresh gagal tapi masih ada data lama, munculkan SnackBar
            if (state is ProfileRefreshError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Gagal memperbarui profil: ${state.message}'),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProfileFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: AppTypography.bodyRegular.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => _profileCubit.refreshProfile(),
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            }

            // Gabungkan kondisi untuk menampilkan UI Profil
            if (state is ProfileLoaded || state is ProfileRefreshError) {
              // Ambil data user dari state yang sesuai
              final user = state is ProfileLoaded
                  ? state.user
                  : (state as ProfileRefreshError).oldUser;

              final photoPath = state is ProfileLoaded
                  ? state.photoPath
                  : (state as ProfileRefreshError).oldPhotoPath;

              return RefreshIndicator(
                onRefresh: () => _profileCubit.refreshProfile(),
                // Tambahkan AlwaysScrollableScrollPhysics agar selalu bisa ditarik
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary.withValues(alpha: 0.2),
                                image:
                                    (photoPath != null && photoPath.isNotEmpty)
                                    ? DecorationImage(
                                        image: FileImage(File(photoPath)),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 40,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              user.namaUser, // Menggunakan variabel 'user' yang sudah difilter
                              style: AppTypography.heading3,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Card(
                          color: AppColors.surface,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(
                              color: AppColors.border,
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Identitas',
                                  style: AppTypography.heading3,
                                ),
                                const SizedBox(height: 12),
                                _buildInfoRow(
                                  label: 'NOP (Nomor Objek Pajak)',
                                  value: user.nop,
                                ),
                                const SizedBox(height: 12),
                                _buildInfoRow(
                                  label: 'Nama Objek Pajak',
                                  value: user.namaObjekPajak,
                                ),
                                const SizedBox(height: 12),
                                _buildInfoRow(
                                  label: 'Alamat',
                                  value: user.alamat,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  /// Helper widget untuk menampilkan info row
  Widget _buildInfoRow({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value.isEmpty ? '-' : value,
          style: AppTypography.bodyRegular.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
