import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:parkir_digital_bapenda/core/utils/string_ext.dart';
import 'package:parkir_digital_bapenda/features/home/presentation/widgets/card_total_pendapatan.dart';
import 'package:parkir_digital_bapenda/features/home/presentation/widgets/home_drawer.dart';
import 'package:parkir_digital_bapenda/features/home/presentation/widgets/item_kendaraan_widget.dart';
import 'package:parkir_digital_bapenda/features/home/presentation/widgets/last_activity_widget.dart';
import 'package:parkir_digital_bapenda/shared/loading/loading_overlay.dart';
import '../../../../core/constants/app_asset_constant.dart';
import '../../../../core/constants/feature_flag.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../../update/presentation/cubit/check_update_cubit.dart';
import '../../../update/presentation/cubit/check_update_state.dart';
import '../../../update/presentation/widgets/force_update_dialog.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/home_header_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Track apakah ini pertama kali load
  bool _isFirstLoad = true;

  String? namaJukir;
  String? nop;
  String? namaLokasi;

  @override
  void initState() {
    super.initState();
    _loadData();
    _checkSecureStorageProfile();
  }

  // Method untuk load data
  Future<void> _loadData() async {
    await context.read<HomeCubit>().loadDashboardData();
    if (_isFirstLoad) {
      _isFirstLoad = false;
    }
  }

  Future<void> _checkSecureStorageProfile() async {
    final secureStorage = locator<ISecureStorageManager>();
    final profile = await secureStorage.getJukirProfile();
    final rawName = profile?['namaUser'] as String? ?? '';

    setState(() {
      namaJukir = rawName.shortName;
      nop = profile?['nop'];
      namaLokasi = profile?['namaObjekPajak'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<CheckUpdateCubit>()..checkNow(),

      child: MultiBlocListener(
        listeners: [
          // 🔹 1. Listener untuk HomeCubit (Bawaan Anda)
          BlocListener<HomeCubit, HomeState>(
            listenWhen: (previous, current) =>
                previous.actionTimestamp != current.actionTimestamp,
            listener: (context, state) async {
              // Kosongkan atau isi jika ada action khusus (misal Snackbar)
            },
          ),

          // 🔹 2. Listener untuk CheckUpdateCubit (Penjegal Force Update)
          BlocListener<CheckUpdateCubit, CheckUpdateState>(
            listener: (context, state) {
              if (state is CheckUpdateAvailable) {
                // Jika update bersifat URGENT (Wajib)
                if (state.update.isForceUpdate) {
                  // Munculkan dialog paksa yang tidak bisa ditutup!
                  ForceUpdateDialog.show(context, state.update);
                }
              }
            },
          ),
        ],
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return LoadingOverlay(
              isLoading: state.status == HomeStatus.loading,
              child: SafeArea(
                top: false,
                bottom: true,
                child: Scaffold(
                  backgroundColor: AppColors.background,
                  drawer: HomeDrawer(isFree: state.isFree),
                  body: Stack(
                    children: [
                      // 1. BACKGROUND GRADIENT
                      Container(
                        height: 300,
                        decoration: const BoxDecoration(
                          gradient: AppColors.headerGradient,
                        ),
                      ),

                      // 2. ORNAMEN
                      Positioned(
                        top: 5,
                        right: -20,
                        child: Opacity(
                          opacity: 0.2,
                          child: Image.asset(
                            AppAssetImages.logosurabayasiloute,
                            height: 230,
                            width: 230,
                          ),
                        ),
                      ),
                      SafeArea(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                                top: 32,
                              ),
                              child: HomeHeaderWidget(
                                namaJukir: namaJukir ?? '-',
                                nop: nop ?? '-',
                                namaLokasi: namaLokasi,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(top: 25),
                                padding: EdgeInsets.all(16),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(40),
                                    topRight: Radius.circular(40),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    if (state.status != HomeStatus.loading) ...[
                                      RefreshIndicator(
                                        onRefresh: _loadData,
                                        child: SingleChildScrollView(
                                          physics:
                                              const AlwaysScrollableScrollPhysics(),
                                          child: Column(
                                            children: [
                                              if (!state.isFree)
                                                (() {
                                                  // TODO: REMOVE LATER KALKULASI DUMMY SEMENTARA
                                                  // Catatan Auditor: UI (Widget) seharusnya "Dumb" (Bebas Logika).
                                                  // Nanti kalkulasi ini WAJIB dipindahkan ke Data Layer (Model/Mapper)
                                                  // setelah API Bapenda siap.

                                                  return CardTotalPendapatan(
                                                    totalKotor: state
                                                        .totalPendapatan
                                                        .toString(),
                                                    persentasePajak: "10",
                                                    nominalPajak: state
                                                        .totalPajak
                                                        .toString(),
                                                    totalBersih: state
                                                        .totalBersih
                                                        .toString(),
                                                  );
                                                })(),

                                              SizedBox(height: 16),
                                              Container(
                                                padding: EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withValues(
                                                            alpha: 0.08,
                                                          ),
                                                      blurRadius: 10,
                                                      offset: const Offset(
                                                        0,
                                                        4,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                child: IntrinsicHeight(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          ItemKendaraanWidget(
                                                            icon: Icons
                                                                .two_wheeler,
                                                            judul: "Roda 2",
                                                            jumlah: state
                                                                .motorCount
                                                                .toString(),
                                                          ),
                                                          SizedBox(height: 8),
                                                          ItemKendaraanWidget(
                                                            icon: Icons
                                                                .directions_car,
                                                            judul: "Roda 4",
                                                            jumlah: state
                                                                .mobilCount
                                                                .toString(),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(width: 8),
                                                      Expanded(
                                                        child: ItemKendaraanWidget(
                                                          isLeftIcon: false,
                                                          isSolid: true,
                                                          icon: Icons.people,
                                                          judul:
                                                              "Semua Kendaraan",
                                                          jumlah:
                                                              "${state.mobilCount + state.motorCount}",
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: LastActivityWidget(
                                          transactions:
                                              state.recentTransactions,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  floatingActionButton: FeatureFlags.enableCreateOrderFeature
                      ? FloatingActionButton(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white, // semua isi jadi putih
                          shape: const CircleBorder(),
                          onPressed: () async {
                            final result = await context.push(
                              AppRoutes.transaction,
                              extra: state.isFree,
                            );

                            // kalau transaksi sukses
                            if (result == true) {
                              _loadData(); // reload data home
                            }
                          },
                          child: const Icon(Icons.add),
                        )
                      : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
