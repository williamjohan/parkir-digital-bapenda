import 'package:flutter/material.dart';
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
import 'package:parkir_digital_bapenda/features/home/presentation/widgets/jadwal_shift_card.dart';
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
import '../cubit/home/home_cubit.dart';
import '../cubit/home/home_state.dart';
import '../widgets/animated_home_fab.dart';
import '../widgets/card_laporan_pelanggaran_widget.dart';
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
            extra: {
              'type': ShiftFormType.checkIn,
              'file': session.file,
              'nop': session.nop,
              'jenis': session.jenis,
              'shift': session.shift,
            },
          );
          break;

        case CameraModuleIntent.absensiCheckOut:
          context.push(
            AppRoutes.absensi,
            extra: {
              'type': ShiftFormType.checkOut,
              'file': session.file,
              'nop': session.nop,
              'jenis': session.jenis,
              'shift': session.shift,
            },
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
                              onPressed: () async {
                                await context.pushNamed(AppRoutes.opPengawas);
                                if (context.mounted) {
                                  context.read<HomeCubit>().initialize();
                                }
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
                                state.role == RoleLoginDigitalParkir.pengawas &&
                                    state.status == HomeStatus.needsSelection
                                // TAMPILAN BODY KOSONG JIKA BELUM PILIH OP
                                ? Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      16,
                                      20,
                                      16,
                                      16,
                                    ),
                                    child: state.rekapWilayah == null
                                        ? Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.assignment_late_rounded,
                                                  size: 64,
                                                  color: Colors.grey.shade300,
                                                ),
                                                const SizedBox(height: 16),
                                                Text(
                                                  "Data Dashboard Belum Tersedia",
                                                  style: AppTypography.heading6
                                                      .copyWith(
                                                        color: Colors
                                                            .grey
                                                            .shade600,
                                                      ),
                                                ),
                                                Text(
                                                  "Silakan pilih objek di atas.",
                                                  style: AppTypography.bodySmall
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
                                                const JadwalShiftCard(),
                                                const SizedBox(height: 16),
                                                // BARU — ganti dari Expanded+ListView.separated jadi Column biasa,
                                                // karena sekarang parent-nya scrollable, gak perlu scrollable
                                                // bersarang lagi
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
                                                      totalObjekPajak:
                                                          detail.jmlObjekPajak,
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
                                                RoleLoginDigitalParkir.bapenda,
                                                RoleLoginDigitalParkir.pengawas,
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
                                                RoleLoginDigitalParkir.bapenda,
                                                RoleLoginDigitalParkir.wp,
                                                RoleLoginDigitalParkir
                                                    .pengawas, // Masih diizinkan di sini, kita saring via 'if' di atas
                                              ],
                                              currentRole: state.role,
                                              child: Skeletonizer(
                                                enabled:
                                                    state.status ==
                                                    HomeStatus.loading,
                                                child: CardRekapKendaraanWidget(
                                                  motorCount: state.motorCount,
                                                  mobilCount: state.mobilCount,
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
                                                  digitalPercent:
                                                      state.berbayar.persentase,
                                                  jmlDigital:
                                                      state.berbayar.digital,
                                                  jmlEdc: state.detail.totalEdc,
                                                  jmlQris: state
                                                      .detail
                                                      .totalRompiQris,
                                                  jmlCctv: state
                                                      .detail
                                                      .totalCctvCounting,
                                                  jmlTs: state.detail.totalTs,
                                                  jmlProsesDigital:
                                                      state.berbayar.nonDigital,
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
                                                                    child:
                                                                        AppLoadingWidget(
                                                                          size:
                                                                              150,
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
                                                          AppRoutes
                                                              .searchObjekPajak,
                                                          extra: {
                                                            'role': state.role,
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
                                                  state.status ==
                                                  HomeStatus.loading,
                                              child:
                                                  CardRekapJenisPembayaranWidget(
                                                    data:
                                                        state.sofParkirResults,
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
                  isEnableBuatLaporan: state.checkInOutData.checkIn.isNotEmpty,
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
