import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:parkir_digital_bapenda/core/design_system/components/pb_status_snackbar.dart';
import 'package:parkir_digital_bapenda/core/enums/app_enums.dart';
import 'package:parkir_digital_bapenda/core/utils/string_ext.dart';
import 'package:parkir_digital_bapenda/features/absensi/check_list_absensi/presentation/widgets/main_absensi_widget.dart';
import 'package:parkir_digital_bapenda/features/home/presentation/widgets/card_total_op_widget.dart';
import 'package:parkir_digital_bapenda/features/home/presentation/widgets/card_total_pendapatan.dart';
import 'package:parkir_digital_bapenda/features/home/presentation/widgets/home_drawer.dart';
import 'package:parkir_digital_bapenda/features/home/presentation/widgets/last_activity_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/constants/app_asset_constant.dart';
import '../../../../core/design_system/components/pb_permission_gate.dart';
import '../../../../core/design_system/components/pb_show_dialog.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../shared/loading/app_loading_widget.dart';
import '../../../auth/presentation/cubit/app_auth/app_auth_cubit.dart';
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
      if (mounted) {}
    }
  }

  //Menangani auto-redirect menggunakan GoRouter
  void _handleAutoRedirect(BuildContext context, HomeState state) {
    final session = state.recoveredSession;
    if (session == null) return;

    context.read<HomeCubit>().clearRecoveredSession();

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!context.mounted) return;

      PbStatusSnackbar.show(
        context,
        message: "Sesi foto dipulihkan otomatis. Mengalihkan ke form...",
        isInfo: true,
        isError: false,
      );

      switch (session.intent) {
        case CameraModuleIntent.absensiCheckIn:
          context.push(
            AppRoutes.absensi,
            extra: {'type': ShiftFormType.checkIn, 'file': session.file},
          );
          break;

        case CameraModuleIntent.absensiCheckOut:
          context.push(
            AppRoutes.absensi,
            extra: {'type': ShiftFormType.checkOut, 'file': session.file},
          );
          break;

        case CameraModuleIntent.pengawasan:
          context.push(AppRoutes.addLaporanPelanggaran, extra: session.file);
          break;

        case CameraModuleIntent.unknown:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listenWhen: (previous, current) =>
          previous.recoveredSession != current.recoveredSession &&
          current.recoveredSession != null,
      listener: (context, state) {
        _handleAutoRedirect(context, state);
      },
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return SafeArea(
            top: false,
            bottom: true,
            child: Scaffold(
              backgroundColor: AppColors.background,
              drawer: Skeletonizer(
                enabled: state.status == HomeStatus.loading,
                child: HomeDrawer(
                  isFree: state.isFree,
                  role: state.role,
                  namaUPTB: state.namaJukirFormatted?.shortName,
                  onCheckOpBeforeRouting: () async {
                    if (!state.isOpUpToDate) {
                      await PbShowDialog.show(
                        showBtnKeluar: true,
                        context,
                        title: "Data Berubah",
                        description:
                            "Ada perubahan data objek pajak. Silakan login ulang terlebih dahulu.",
                        buttonText: "Keluar",
                        onConfirm: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext dialogContext) {
                              return const Center(
                                child: AppLoadingWidget(size: 150),
                              );
                            },
                          );
                          await Future.delayed(
                            const Duration(milliseconds: 800),
                          );
                          await locator<AppAuthCubit>().forceLogout();
                        },
                      );

                      return false;
                    }

                    return true;
                  },
                ),
              ),
              body: Stack(
                children: [
                  // 🚀 1. ENTERPRISE GOVERNMENT BACKGROUND DECORATION
                  Container(
                    height:
                        330, // Sedikit dipertinggi agar aman untuk kartu Jukir/Pengawas
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: AppColors.headerGradient,
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: -40,
                          left: -40,
                          child: Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.08),
                                width: 30,
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          top: -10,
                          right: -15,
                          child: ShaderMask(
                            // ShaderMask melarutkan gambar dari jelas di atas -> transparan di bawah
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.white, // Atas: Jelas
                                  Colors.white, // Tengah: Jelas
                                  Colors
                                      .transparent, // Bawah: Hilang total (agar tidak menabrak kartu!)
                                ],
                                stops: [0.0, 0.4, 0.85],
                              ).createShader(bounds);
                            },
                            blendMode: BlendMode.dstIn,
                            child: Opacity(
                              opacity:
                                  0.18, // Opacity pas, tidak terlalu terang & tidak gelap
                              child: Image.asset(
                                AppAssetImages.logosurabayasiloute,
                                height: 240,
                                width: 240,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(),
                          child: Skeletonizer(
                            enabled: state.status == HomeStatus.loading,
                            child: HomeHeaderWidget(
                              role: state.role,
                              namaJukir: state.namaJukir,
                              nop: state.nop,
                              namalokasi: state.namaLokasi,
                              namaObjekPajak: state.namaOp,
                              onPressed: () {
                                context.pushNamed(AppRoutes.opPengawas);
                                // context.pushNamed(
                                //   AppRoutes.dataJukirList,
                                //   extra: {'nop': state.nop},
                                // );
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(top: 14),
                            width: double.infinity,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40),
                              ),
                            ),

                            child: RefreshIndicator(
                              color: AppColors.primary,
                              onRefresh: _loadData,
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // CARD ABSENSI
                                    PbPermissionGate(
                                      allowedRoles: const [
                                        RoleLoginDigitalParkir.pengawas,
                                      ],
                                      currentRole: state.role,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 16,
                                        ),
                                        child: Skeletonizer(
                                          enabled:
                                              state.status ==
                                              HomeStatus.loading,
                                          child: MainAbsensiWidget(
                                            absensiData: state.checkInOutData,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // CARD TOTAL PENDAPATAN
                                    PbPermissionGate(
                                      allowedRoles: const [
                                        RoleLoginDigitalParkir.jukir,
                                        RoleLoginDigitalParkir.wp,
                                        RoleLoginDigitalParkir.bapenda,
                                        RoleLoginDigitalParkir.pengawas,
                                      ],
                                      currentRole: state.role,
                                      child: Padding(
                                        padding: const EdgeInsetsGeometry.only(
                                          bottom: 16,
                                        ),
                                        child: Skeletonizer(
                                          enabled:
                                              state.status ==
                                              HomeStatus.loading,
                                          child: CardTotalPendapatan(
                                            totalKotor: state.totalPendapatan
                                                .toString(),
                                            persentasePajak:
                                                "10", // Dummy statis sesuai kesepakatan
                                            nominalPajak: state.totalPajak
                                                .toInt()
                                                .toString(), // Data Real API
                                            totalBersih: state.totalBersih
                                                .toInt()
                                                .toString(), // Data Real API
                                          ),
                                        ),
                                      ),
                                    ),

                                    // CARD REKAP KENDARAAN
                                    PbPermissionGate(
                                      allowedRoles: const [
                                        RoleLoginDigitalParkir.jukir,
                                        RoleLoginDigitalParkir.bapenda,
                                        RoleLoginDigitalParkir.wp,
                                        RoleLoginDigitalParkir.pengawas,
                                      ],
                                      currentRole: state.role,
                                      child: Skeletonizer(
                                        enabled:
                                            state.status == HomeStatus.loading,
                                        child: CardRekapKendaraanWidget(
                                          isShowPelanggaran:
                                              state.role ==
                                              RoleLoginDigitalParkir.pengawas,
                                          motorCount: state.motorCount,
                                          mobilCount: state.mobilCount,
                                          laporanPelanggaran:
                                              state.laporanPelanggaran,
                                        ),
                                      ),
                                    ),

                                    // CARD TOTAL OP
                                    PbPermissionGate(
                                      allowedRoles: const [
                                        RoleLoginDigitalParkir.bapenda,
                                        RoleLoginDigitalParkir.wp,
                                      ],
                                      currentRole: state.role,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 16,
                                        ),
                                        child: Skeletonizer(
                                          enabled:
                                              state.status ==
                                              HomeStatus.loading,
                                          child: CardTotalOpWidget(
                                            totalObjekPajak: state.totalOp,
                                            digitalPercent:
                                                state.berbayar.persentase,
                                            jmlDigital: state.berbayar.digital,
                                            jmlEdc: state.detail.totalEdc,
                                            jmlQris:
                                                state.detail.totalRompiQris,
                                            jmlCctv:
                                                state.detail.totalCctvCounting,
                                            jmlTs: state.detail.totalTs,
                                            jmlProsesDigital:
                                                state.berbayar.nonDigital,
                                            jmlGratis: state.totalNonTarif,
                                            onTapDigital: () {},
                                            onTapProses: () {},
                                            onTapGratis: () {},
                                            lihatSemuaOnPressed: () async {
                                              if (!state.isOpUpToDate) {
                                                await PbShowDialog.show(
                                                  showBtnKeluar: true,
                                                  context,
                                                  title: "Data Berubah",
                                                  description:
                                                      "Ada perubahan data objek pajak. Silakan login ulang terlebih dahulu.",
                                                  buttonText: "Keluar",
                                                  onConfirm: () async {
                                                    showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder:
                                                          (
                                                            BuildContext
                                                            dialogContext,
                                                          ) {
                                                            return const Center(
                                                              child:
                                                                  AppLoadingWidget(
                                                                    size: 150,
                                                                  ),
                                                            );
                                                          },
                                                    );
                                                    await Future.delayed(
                                                      const Duration(
                                                        milliseconds: 800,
                                                      ),
                                                    );
                                                    await locator<
                                                          AppAuthCubit
                                                        >()
                                                        .forceLogout();
                                                  },
                                                );

                                                return;
                                              }

                                              final result = await context
                                                  .pushNamed(
                                                    AppRoutes.searchObjekPajak,
                                                    extra: {'role': state.role},
                                                  );

                                              if (!context.mounted) return;

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
                                    ),

                                    // CARD LAST ACTIVITY
                                    PbPermissionGate(
                                      allowedRoles: const [
                                        RoleLoginDigitalParkir.jukir,
                                        // RoleLoginDigitalParkir.wp,
                                      ],
                                      currentRole: state.role,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 16,
                                        ),
                                        child: Skeletonizer(
                                          enabled:
                                              state.status ==
                                              HomeStatus.loading,
                                          child: LastActivityWidget(
                                            transactions:
                                                state.recentTransactions,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // CARD JENIS PEMBAYARAN
                                    PbPermissionGate(
                                      allowedRoles: const [
                                        RoleLoginDigitalParkir.bapenda,
                                        RoleLoginDigitalParkir.wp,
                                      ],
                                      currentRole: state.role,
                                      child: Skeletonizer(
                                        enabled:
                                            state.status == HomeStatus.loading,
                                        child: CardRekapJenisPembayaranWidget(
                                          data: state.sofParkirResults,
                                        ),
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

              // floatingActionButton: FeatureFlags.enableCreateOrderFeature
              //     ? AnimatedHomeFab(currentRole: state.role)
              //     : null,
              floatingActionButton: Skeletonizer(
                enabled: state.status == HomeStatus.loading,
                child: AnimatedHomeFab(
                  currentRole: state.role,
                  isFree: false,
                  isDemoMode: state.role == RoleLoginDigitalParkir.bapenda,
                  onReload:
                      _loadData, // Lempar referensi fungsinya, jangan pakai tanda kurung ()
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
