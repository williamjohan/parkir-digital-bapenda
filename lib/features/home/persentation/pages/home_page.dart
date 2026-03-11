// lib/features/home/presentation/pages/home_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/components/pb_permission_dialog.dart';
import '../../../../core/design_system/components/pb_status_snackbar.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/routes/app_back_handler.dart';
import '../../../../core/utils/permission_utils.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listenWhen: (previous, current) =>
          previous.actionTimestamp != current.actionTimestamp,
      listener: (context, state) async {
        switch (state.permissionActionStatus) {
          case CameraPermissionStatus.granted:
            // [PERBAIKAN ARSITEKTUR UI]: Await push agar kita bisa menyuruh Cubit
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
          appBar: AppBar(
            title: const Text(
              'Parkir Digital Bapenda',
              style: AppTypography.heading2,
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
                // --- WIDGET DASHBOARD KENDARAAN ---
                BlocBuilder<HomeCubit, HomeState>(
                  buildWhen: (previous, current) =>
                      previous.motorCount != current.motorCount ||
                      previous.mobilCount != current.mobilCount,
                  builder: (context, state) {
                    return _DashboardWidget(
                      motorCount: state.motorCount,
                      mobilCount: state.mobilCount,
                    );
                  },
                ),
                const SizedBox(height: 40),

                // --- BAGIAN PILIH KENDARAAN ---
                const Text(
                  'Pilih Jenis Kendaraan',
                  style: AppTypography.heading1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Pilih tipe kendaraan untuk menyesuaikan rasio kotak panduan kamera pemindai.',
                  style: AppTypography.bodyRegular.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _VehicleCard(
                        title: 'Motor',
                        icon: Icons.two_wheeler,
                        onTap: () => context
                            .read<HomeCubit>()
                            .requestCameraAccess('motor'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _VehicleCard(
                        title: 'Mobil',
                        icon: Icons.directions_car,
                        onTap: () => context
                            .read<HomeCubit>()
                            .requestCameraAccess('mobil'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Komponen Visual Dashboard
class _DashboardWidget extends StatelessWidget {
  final int motorCount;
  final int mobilCount;

  const _DashboardWidget({required this.motorCount, required this.mobilCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transaksi Berhasil Hari Ini',
            style: AppTypography.bodyRegular.copyWith(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                icon: Icons.two_wheeler,
                count: motorCount,
                label: 'Motor',
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withValues(alpha: 0.3),
              ),
              _StatItem(
                icon: Icons.directions_car,
                count: mobilCount,
                label: 'Mobil',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final int count;
  final String label;

  const _StatItem({
    required this.icon,
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 8),
            Text(
              count.toString(),
              style: AppTypography.heading1.copyWith(
                color: Colors.white,
                fontSize: 28,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(color: Colors.white),
        ),
      ],
    );
  }
}

// ... (_VehicleCard tetap sama seperti sebelumnya) ...
class _VehicleCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _VehicleCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 32),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primaryLight.withValues(alpha: .3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 64, color: AppColors.primary),
            const SizedBox(height: 16),
            Text(title, style: AppTypography.heading2),
          ],
        ),
      ),
    );
  }
}
