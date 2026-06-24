import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkir_digital_bapenda/core/utils/currency_formatter.dart';
import '../../../../../../core/design_system/components/pb_basic_bottom_sheet.dart';
import '../../../../../../core/design_system/tokens/app_colors.dart';
import '../../../../../../core/design_system/tokens/app_typography.dart';
import '../../../../../../shared/loading/loading_overlay.dart';
import '../cubit/detail_realisasi_op_cubit.dart';
import '../cubit/detail_realisasi_op_state.dart';
import '../widgets/filter_header_widget.dart';
import '../widgets/bulan_item_card.dart';
import '../widgets/footer_total_card.dart';

class DetailRealisasiOpPage extends StatelessWidget {
  const DetailRealisasiOpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailRealisasiOpCubit, DetailRealisasiOpState>(
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state.isLoading,
          child: Scaffold(
            backgroundColor: const Color(0xFFFAFAFA),
            appBar: AppBar(
              title: Text('Detail Realisasi', style: AppTypography.heading5),
              centerTitle: true,
              backgroundColor: AppColors.surface,
              elevation: 0,
              foregroundColor: Colors.black,
            ),

            body: BlocBuilder<DetailRealisasiOpCubit, DetailRealisasiOpState>(
              builder: (context, state) {
                return Column(
                  children: [
                    //  1. HEADER FILTER DINAMIS
                    FilterHeaderWidget(
                      selectedYear: state.selectedYear,
                      canIncrement: state.canIncrementYear,
                      onDecrementYear: () {
                        context.read<DetailRealisasiOpCubit>().decrementYear();
                      },
                      onIncrementYear: () {
                        context.read<DetailRealisasiOpCubit>().incrementYear();
                      },
                      onTapTahun: () {
                        _showYearBottomSheet(context, state);
                      },
                    ),

                    // 🚀 2. BODY CONTENT DINAMIS (Loading/Error/Empty/Data)
                    Expanded(child: _buildBodyContent(context, state)),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  // ─── PENGATUR LOGIKA TAMPILAN ───────────────────────────────────────────────

  Widget _buildBodyContent(BuildContext context, DetailRealisasiOpState state) {
    // KONDISI 2: Error Server / Jaringan
    if (state.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                state.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    final data = state.data;
    // KONDISI 3: Data Kosong
    if (data == null || data.realisasiPerBulan.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada data realisasi untuk tahun ini.',
          style: TextStyle(color: Color(0xFF95A5A6), fontSize: 14),
        ),
      );
    }

    // KONDISI 4: Data Sukses (Real Fetch)
    final String formatTotal = CurrencyFormatter.toIdr(
      data.totalNominal.toInt(),
    );
    final String strTahun = state.selectedYear.toString();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          // TotalSummaryCard(tahun: strTahun, totalNominal: formatTotal),
          FooterTotalCard(tahun: strTahun, totalNominal: formatTotal),
          const SizedBox(height: 16),

          ...data.realisasiPerBulan.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: BulanItemCard(
                bulan: item.bulanNama,
                sspd: item.tglSspd.isNotEmpty ? 'SSPD ${item.tglSspd}' : '-',
                nominalNonDigital: item.nominalNonDigital,
                nominalDigital: item.nominalDigital,
                totalNominal: item.totalNominal,
              ),
            );
          }),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ─── BOTTOM SHEET 2 TAHUN TERAKHIR ──────────────────────────────────────────

  void _showYearBottomSheet(
    BuildContext context,
    DetailRealisasiOpState state,
  ) {
    final List<int> availableYears = List.generate(
      2,
      (index) => state.currentYear - index,
    );

    //  Menggunakan komponen Design System Anda
    PbBasicBottomSheet.show(
      context: context,
      title: 'Pilih Tahun',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: availableYears.map((year) {
          final isSelected = year == state.selectedYear;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Text(
                year.toString(),
                textAlign: TextAlign.center,
                // Gunakan AppTypography milik tim Anda
                style: AppTypography.bodySemiBold.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                ),
              ),

              tileColor: isSelected
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
              onTap: () {
                Navigator.pop(context); // Tutup bottom sheet dulu
                context
                    .read<DetailRealisasiOpCubit>()
                    .selectYearFromBottomSheet(year);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
