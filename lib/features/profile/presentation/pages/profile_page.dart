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
    _profileCubit.loadProfile(); // Load profile saat page terbuka
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

        //  1. TOMBOL BAWAH DIPINDAHKAN KE SINI AGAR AMAN DARI SCROLL
        bottomNavigationBar: Container(
          color: AppColors.background, // Samakan dengan background
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // === TOMBOL LOGOUT ===
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
              // === VERSION APP ===
              Center(
                child: FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    // Nilai sementara saat sedang mengambil data dari Native
                    String versionText = 'Version ...';

                    if (snapshot.hasData) {
                      // Mengambil versi langsung dari pubspec.yaml
                      versionText = 'Version ${snapshot.data!.version}';
                    }

                    return Text(
                      versionText,
                      // const digeser ke dalam Text Style
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        //  2. KONTEN UTAMA
        body: BlocBuilder<ProfileCubit, ProfileState>(
          bloc: _profileCubit,
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

            if (state is ProfileLoaded) {
              final user = state.user;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // === HEADER PROFIL ===
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary.withValues(alpha: 0.2),
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 40,
                              color: AppColors.primary,
                            ),
                          ),
                          // Avatar & Nama
                          const SizedBox(height: 16),
                          Text(
                            user.namaUser,
                            style: AppTypography.heading3,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          //TODO : perbaiki ini next (panggil NIK)

                          // Text(
                          //   'ID: ${user.idUser}',
                          //   style: AppTypography.bodySmall.copyWith(
                          //     color: AppColors.textSecondary,
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // === CARD IDENTITAS ===
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
                              Text('Identitas', style: AppTypography.heading3),
                              const SizedBox(height: 12),
                              // Info Identitas
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

                      // // === CARD LOKASI & GATE === (Di-hidden sementara)
                      // // const SizedBox(height: 16),
                      // Card(
                      //   color: AppColors.surface,
                      //   elevation: 0,
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(12),
                      //     side: const BorderSide(
                      //       color: AppColors.border,
                      //       width: 1,
                      //     ),
                      //   ),
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(16),
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text(
                      //           'Lokasi & Gate',
                      //           style: AppTypography.heading3,
                      //         ),
                      //         const SizedBox(height: 12),
                      //         _buildInfoRow(
                      //           label: 'Lokasi',
                      //           value: user.namaLokasi,
                      //         ),
                      //         const SizedBox(height: 12),
                      //         _buildInfoRow(
                      //           label: 'Kode Gate',
                      //           value: user.kodeGate,
                      //         ),
                      //         const SizedBox(height: 12),
                      //         _buildInfoRow(
                      //           label: 'Nama Gate',
                      //           value: user.namaGate,
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(height: 20),

                      // // === CARD PERANGKAT & SHIFT ===
                      // Card(
                      //   color: AppColors.surface,
                      //   elevation: 0,
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(12),
                      //     side: const BorderSide(
                      //       color: AppColors.border,
                      //       width: 1,
                      //     ),
                      //   ),
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(16),
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text(
                      //           'Perangkat & Shift',
                      //           style: AppTypography.heading3,
                      //         ),
                      //         const SizedBox(height: 12),
                      //         _buildInfoRow(
                      //           label: 'ID Perangkat',
                      //           value: user.idDevice,
                      //         ),
                      //         const SizedBox(height: 12),
                      //         _buildInfoRow(
                      //           label: 'Shift',
                      //           value: user.shift.isEmpty
                      //               ? '-'
                      //               : 'Shift ${user.shift}',
                      //         ),
                      //         const SizedBox(height: 12),
                      //         _buildInfoRow(
                      //           label: 'Pungut Tarif',
                      //           value: user.pungutTarif == 1
                      //               ? 'Gratis'
                      //               : 'Berbayar',
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),