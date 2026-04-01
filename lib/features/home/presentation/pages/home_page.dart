// lib/features/home/presentation/pages/home_page.dart

import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:parkir_digital_bapenda/features/home/presentation/widgets/home_drawer.dart';
import '../../../../core/design_system/components/pb_permission_dialog.dart';
import '../../../../core/design_system/components/pb_status_snackbar.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/routes/app_back_handler.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../../../core/utils/permission_utils.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/dashboard_widget.dart';
import '../widgets/mode_plat.dart';
import '../widgets/vehicle_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Memuat data pertama kali saat Home dibuka
    context.read<HomeCubit>().loadDashboardData();

    _checkSecureStorageProfile();
  }

  Future<void> _checkSecureStorageProfile() async {
    // Sesuaikan cara Anda memanggil SecureStorageManager di file ini
    // Misalnya menggunakan locator GetIt:
    final secureStorage = locator<ISecureStorageManager>();
    final profile = await secureStorage.getJukirProfile();

    debugPrint('=== AUDIT SECURE STORAGE ===');
    debugPrint('Isi Profil: $profile');
    debugPrint('Pungut Tarif: ${profile?['pungutTarif']}');
    debugPrint('============================');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listenWhen: (previous, current) =>
          previous.actionTimestamp != current.actionTimestamp,
      listener: (context, state) async {
        switch (state.permissionActionStatus) {
          case CameraPermissionStatus.granted:

            // merefresh data SQLite TEPAT saat Jukir kembali dari halaman Capture/Payment.
            await context.push('/capture/${state.selectedVehicleForCapture}');

            if (context.mounted) {
              context.read<HomeCubit>().loadDashboardData();
            }
            break;
          case CameraPermissionStatus.permanentlyDenied:
            await PbPermissionDialog.show(
              context,
              title: 'Akses Kamera Diblokir',
              description:
                  'Anda telah menolak akses kamera secara permanen. Mohon izinkan melalui Pengaturan HP.',
            );
            break;
          case CameraPermissionStatus.denied:
          case CameraPermissionStatus.error:
            PbStatusSnackbar.show(
              context,
              message: 'Akses kamera dibutuhkan.',
              isError: true,
            );
            break;
          default:
            break;
        }
      },
      child: AppBackHandler(
        child: Scaffold(
          backgroundColor: AppColors.background,
          drawer: const HomeDrawer(),
          appBar: AppBar(
            title: GestureDetector(
              onDoubleTap: () {
                // Hanya bisa dibuka saat mode Debug (Aman dari user asli!)
                if (kDebugMode) {
                  ChuckerFlutter.showChuckerScreen();
                }
              },
              child: const Text(
                'Parkir Digital Bapenda',
                style: AppTypography.heading2,
              ),
            ),
            backgroundColor: AppColors.surface,
            elevation: 0,
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- WIDGET DASHBOARD KENDARAAN (Tetap sama) ---
                BlocBuilder<HomeCubit, HomeState>(
                  buildWhen: (previous, current) =>
                      previous.motorCount != current.motorCount ||
                      previous.mobilCount != current.mobilCount,
                  builder: (context, state) {
                    return DashboardWidget(
                      motorCount: state.motorCount,
                      mobilCount: state.mobilCount,
                    );
                  },
                ),
                const SizedBox(height: 32), // Beri jarak lebih lega
                // --- [BARU] SEGMENT 1: PILIH MODE PLAT ---
                const Text(
                  '1. Pilih Mode Parkir',
                  style: AppTypography.heading2,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 12),

                BlocBuilder<HomeCubit, HomeState>(
                  buildWhen: (previous, current) =>
                      previous.selectedModePlat != current.selectedModePlat,
                  builder: (context, state) {
                    // [ABSTRAKSI]: Gunakan widget terpisah yang baru dibuat
                    return ModePlatSelector(
                      currentMode: state.selectedModePlat,
                      onModeSelected: (mode) =>
                          context.read<HomeCubit>().selectModePlat(mode),
                    );
                  },
                ),
                const SizedBox(height: 32),

                // --- [BARU] SEGMENT 2: PILIH KENDARAAN (Dinamis) ---
                // Hanya muncul jika selectedModePlat tidak null
                BlocBuilder<HomeCubit, HomeState>(
                  buildWhen: (previous, current) =>
                      previous.selectedModePlat != current.selectedModePlat,
                  builder: (context, state) {
                    final int? currentMode = state.selectedModePlat;

                    if (currentMode == null) {
                      // Jika belum memilih mode, tampilkan instruksi kosong
                      return Center(
                        child: Text(
                          'Silakan pilih mode parkir terlebih dahulu.',
                          style: AppTypography.bodyRegular.copyWith(
                            color: AppColors.textSecondary,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      );
                    }

                    // Jika sudah memilih mode, tampilkan pilihan kendaraan!
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          '2. Pilih Jenis Kendaraan',
                          style: AppTypography.heading2,
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: VehicleCard(
                                title: 'Motor',
                                icon: Icons.two_wheeler,
                                onTap: () => _handleVehicleSelection(
                                  context,
                                  'motor',
                                  currentMode,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: VehicleCard(
                                title: 'Mobil',
                                icon: Icons.directions_car,
                                onTap: () => _handleVehicleSelection(
                                  context,
                                  'mobil',
                                  currentMode,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- FUNGSI NAVIGASI CERDAS ---
void _handleVehicleSelection(
  BuildContext context,
  String kategori,
  int modePlat,
) async {
  if (modePlat == 1) {
    // MODE 1: PAKAI PLAT (Rute Lama) -> Butuh Izin Kamera
    context.read<HomeCubit>().requestCameraAccess(kategori);
    // Catatan: Navigasi aslinya terjadi di BlocListener di atas setelah izin diberikan.
  } else {
    // MODE 0: TANPA PLAT (Rute Baru) -> Langsung lompat, tidak butuh kamera!
    await context.push('/quick-park/$kategori');

    // Saat Jukir menekan "Back" dari layar Quick Park, kita refresh dashboard!
    if (context.mounted) {
      context.read<HomeCubit>().loadDashboardData();
    }
  }
}
