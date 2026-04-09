// lib/features/home/presentation/pages/home_page.dart

import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:parkir_digital_bapenda/features/home/presentation/widgets/bar_diagram_widget.dart';
import 'package:parkir_digital_bapenda/features/home/presentation/widgets/home_drawer.dart';
import 'package:parkir_digital_bapenda/features/home/presentation/widgets/last_activity_widget.dart';
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadDashboardData();
    _checkSecureStorageProfile();
  }

  Future<void> _checkSecureStorageProfile() async {
    final secureStorage = locator<ISecureStorageManager>();
    final profile = await secureStorage.getJukirProfile();

    debugPrint('=== AUDIT SECURE STORAGE ===');
    debugPrint('Isi Profil: $profile');
    debugPrint('Pungut Tarif: ${profile?['pungutTarif']}');
    debugPrint('============================');
  }

  // State untuk filter kendaraan
  String _selectedVehicleType = 'Semua Kendaraan';
  final List<String> _vehicleTypes = [
    'Semua Kendaraan',
    'Motor',
    'Mobil',
    'Ojol',
  ];

  // Dummy data pendapatan per jenis kendaraan (7 hari)
  final Map<String, List<double>> _incomeData = {
    'Semua Kendaraan': [250000, 430000, 230000, 200000, 0, 0, 0],
    'Motor': [100000, 130000, 80000, 50000, 0, 0, 0],
    'Mobil': [150000, 300000, 150000, 150000, 0, 0, 0],
    'Ojol': [0, 0, 0, 0, 0, 0, 0], // Dummy untuk ojol
  };

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listenWhen: (previous, current) =>
          previous.actionTimestamp != current.actionTimestamp,
      listener: (context, state) async {
        switch (state.permissionActionStatus) {
          case CameraPermissionStatus.granted:
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
                if (kDebugMode) {
                  ChuckerFlutter.showChuckerScreen();
                }
              },
              child: const Text(
                'Parkir Digital Bapenda',
                style: AppTypography.heading5,
              ),
            ),
            backgroundColor: AppColors.surface,
            elevation: 0,
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: BlocBuilder<HomeCubit, HomeState>(
              buildWhen: (previous, current) =>
                  previous.motorCount != current.motorCount ||
                  previous.mobilCount != current.mobilCount,
              builder: (context, state) {
                return Column(
                  children: [
                    DashboardWidget(
                      totalPendapatan: 20000,
                      totalTransaksi: (state.motorCount + state.mobilCount),
                      motorCount: state.motorCount,
                      mobilCount: state.mobilCount,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: BarDiagramWithLabels(
                        weeklyIncome:
                            _incomeData[_selectedVehicleType] ??
                            List.filled(7, 0.0),
                        selectedVehicleType: _selectedVehicleType,
                        vehicleTypes: _vehicleTypes,
                        onVehicleTypeChanged: (newType) {
                          setState(() {
                            _selectedVehicleType = newType;
                          });
                        },
                      ),
                    ),
                    LastActivityWidget(),
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

// --- FUNGSI NAVIGASI CERDAS ---
void _handleVehicleSelection(
  BuildContext context,
  String kategori,
  int modePlat,
) async {
  if (modePlat == 1) {
    // MODE 1: PAKAI PLAT -> Butuh Izin Kamera
    context.read<HomeCubit>().requestCameraAccess(kategori);
  } else {
    // MODE 0: TANPA PLAT -> Langsung lompat
    await context.push('/quick-park/$kategori');
    if (context.mounted) {
      context.read<HomeCubit>().loadDashboardData();
    }
  }
}
