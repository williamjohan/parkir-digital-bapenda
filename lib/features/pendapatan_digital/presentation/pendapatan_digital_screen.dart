import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkir_digital_bapenda/features/home/presentation/widgets/card_rekap_jenis_pembayaran_widget.dart';
import 'package:parkir_digital_bapenda/features/home/presentation/widgets/card_rekap_kendaraan_widget.dart';
import 'package:parkir_digital_bapenda/features/pendapatan_digital/presentation/cubit/pendapatan_digital_cubit.dart';
import 'package:parkir_digital_bapenda/features/pendapatan_digital/presentation/widgets/pendapatan_digital_shimmer.dart';
import 'package:parkir_digital_bapenda/features/transaction_history/presentation/widgets/range_filter_widget.dart';
import 'package:parkir_digital_bapenda/shared/loading/loading_overlay.dart';
import '../../../core/design_system/tokens/app_colors.dart';
import '../../../core/design_system/tokens/app_typography.dart';
import '../../home/presentation/widgets/card_total_pendapatan.dart';
import 'cubit/pendapatan_digital_state.dart';

class PendapatanDigitalScreen extends StatefulWidget {
  final String? namaUPTB;
  const PendapatanDigitalScreen({super.key, this.namaUPTB});

  @override
  State<PendapatanDigitalScreen> createState() =>
      _PendapatanDigitalScreenState();
}

class _PendapatanDigitalScreenState extends State<PendapatanDigitalScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PendapatanDigitalCubit, PendapatanDigitalState>(
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state.isFilterLoading,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                widget.namaUPTB == null
                    ? 'Pendapatan Digital'
                    : 'Pendapatan Digital ${widget.namaUPTB}',
                style: AppTypography.heading5,
              ),
              centerTitle: true,
              backgroundColor: AppColors.surface,
              elevation: 0,
              foregroundColor: Colors.black,
            ),
            body: BlocBuilder<PendapatanDigitalCubit, PendapatanDigitalState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return PendapatanDigitalShimmer();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RangeFilterWidget(
                      isTimeRangeShowed: false,
                      onApply:
                          ({
                            required String startDate,
                            required String endDate,
                            required String startTime,
                            required String endTime,
                          }) {
                            context.read<PendapatanDigitalCubit>().getSummary(
                              tglAwal: startDate,
                              tglAkhir: endDate,
                            );
                          },
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              CardTotalPendapatan(
                                isShowHariIni: false,
                                totalKotor:
                                    state.summary?.totalNominalHariIni
                                        .toString() ??
                                    '0',
                                persentasePajak:
                                    "10", // Dummy statis sesuai kesepakatan
                                nominalPajak:
                                    state
                                        .summary
                                        ?.totalNominalBersihUntukBapenda
                                        .toString() ??
                                    '0', // Data Real API
                                totalBersih:
                                    state
                                        .summary
                                        ?.totalNominalBersihUntukWajibPajak
                                        .toString() ??
                                    '0',
                              ),
                              SizedBox(height: 16),
                              CardRekapKendaraanWidget(
                                motorCount:
                                    state.summary?.jumlahMotorHariIni ?? 0,
                                mobilCount:
                                    state.summary?.jumlahMobilHariIni ?? 0,
                              ),
                              CardRekapJenisPembayaranWidget(
                                isShowPembaruanTerakhir: false,
                                data: state.summary?.sofParkirResults ?? [],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
