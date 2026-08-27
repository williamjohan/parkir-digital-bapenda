import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:parkir_digital_bapenda/core/design_system/components/pb_status_snackbar.dart';
import 'package:parkir_digital_bapenda/core/enums/app_enums.dart';
import 'package:parkir_digital_bapenda/core/utils/string_ext.dart';
import 'package:parkir_digital_bapenda/features/absensi/check_list_absensi/presentation/widgets/main_absensi_widget.dart';
import 'package:parkir_digital_bapenda/features/home/presentation/widgets/attention.dart';
import 'package:parkir_digital_bapenda/features/home/presentation/widgets/card_kecamatan.dart';
import 'package:parkir_digital_bapenda/features/home/presentation/widgets/card_total_op_widget.dart';
import 'package:parkir_digital_bapenda/features/home/presentation/widgets/card_total_pendapatan.dart';
import 'package:parkir_digital_bapenda/features/home/presentation/widgets/home_drawer.dart';
import 'package:parkir_digital_bapenda/features/home/presentation/widgets/last_activity_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/constants/app_asset_constant.dart';
import '../../../../core/design_system/components/pb_permission_gate.dart';
import '../../../../core/design_system/components/pb_show_dialog.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../shared/loading/app_loading_widget.dart';
import '../../../auth/presentation/cubit/app_auth/app_auth_cubit.dart';
import '../cubit/counter_kendaraan/jukir_counter_cubit.dart';
import '../cubit/counter_kendaraan/jukir_counter_state.dart';
import '../cubit/home/home_cubit.dart';
import '../cubit/home/home_state.dart';
import '../widgets/animated_home_fab.dart';
import '../widgets/card_laporan_pelanggaran_widget.dart';
import '../widgets/card_rekap_jenis_pembayaran_widget.dart';
import '../widgets/card_rekap_kendaraan_widget.dart';
import '../widgets/home_header_widget.dart';
import '../widgets/jukir_counting/counter_dashboard_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  bool _isFirstLoad = true;
  DateTime? _lastBackPressed;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(
      this,
    ); // 🚀 3. CABUT OBSERVER SAAT KELUAR
    super.dispose();
  }

  Future<void> _handleBackPress(BuildContext context, HomeState state) async {
    debugPrint('>>> BACK PRESSED, role: ${state.role}, nop: ${state.nop}');
    final isPengawas = state.role == RoleLoginDigitalParkir.pengawas;
    final isPengawasWithOp = isPengawas && state.nop.isNotEmpty;

    // Kasus 1: pengawas sedang lihat dashboard sebuah OP -> back = balik ke list kecamatan
    if (isPengawasWithOp) {
      context.read<HomeCubit>().clearObjekPengawasan();
      return;
    }

    // Kasus 2: role lain / pengawas belum pilih OP -> pola "tekan sekali lagi untuk keluar"
    final now = DateTime.now();
    if (_lastBackPressed == null ||
        now.difference(_lastBackPressed!) > const Duration(seconds: 2)) {
      _lastBackPressed = now;
      PbStatusSnackbar.show(
        context,
        message: "Tekan sekali lagi untuk keluar aplikasi",
        isInfo: true,
        isError: false,
      );
      return; // JANGAN keluar dulu
    }

    // Tekan kedua dalam <2 detik -> baru benar-benar keluar
    SystemNavigator.pop();
  }

  Future<void> _loadData() async {
    await context.read<HomeCubit>().initialize();
    if (_isFirstLoad) {
      _isFirstLoad = false;
      if (mounted) {}
    }
  }

  @override
  Future<bool> didPopRoute() async {
    final cubit = context.read<HomeCubit>();
    final state = cubit.state;

    final isPengawas = state.role == RoleLoginDigitalParkir.pengawas;
    final isPengawasWithOp = isPengawas && state.nop.isNotEmpty;

    if (isPengawasWithOp) {
      // SKENARIO A: Di Dashboard. Hapus OP dan mundur ke Kecamatan.
      // Kembalikan TRUE agar aplikasi tidak tertutup!
      cubit.clearObjekPengawasan();
      return true;
    } else {
      // SKENARIO B: Di Layar Kecamatan. Berlakukan Double-Tap to Exit.
      final now = DateTime.now();
      if (_lastBackPressed == null ||
          now.difference(_lastBackPressed!) > const Duration(seconds: 2)) {
        _lastBackPressed = now;
        PbStatusSnackbar.show(
          context,
          message: "Tekan sekali lagi untuk keluar aplikasi",
          isInfo: true,
          isError: false,
        );
        return true; // Kembalikan TRUE (Tahan dulu, tunggu tekan kedua)
      }
      // SKENARIO C: Ditekan 2 kali. Buka pintu, biarkan keluar.
      return false;
    }
  }

  //Menangani auto-redirect menggunakan GoRouter
  void _handleAutoRedirect(BuildContext context, HomeState state) {
    final session = state.recoveredSession;
    if (session == null) return;

    context.read<HomeCubit>().clearRecoveredSession();

    Future.delayed(const Duration(milliseconds: 300), () async {
      if (!context.mounted) return;

      PbStatusSnackbar.show(
        context,
        message: "Sesi foto dipulihkan otomatis. Mengalihkan ke form...",
        isInfo: true,
        isError: false,
      );

      bool? result;

      switch (session.intent) {
        case CameraModuleIntent.absensiCheckIn:
          result = await context.push<bool>(
            AppRoutes.absensi,
            extra: {
              'type': AbsenFormType.checkIn,
              'file': session.file,
              'nop': session.nop,
              'jenis': session.jenis,
              'shift': session.shift,
            },
          );
          break;

        case CameraModuleIntent.absensiCheckOut:
          result = await context.push<bool>(
            AppRoutes.absensi,
            extra: {
              'type': AbsenFormType.checkOut,
              'file': session.file,
              'nop': session.nop,
              'jenis': session.jenis,
              'shift': session.shift,
            },
          );
          break;

        case CameraModuleIntent.pengawasan:
          result = await context.push<bool>(
            AppRoutes.addLaporanPelanggaran,
            extra: session.file,
          );
          break;

        case CameraModuleIntent.unknown:
          return;
      }

      if (!context.mounted) return;
      if (result != true) return;

      final cubit = context.read<HomeCubit>();
      final currentState = cubit.state;

      if (currentState.shiftPengawasan == null ||
          currentState.jenisPengawasan == null) {
        return;
      }

      cubit.loadDashboardPengawas(
        nomorObjek: currentState.nop,
        jenisPengawasan: currentState.jenisPengawasan!.id,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        final cubit = context.read<HomeCubit>();
        _handleBackPress(context, cubit.state);
      },
      child: BlocListener<HomeCubit, HomeState>(
        listenWhen: (previous, current) =>
            previous.recoveredSession != current.recoveredSession &&
            current.recoveredSession != null,
        listener: (context, state) {
          _handleAutoRedirect(context, state);
        },
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final isPengawas = state.role == RoleLoginDigitalParkir.pengawas;
            final isBapendaPengawas =
                state.jenisPengawasan == JenisPengawasan.bapenda;
            final shouldShowRekapPengawasan =
                !isPengawas || (isPengawas && isBapendaPengawas);

            return SafeArea(
              top: false,
              bottom: true,
              child: Scaffold(
                backgroundColor: AppColors.background,
                drawer: Skeletonizer(
                  enabled: state.status == HomeStatus.loading,
                  child: HomeDrawer(
                    nop: state.nop,
                    status: state.status,
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
                    Container(
                      height: 330,
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
                              shaderCallback: (Rect bounds) {
                                return const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.white,
                                    Colors.white,
                                    Colors.transparent,
                                  ],
                                  stops: [0.0, 0.4, 0.85],
                                ).createShader(bounds);
                              },
                              blendMode: BlendMode.dstIn,
                              child: Opacity(
                                opacity: 0.18,
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
                                nmOpd: state.nmOpd,
                                namalokasi: state.namaLokasi,
                                namaObjekPajak: state.namaOp,
                                status: state.status,
                                shift: state.shiftPengawasan,
                                jenis: state.jenisPengawasan,
                                alamatObjekPengawasan:
                                    state.alamatObjekPengawasan,
                                onPressed: () async {
                                  await context.pushNamed(AppRoutes.opPengawas);

                                  if (!context.mounted) return;

                                  context.read<HomeCubit>().initialize();
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

                              child:
                                  state.role ==
                                      RoleLoginDigitalParkir.jukircounter
                                  ? _buildJukirCounterDashboard(context, state)
                                  : state.role ==
                                            RoleLoginDigitalParkir.pengawas &&
                                        state.nop.isEmpty
                                  // TAMPILAN BODY KOSONG JIKA BELUM PILIH OP
                                  ? Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        16,
                                        20,
                                        16,
                                        16,
                                      ),
                                      child:
                                          (state.rekapWilayah == null &&
                                              state.status ==
                                                  HomeStatus.loading)
                                          ? const Center(
                                              child: CircularProgressIndicator(
                                                color: AppColors.primary,
                                              ),
                                            )
                                          : state.rekapWilayah == null
                                          ? Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .assignment_late_rounded,
                                                    size: 64,
                                                    color: Colors.grey.shade300,
                                                  ),
                                                  const SizedBox(height: 16),
                                                  Text(
                                                    "Data Dashboard Belum Tersedia",
                                                    style: AppTypography
                                                        .heading6
                                                        .copyWith(
                                                          color: Colors
                                                              .grey
                                                              .shade600,
                                                        ),
                                                  ),
                                                  Text(
                                                    "Silakan pilih objek di atas.",
                                                    style: AppTypography
                                                        .bodySmall
                                                        .copyWith(
                                                          color: Colors
                                                              .grey
                                                              .shade500,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          // BARU — loop dari data rekap real
                                          : SingleChildScrollView(
                                              // BARU — ganti dari Column biasa, biar semua konten scroll bareng
                                              padding: const EdgeInsets.symmetric(
                                                vertical: 4,
                                              ), // opsional, biar item pertama/terakhir gak nempel mentok
                                              child: Column(
                                                children: [
                                                  const AttentionNoticeCard(),
                                                  const SizedBox(height: 16),
                                                  const SizedBox(height: 16),
                                                  if (state
                                                      .rekapWilayah!
                                                      .detailList
                                                      .isEmpty)
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 32,
                                                          ),
                                                      child: Center(
                                                        child: Text(
                                                          "Belum ada data kecamatan",
                                                          style: AppTypography
                                                              .bodySmall
                                                              .copyWith(
                                                                color: Colors
                                                                    .grey
                                                                    .shade500,
                                                              ),
                                                        ),
                                                      ),
                                                    )
                                                  else
                                                    for (final detail
                                                        in state
                                                            .rekapWilayah!
                                                            .detailList) ...[
                                                      KecamatanStatCard(
                                                        namaKecamatan:
                                                            detail.nmCamat,
                                                        totalObjekPajak: detail
                                                            .jmlObjekPajak,
                                                        totalTju: detail.jmlTju,
                                                      ),
                                                      if (detail !=
                                                          state
                                                              .rekapWilayah!
                                                              .detailList
                                                              .last)
                                                        const SizedBox(
                                                          height: 12,
                                                        ),
                                                    ],
                                                  const SizedBox(height: 16),
                                                ],
                                              ),
                                            ),
                                    )
                                  // TAMPILAN NORMAL (DASHBOARD) JIKA SUDAH PILIH / ROLE LAIN
                                  : RefreshIndicator(
                                      color: AppColors.primary,
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
                                                    absensiData:
                                                        state.checkInOutData,
                                                    pengawasanSequence: state
                                                        .pengawasanSequence
                                                        .toString(),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            // CARD TOTAL PENDAPATAN
                                            if (shouldShowRekapPengawasan)
                                              PbPermissionGate(
                                                allowedRoles: const [
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
                                                      const EdgeInsetsGeometry.only(
                                                        bottom: 16,
                                                      ),
                                                  child: Skeletonizer(
                                                    enabled:
                                                        state.status ==
                                                        HomeStatus.loading,
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
                                              ),

                                            // CARD REKAP KENDARAAN
                                            if (shouldShowRekapPengawasan)
                                              PbPermissionGate(
                                                allowedRoles: const [
                                                  RoleLoginDigitalParkir.jukir,
                                                  RoleLoginDigitalParkir
                                                      .bapenda,
                                                  RoleLoginDigitalParkir.wp,
                                                  RoleLoginDigitalParkir
                                                      .pengawas, // Masih diizinkan di sini, kita saring via 'if' di atas
                                                ],
                                                currentRole: state.role,
                                                child: Skeletonizer(
                                                  enabled:
                                                      state.status ==
                                                      HomeStatus.loading,
                                                  child:
                                                      CardRekapKendaraanWidget(
                                                        motorCount:
                                                            state.motorCount,
                                                        mobilCount:
                                                            state.mobilCount,
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
                                                              barrierDismissible:
                                                                  false,
                                                              builder:
                                                                  (
                                                                    BuildContext
                                                                    dialogContext,
                                                                  ) {
                                                                    return const Center(
                                                                      child: AppLoadingWidget(
                                                                        size:
                                                                            150,
                                                                      ),
                                                                    );
                                                                  },
                                                            );
                                                            await Future.delayed(
                                                              const Duration(
                                                                milliseconds:
                                                                    800,
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
                                                    transactions: state
                                                        .recentTransactions,
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
                                                    state.status ==
                                                    HomeStatus.loading,
                                                child:
                                                    CardRekapJenisPembayaranWidget(
                                                      data: state
                                                          .sofParkirResults,
                                                    ),
                                              ),
                                            ),

                                            // CARD LAPORAN PELANGGARAN
                                            PbPermissionGate(
                                              allowedRoles: const [
                                                RoleLoginDigitalParkir
                                                    .pengawas, // Eksklusif hanya untuk Pengawas
                                              ],
                                              currentRole: state.role,
                                              child: Skeletonizer(
                                                enabled:
                                                    state.status ==
                                                    HomeStatus.loading,
                                                child:
                                                    CardLaporanPelanggaranWidget(
                                                      laporanPelanggaran: state
                                                          .laporanPelanggaran,
                                                    ),
                                              ),
                                            ),
                                            const SizedBox(height: 16),
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

                floatingActionButton: Skeletonizer(
                  enabled: state.status == HomeStatus.loading,
                  child: AnimatedHomeFab(
                    currentRole: state.role,
                    isFree: false,
                    isDemoMode: state.role == RoleLoginDigitalParkir.bapenda,
                    isEnableBuatLaporan:
                        state.checkInOutData.checkIn.isNotEmpty,
                    onReload: _loadData,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget _buildJukirCounterDashboard(BuildContext context, HomeState state) {
  return BlocProvider(
    // 1. Injeksi dan langsung tembak API GET saat widget di-mount
    create: (context) => locator<JukirCounterCubit>()..fetchInitialCounter(),

    child: BlocBuilder<JukirCounterCubit, JukirCounterState>(
      builder: (counterContext, counterState) {
        final isInitialLoading =
            counterState.status == JukirCounterStatus.initial ||
            (counterState.status == JukirCounterStatus.loading &&
                counterState.mobilCount == 0 &&
                counterState.motorCount == 0);

        if (isInitialLoading) {
          return const Padding(
            padding: EdgeInsets.only(top: 64.0),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        if (counterState.status == JukirCounterStatus.failure &&
            counterState.mobilCount == 0 &&
            counterState.motorCount == 0) {
          return Padding(
            padding: const EdgeInsets.only(top: 64.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    counterState.errorMessage ?? 'Gagal memuat data awal.',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => counterContext
                        .read<JukirCounterCubit>()
                        .fetchInitialCounter(),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          );
        }

        return CounterDashboardWidget(
          namaOp: state.namaOp ?? 'Tidak Ada Lokasi',
          alamatOp: state.namaLokasi ?? '-',
        );
      },
    ),
  );
}
