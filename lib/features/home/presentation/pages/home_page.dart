import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:parkir_digital_bapenda/core/enums/app_enums.dart';
import 'package:parkir_digital_bapenda/core/utils/string_ext.dart';
import 'package:parkir_digital_bapenda/features/absensi/check_list_absensi/presentation/widgets/main_absensi_widget.dart';
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
import '../widgets/animated_home_fab.dart';
import '../widgets/card_rekap_jenis_pembayaran_widget.dart';
import '../widgets/card_rekap_kendaraan_widget.dart';
import '../widgets/home_header_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

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
          BlocListener<HomeCubit, HomeState>(
            listenWhen: (previous, current) =>
                previous.actionTimestamp != current.actionTimestamp,
            listener: (context, state) async {},
          ),
          BlocListener<CheckUpdateCubit, CheckUpdateState>(
            listener: (context, state) {
              if (state is CheckUpdateAvailable) {
                if (state.update.isForceUpdate) {
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
                  drawer: HomeDrawer(
                    isFree: state.isFree,
                    role: state.role,
                    namaUPTB: state.namaJukir.shortName,
                  ),
                  body: Stack(
                    children: [
                      Container(
                        height: 300,
                        decoration: const BoxDecoration(
                          gradient: AppColors.headerGradient,
                        ),
                      ),
                      Positioned(
                        top: -15,
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
                              padding: const EdgeInsets.only(),
                              child: HomeHeaderWidget(
                                role: state.role,
                                namaJukir: state.namaJukirFormatted,
                                nop: state.nop,
                                namaObjekPajak: state.namaOp,
                                onPressed: () {
                                  // context.pushNamed(
                                  //   AppRoutes.dataJukir,
                                  //   extra: {
                                  //     'isPengawas': true,
                                  //     'isShowPendapatan': false,
                                  //   },
                                  // );

                                  context.pushNamed(
                                    AppRoutes.dataJukirList,
                                    extra: {'nop': '357801000390703149'},
                                  );
                                },
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
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              // CARD ABSENSI
                                              PbPermissionGate(
                                                allowedRoles: const [
                                                  RoleLoginDigitalParkir
                                                      .pengawas,
                                                ],
                                                currentRole: state.role,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        bottom: 16,
                                                      ),
                                                  child: MainAbsensiWidget(
                                                    absensiData:
                                                        state.checkInOutData,
                                                  ),
                                                ),
                                              ),

                                              // CARD TOTAL PENDAPATAN
                                              PbPermissionGate(
                                                allowedRoles: [
                                                  RoleLoginDigitalParkir.jukir,
                                                  RoleLoginDigitalParkir.wp,
                                                  RoleLoginDigitalParkir
                                                      .bapenda,
                                                  RoleLoginDigitalParkir
                                                      .pengawas,
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

                                              // CARD REKAP KENDARAAN
                                              PbPermissionGate(
                                                allowedRoles: const [
                                                  RoleLoginDigitalParkir.jukir,
                                                  RoleLoginDigitalParkir
                                                      .bapenda,
                                                  RoleLoginDigitalParkir.wp,
                                                  RoleLoginDigitalParkir
                                                      .pengawas,
                                                ],
                                                currentRole: state.role,
                                                child: CardRekapKendaraanWidget(
                                                  motorCount: state.motorCount,
                                                  mobilCount: state.mobilCount,
                                                  laporanPelanggaran:
                                                      state.laporanPelanggaran,
                                                ),
                                              ),

                                              // CARD TOTAL OP
                                              PbPermissionGate(
                                                allowedRoles: [
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
                                                  child: CardTotalOpWidget(
                                                    totalObjekPajak:
                                                        state.totalOp,
                                                    digitalPercent: state
                                                        .berbayar
                                                        .persentase,
                                                    jmlDigital:
                                                        state.berbayar.digital,
                                                    jmlEdc:
                                                        state.detail.totalEdc,
                                                    jmlQris: state
                                                        .detail
                                                        .totalRompiQris,
                                                    jmlCctv: state
                                                        .detail
                                                        .totalCctvCounting,
                                                    jmlTs: state.detail.totalTs,
                                                    jmlProsesDigital: state
                                                        .berbayar
                                                        .nonDigital,
                                                    jmlGratis:
                                                        state.totalNonTarif,
                                                    onTapDigital: () {},
                                                    onTapProses: () {},
                                                    onTapGratis: () {},
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
                                                      if (!context.mounted) {
                                                        return;
                                                      }
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
                                                  ),
                                                ),
                                              ),

                                              // CARD LAST ACTIVITY
                                              PbPermissionGate(
                                                allowedRoles: const [
                                                  RoleLoginDigitalParkir.jukir,
                                                  // RoleLoginDigitalParkir.wp,
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

                                              // CARD JENIS PEMBAYARAN
                                              PbPermissionGate(
                                                allowedRoles: const [
                                                  RoleLoginDigitalParkir
                                                      .bapenda,
                                                  RoleLoginDigitalParkir.wp,
                                                ],
                                                currentRole: state.role,
                                                child:
                                                    CardRekapJenisPembayaranWidget(
                                                      data: state
                                                          .sofParkirResults,
                                                    ),
                                              ),
                                              // SizedBox(height: 16),
                                              // CardRekapLaporan(),
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
                      ? AnimatedHomeFab(currentRole: state.role)
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
