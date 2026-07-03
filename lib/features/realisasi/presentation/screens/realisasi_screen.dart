import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/components/pb_basic_bottom_sheet.dart';
import '../../../../shared/loading/loading_overlay.dart';
import '../../../dashboard_op/detail_realisasi_op/presentation/widgets/filter_header_widget.dart';
import '../cubit/realisasi_cubit.dart';
import '../cubit/realisasi_state.dart';
import '../widgets/realisasi_bulan_card.dart';
import '../widgets/realisasi_summary_card.dart';

class RealisasiScreen extends StatelessWidget {
  final String? namaUPTB;
  const RealisasiScreen({super.key, this.namaUPTB});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RealisasiCubit, RealisasiState>(
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state.isLoading,
          child: Scaffold(
            backgroundColor: const Color(0xFFFAFAFA),
            appBar: AppBar(
              title: Text(
                namaUPTB == null || namaUPTB!.isEmpty
                    ? 'Realisasi Pajak'
                    : 'Realisasi Pajak $namaUPTB',
                style: AppTypography.heading5.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
              backgroundColor: AppColors.surface,
              scrolledUnderElevation: 0,
              shape: Border(
                bottom: BorderSide(color: AppColors.primary, width: 1.0),
              ),
              elevation: 0,
              foregroundColor: Colors.black,
              iconTheme: IconThemeData(color: AppColors.primary),
            ),
            body: Column(
              children: [
                FilterHeaderWidget(
                  selectedYear: state.selectedYear,
                  canIncrement: state.canIncrementYear,
                  canDecrement: state.canDecrementYear,
                  onDecrementYear: () =>
                      context.read<RealisasiCubit>().decrementYear(),
                  onIncrementYear: () =>
                      context.read<RealisasiCubit>().incrementYear(),
                  onTapTahun: () => _showYearBottomSheet(context, state),
                ),
                Expanded(child: _buildBodyContent(context, state)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBodyContent(BuildContext context, RealisasiState state) {
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
    if (state.data.isEmpty && !state.isLoading) {
      return const Center(
        child: Text(
          'Belum ada data realisasi untuk tahun ini.',
          style: TextStyle(color: Color(0xFF95A5A6), fontSize: 14),
        ),
      );
    }
    if (state.data.isEmpty) return const SizedBox.shrink(); // Safety check

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          RealisasiSummaryCard(
            pencapaian: state.totalPencapaianPersen,
            realisasi: state.totalRealisasi,
            target: state.totalTarget,
          ),
          const SizedBox(height: 16),

          ...state.data.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: RealisasiBulanCard(item: item),
            );
          }),
        ],
      ),
    );
  }

  void _showYearBottomSheet(BuildContext context, RealisasiState state) {
    final List<int> availableYears = List.generate(
      3,
      (index) => state.currentYear - index,
    );

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
                style: AppTypography.bodySemiBold.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
              tileColor: isSelected
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
              onTap: () {
                Navigator.pop(context);
                context.read<RealisasiCubit>().selectYearFromBottomSheet(year);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
