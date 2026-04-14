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
import '../../data/models/weekly_chart_item_model.dart';
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

  // 🚀 [REFACTOR] State untuk filter kendaraan (Ojol dihapus)
  String _selectedVehicleType = 'Semua Kendaraan';
  final List<String> _vehicleTypes = ['Semua Kendaraan', 'Motor', 'Mobil'];

  // Add this helper method to extract day labels
  List<String> _getDayLabels(List<WeeklyChartItemModel> chartData) {
    if (chartData.isEmpty) {
      return ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    }
    return chartData.map((data) => data.hari).toList();
  }

  // 🚀 [REFACTOR] Fungsi Mapper Asli dari WeeklyChartItemModel ke List<double>
  List<double> _getWeeklyIncomeData(
    List<WeeklyChartItemModel> chartData,
    String type,
  ) {
    if (chartData.isEmpty) {
      return List.filled(7, 0.0); // Fallback jika data kosong
    }
    // disini
    return chartData.map((data) {
      switch (type) {
        case 'Motor':
          return data.nominalMotor.toDouble();
        case 'Mobil':
          return data.nominalMobil.toDouble();
        default:
          return data.nominalTotal.toDouble();
      }
    }).toList();
  }

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
            // 🚀 [REFACTOR] Dihapus buildWhen agar semua state baru bisa ter-render
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                return Column(
                  children: [
                    DashboardWidget(
                      // 🚀 [REFACTOR] Gunakan state.totalPendapatan
                      totalPendapatan: state.totalPendapatan,
                      totalTransaksi: (state.motorCount + state.mobilCount),
                      motorCount: state.motorCount,
                      mobilCount: state.mobilCount,
                      isFree: state.isFree,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: BarDiagramWithLabels(
                        weeklyIncome: _getWeeklyIncomeData(
                          state.weeklyChartData,
                          _selectedVehicleType,
                        ),
                        selectedVehicleType: _selectedVehicleType,
                        vehicleTypes: _vehicleTypes,
                        onVehicleTypeChanged: (newType) {
                          setState(() {
                            _selectedVehicleType = newType;
                          });
                        },
                        dayLabels: _getDayLabels(
                          state.weeklyChartData,
                        ), // ✅ Pass actual labels
                      ),

                      // BarDiagramWithLabels(
                      //   // 🚀 [REFACTOR] Inject hasil mapping data chart dari state
                      //   weeklyIncome: _getWeeklyIncomeData(
                      //     state.weeklyChartData,
                      //     _selectedVehicleType,
                      //   ),
                      //   selectedVehicleType: _selectedVehicleType,
                      //   vehicleTypes: _vehicleTypes,
                      //   onVehicleTypeChanged: (newType) {
                      //     setState(() {
                      //       _selectedVehicleType = newType;
                      //     });
                      //   },
                      //   dayLabels: [],
                      // ),
                    ),
                    // 🚀 [REFACTOR] Mengirimkan data transaksi ke widget anak
                    LastActivityWidget(transactions: state.recentTransactions),
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
