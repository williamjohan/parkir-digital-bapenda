import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:parkir_digital_bapenda/core/enums/app_enums.dart';
import 'package:parkir_digital_bapenda/features/home/presentation/widgets/card_objek_pajak_widget.dart';
import 'package:parkir_digital_bapenda/features/home/presentation/widgets/card_total_op_widget.dart';
import 'package:parkir_digital_bapenda/features/home/presentation/widgets/card_total_pendapatan.dart';
import 'package:parkir_digital_bapenda/features/home/presentation/widgets/home_drawer.dart';
import 'package:parkir_digital_bapenda/features/home/presentation/widgets/last_activity_widget.dart';
import 'package:parkir_digital_bapenda/shared/loading/loading_overlay.dart';
import '../../../../core/constants/app_asset_constant.dart';
import '../../../../core/constants/feature_flag.dart';
import '../../../../core/design_system/components/pb_permission_gate.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../update/presentation/cubit/check_update_cubit.dart';
import '../../../update/presentation/cubit/check_update_state.dart';
import '../../../update/presentation/widgets/force_update_dialog.dart';
import '../cubit/home/home_cubit.dart';
import '../cubit/home/home_state.dart';
import '../widgets/card_rekap_jenis_pembayaran_widget.dart';
import '../widgets/card_rekap_kendaraan_widget.dart';
import '../widgets/home_header_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Track apakah ini pertama kali load
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Method untuk load data
  Future<void> _loadData() async {
    await context.read<HomeCubit>().initialize();
    if (_isFirstLoad) {
      _isFirstLoad = false;
    }
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
                  drawer: HomeDrawer(isFree: state.isFree, role: state.role),
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
                                role: state.role,
                                namaJukir: state.namaJukir,
                                nop: state.nop,
                                namaObjekPajak: state.namaOp,
                                onPressed: () {},
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(top: 25),
                                width: double.infinity,
                                clipBehavior: Clip.antiAlias,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(40),
                                    topRight: Radius.circular(40),
                                  ),
                                ),

                                child: state.status == HomeStatus.loading
                                    ? const SizedBox() // Aman, karena ada LoadingOverlay di root
                                    : RefreshIndicator(
                                        onRefresh: _loadData,
                                        child: SingleChildScrollView(
                                          physics:
                                              const AlwaysScrollableScrollPhysics(),
                                          //Padding dipindah ke dalam ScrollView agar batas atas-bawah scroll terasa luas
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              // WIDGET OP YANG AKTIF
                                              PbPermissionGate(
                                                allowedRoles: const [
                                                  RoleLoginDigitalParkir.wp,
                                                ],
                                                currentRole: state.role,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        bottom: 16,
                                                      ),
                                                  child: CardObjekPajakWidget(
                                                    nop: state.nop,
                                                    namaObjekPajak:
                                                        state.namaOp,
                                                    alamat: state.namaLokasi,
                                                    onPressedGantiObjek: () async {
                                                      final result = await context
                                                          .pushNamed(
                                                            AppRoutes
                                                                .searchObjekPajak,
                                                            extra: state.role,
                                                          );

                                                      if (result != null) {
                                                        await context
                                                            .read<HomeCubit>()
                                                            .changeObjekPajak(
                                                              result
                                                                  as Map<
                                                                    String,
                                                                    dynamic
                                                                  >,
                                                            );
                                                      }
                                                    },
                                                    onPressedLihatDetail: () {},
                                                  ),
                                                ),
                                              ),

                                              // WIDGET KARTU TOTAL PENDAPATAN
                                              PbPermissionGate(
                                                allowedRoles: [
                                                  RoleLoginDigitalParkir.jukir,
                                                  RoleLoginDigitalParkir.wp,
                                                  RoleLoginDigitalParkir
                                                      .bapenda,
                                                ],
                                                currentRole: state.role,
                                                child: Padding(
                                                  padding:
                                                      EdgeInsetsGeometry.only(
                                                        bottom: 16,
                                                      ),
                                                  child: CardTotalPendapatan(
                                                    totalKotor: state
                                                        .totalPendapatan
                                                        .toString(),
                                                    persentasePajak:
                                                        "10", // Dummy statis sesuai kesepakatan
                                                    nominalPajak: state
                                                        .totalPajak
                                                        .toInt()
                                                        .toString(), // Data Real API
                                                    totalBersih: state
                                                        .totalBersih
                                                        .toInt()
                                                        .toString(), // Data Real API
                                                  ),
                                                ),
                                              ),

                                              // WIDGET CARD TOTAL OP
                                              PbPermissionGate(
                                                allowedRoles: [
                                                  RoleLoginDigitalParkir
                                                      .bapenda,
                                                ],
                                                currentRole: state.role,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        bottom: 16,
                                                      ),
                                                  child: CardTotalOpWidget(
                                                    totalObjekPajak:
                                                        state.totalOp,
                                                    totalOpDigitalisasi:
                                                        state.totalOpDigital,
                                                    totalOpNonDigitalisasi:
                                                        state.totalOpNonDigital,
                                                    totalOpFree:
                                                        state.totalOpFree,
                                                    totalOpNonFree:
                                                        state.totalOpNonFree,
                                                    lihatSemuaOnPressed: () async {
                                                      final result = await context
                                                          .pushNamed(
                                                            AppRoutes
                                                                .searchObjekPajak,
                                                            extra: {
                                                              'role':
                                                                  state.role,
                                                            },
                                                          );

                                                      if (result != null) {
                                                        await context
                                                            .read<HomeCubit>()
                                                            .changeObjekPajak(
                                                              result
                                                                  as Map<
                                                                    String,
                                                                    dynamic
                                                                  >,
                                                            );
                                                      }
                                                    },
                                                    onTapDigitalisasi: () {
                                                      context.pushNamed(
                                                        AppRoutes
                                                            .searchObjekPajak,
                                                        extra: {
                                                          'role':
                                                              RoleLoginDigitalParkir
                                                                  .bapenda,
                                                          'opType': SearchOpType
                                                              .digital,
                                                        },
                                                      );
                                                    },
                                                    onTapNonDigital: () {
                                                      context.pushNamed(
                                                        AppRoutes
                                                            .searchObjekPajak,
                                                        extra: {
                                                          'role':
                                                              RoleLoginDigitalParkir
                                                                  .bapenda,
                                                          'opType': SearchOpType
                                                              .nonDigital,
                                                        },
                                                      );
                                                    },
                                                    onTapFreePark: () {
                                                      context.pushNamed(
                                                        AppRoutes
                                                            .searchObjekPajak,
                                                        extra: {
                                                          'role':
                                                              RoleLoginDigitalParkir
                                                                  .bapenda,
                                                          'opType':
                                                              SearchOpType.free,
                                                        },
                                                      );
                                                    },
                                                    onTapNonFreePark: () {
                                                      context.pushNamed(
                                                        AppRoutes
                                                            .searchObjekPajak,
                                                        extra: {
                                                          'role':
                                                              RoleLoginDigitalParkir
                                                                  .bapenda,
                                                          'opType':
                                                              SearchOpType.paid,
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),

                                              // WIDGET VOLUME JUMLAH KENDARAAN
                                              PbPermissionGate(
                                                allowedRoles: const [
                                                  RoleLoginDigitalParkir.jukir,
                                                  RoleLoginDigitalParkir
                                                      .bapenda,
                                                  RoleLoginDigitalParkir.wp,
                                                ],
                                                currentRole: state.role,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        bottom: 16,
                                                      ),
                                                  child:
                                                      CardRekapKendaraanWidget(
                                                        motorCount:
                                                            state.motorCount,
                                                        mobilCount:
                                                            state.mobilCount,
                                                      ),
                                                ),
                                              ),

                                              // WIDGET RECENT ACTIVITY
                                              PbPermissionGate(
                                                allowedRoles: const [
                                                  RoleLoginDigitalParkir.jukir,
                                                  RoleLoginDigitalParkir.wp,
                                                ],
                                                currentRole: state.role,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        bottom: 16,
                                                      ),
                                                  child: LastActivityWidget(
                                                    transactions: state
                                                        .recentTransactions,
                                                  ),
                                                ),
                                              ),

                                              // WIDGET REKAP JENIS PEMBAYARAN BAPENDA
                                              PbPermissionGate(
                                                allowedRoles: const [
                                                  RoleLoginDigitalParkir
                                                      .bapenda,
                                                ],
                                                currentRole: state.role,
                                                child:
                                                    CardRekapJenisPembayaranWidget(
                                                      data: state
                                                          .sofParkirResults,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  floatingActionButton: FeatureFlags.enableCreateOrderFeature
                      ? PbPermissionGate(
                          allowedRoles: const [RoleLoginDigitalParkir.jukir],
                          currentRole: state.role,
                          child: FloatingActionButton(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: const CircleBorder(),
                            onPressed: () async {
                              final result = await context.push(
                                AppRoutes.transaction,
                                extra: {'isFree': state.isFree},
                              );

                              // kalau transaksi sukses
                              if (result == true) {
                                _loadData(); // reload data home
                              }
                            },
                            child: const Icon(Icons.add),
                          ),
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
