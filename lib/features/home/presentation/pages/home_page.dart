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
import '../widgets/dashboard_widget.dart';
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
                    return DashboardWidget(
                      motorCount: state.motorCount,
                      mobilCount: state.mobilCount,
                    );
                  },
                ),
                const SizedBox(height: 20),

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
                      child: VehicleCard(
                        title: 'Motor',
                        icon: Icons.two_wheeler,
                        onTap: () => context
                            .read<HomeCubit>()
                            .requestCameraAccess('motor'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: VehicleCard(
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
