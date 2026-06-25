import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkir_digital_bapenda/features/home/presentation/widgets/card_rekap_jenis_pembayaran_widget.dart';
import 'package:parkir_digital_bapenda/features/home/presentation/widgets/card_rekap_kendaraan_widget.dart';
import 'package:parkir_digital_bapenda/features/pendapatan_digital/presentation/cubit/pendapatan_digital_cubit.dart';
import 'package:parkir_digital_bapenda/features/transaction_history/presentation/widgets/range_filter_widget.dart';
import '../../../core/design_system/tokens/app_colors.dart';
import '../../../core/design_system/tokens/app_typography.dart';
import '../../home/presentation/widgets/card_total_pendapatan.dart';
import 'cubit/pendapatan_digital_state.dart';

class PendapatanDigitalScreen extends StatefulWidget {
  const PendapatanDigitalScreen({super.key});

  @override
  State<PendapatanDigitalScreen> createState() =>
      _PendapatanDigitalScreenState();
}

class _PendapatanDigitalScreenState extends State<PendapatanDigitalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pendapatan Digital', style: AppTypography.heading5),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: BlocBuilder<PendapatanDigitalCubit, PendapatanDigitalState>(
        builder: (context, state) {
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
                          totalKotor:
                              state.summary?.totalNominalHariIni.toString() ??
                              '0',
                          persentasePajak:
                              "10", // Dummy statis sesuai kesepakatan
                          nominalPajak:
                              state.summary?.totalNominalBersihUntukBapenda
                                  .toString() ??
                              '0', // Data Real API
                          totalBersih:
                              state.summary?.totalNominalBersihUntukWajibPajak
                                  .toString() ??
                              '0',
                        ),
                        SizedBox(height: 16),
                        CardRekapKendaraanWidget(
                          motorCount: state.summary?.jumlahMotorHariIni ?? 0,
                          mobilCount: state.summary?.jumlahMobilHariIni ?? 0,
                        ),
                        SizedBox(height: 16),
                        CardRekapJenisPembayaranWidget(
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
    );
  }
}
