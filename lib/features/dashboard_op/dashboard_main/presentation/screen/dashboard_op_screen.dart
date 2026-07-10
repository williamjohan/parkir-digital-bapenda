import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:parkir_digital_bapenda/features/dashboard_op/dashboard_main/presentation/cubit/dashboard_op_cubit.dart';
import 'package:parkir_digital_bapenda/features/dashboard_op/dashboard_main/presentation/widgets/card_income_summary.dart';
import 'package:parkir_digital_bapenda/features/dashboard_op/dashboard_main/presentation/widgets/card_informasi_operasional.dart';
import 'package:parkir_digital_bapenda/features/dashboard_op/dashboard_main/presentation/widgets/header_dashboard_op_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/design_system/tokens/app_colors.dart';
import '../../../../../core/design_system/tokens/app_typography.dart';
import '../../../../../core/routes/app_routes.dart';
import '../cubit/dashboard_op_state.dart';
import '../widgets/card_rekap_jenis_pembayaran_op.dart';
import '../widgets/card_realisasi_op.dart';
import '../widgets/card_riwayat_pendapatan.dart';

class DashboardOpScreen extends StatefulWidget {
  final Map<String, dynamic> item;

  const DashboardOpScreen({super.key, required this.item});

  @override
  State<DashboardOpScreen> createState() => _DashboardOpScreenState();
}

class _DashboardOpScreenState extends State<DashboardOpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Detail Objek Pajak',
          style: AppTypography.heading5.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        scrolledUnderElevation: 0,
        shape: const Border(
          bottom: BorderSide(color: AppColors.primary, width: 1.0),
        ),
        elevation: 0,
        foregroundColor: Colors.black,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: BlocBuilder<DashboardOpCubit, DashboardOpState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Skeletonizer(
                enabled: state.loading,
                child: HeaderDashboardOp(
                  item: widget.item,
                  isDigital: state.data?.isDigital ?? false,
                  onPressedLihatDaftarJukir: () {
                    context.pushNamed(
                      AppRoutes.dataJukir,
                      extra: {'item': widget.item},
                    );
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Skeletonizer(
                          enabled: state.loading,
                          child: CardInformasiOperasional(
                            jamOperasional:
                                state.data?.jadwalOperasional ??
                                "--:-- - --:--",
                            tarifMotor: state.data?.tarifMotor ?? 0,
                            tarifMobil: state.data?.tarifMobil ?? 0,
                          ),
                        ),
                        Skeletonizer(
                          enabled: state.loading,
                          child: DashboardIncomeSummary(
                            totalPendapatan:
                                state.data?.pendapatanHariIniKotor ?? 0,
                            pajakPercent: 10,
                            pendapatanBersih:
                                state.data?.pendapatanHariIniBersihWajibPajak ??
                                0,
                          ),
                        ),

                        Skeletonizer(
                          enabled: state.loading,
                          child: CardRiwayatPendapatanOp(
                            totalMotor: state.data?.totalTransaksiRodaDua ?? 0,
                            totalMobil:
                                state.data?.totalTransaksiRodaEmpat ?? 0,
                            onLihatSemua: () {
                              context.pushNamed(
                                AppRoutes.history,
                                extra: {
                                  'isFree': false,
                                  'nop': widget.item['nop'],
                                },
                              );
                            },
                            riwayat: state.data?.riwayatList ?? [],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Skeletonizer(
                          enabled: state.loading,
                          child: CardRealisasiOp(
                            nonDigital:
                                state.data?.realisasiTahunIni.nonDigital ?? 0,
                            digital: state.data?.realisasiTahunIni.digital ?? 0,
                            totalRealisasi:
                                state.data?.realisasiTahunIni.realisasi ?? 0,
                            onLihatSemua: () {
                              String currentNop = widget.item['nop'];
                              context.pushNamed(
                                AppRoutes.detailRealisasiObjekPajak,
                                extra: currentNop,
                              );
                            },
                          ),
                        ),
                        if (state.data?.isDigital == true) ...[
                          const SizedBox(height: 16),
                          Skeletonizer(
                            enabled: state.loading,
                            child: CardRekapJenisPembayaranOp(
                              items: state.data?.sofList ?? [],
                              onLihatSemua: () {
                                context.pushNamed(
                                  AppRoutes.detailRekapJenisPembayaran,
                                  extra: {'data': state.data?.sofList ?? []},
                                );
                              },
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
