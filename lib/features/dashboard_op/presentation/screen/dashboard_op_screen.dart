import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:parkir_digital_bapenda/features/dashboard_op/presentation/cubit/dashboard_op_cubit.dart';
import 'package:parkir_digital_bapenda/features/dashboard_op/presentation/widgets/header_dashboard_op_widget.dart';
import 'package:parkir_digital_bapenda/shared/loading/loading_overlay.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/routes/app_routes.dart';
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
        title: Text('Detail Objek Pajak', style: AppTypography.heading5),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: BlocBuilder<DashboardOpCubit, DashboardOpState>(
        builder: (context, state) {
          return LoadingOverlay(
            isLoading: state.loading,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HeaderDashboardOp(
                    item: widget.item,
                    totalPendapatan: state.data?.pendapatanHariIniKotor ?? 0,
                    pajakPercent: 10,
                    pendapatanBersih:
                        state.data?.pendapatanHariIniBersihWajibPajak ?? 0,
                    isDigital: state.data?.isDigital ?? false,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CardRiwayatPendapatanOp(
                              totalMotor:
                                  state.data?.totalTransaksiRodaDua ?? 0,
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
                            SizedBox(height: 16),
                            CardRealisasiOp(
                              nonDigital:
                                  state.data?.realisasiTahunIni.nonDigital ?? 0,
                              digital:
                                  state.data?.realisasiTahunIni.digital ?? 0,
                              totalRealisasi:
                                  state.data?.realisasiTahunIni.realisasi ?? 0,
                              onLihatSemua: () {},
                            ),
                            SizedBox(height: 16),
                            CardRekapJenisPembayaranOp(
                              items: state.data?.sofList ?? [],
                              onLihatSemua: () {
                                context.pushNamed(
                                  AppRoutes.detailRekapJenisPembayaran,
                                  extra: {'data': state.data?.sofList ?? []},
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
