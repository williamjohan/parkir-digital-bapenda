import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkir_digital_bapenda/features/dashboard_op/detail_tax_surveillance_op/presentation/cubit/detail_tax_surveillance_cubit.dart';
import 'package:parkir_digital_bapenda/features/dashboard_op/detail_tax_surveillance_op/presentation/cubit/detail_tax_surveillance_state.dart';
import 'package:parkir_digital_bapenda/features/transaction_history/presentation/widgets/range_filter_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/design_system/tokens/app_colors.dart';
import '../../../../../core/design_system/tokens/app_typography.dart';
import '../../../../../core/di/injection.dart'; // 🆕 locator
import '../../domain/entities/detail_tax_surveillance_op_entity.dart';
import '../widgets/tax_surveillance_item_card.dart';

class DetailTaxSurveillanceScreen extends StatelessWidget {
  final String? nop;

  const DetailTaxSurveillanceScreen({super.key, this.nop});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<DetailTaxSurveillanceCubit>()..fetchDefault(nop ?? ''),
      child: _DetailTaxSurveillanceView(nop: nop),
    );
  }
}

class _DetailTaxSurveillanceView extends StatefulWidget {
  final String? nop;

  const _DetailTaxSurveillanceView({this.nop});

  @override
  State<_DetailTaxSurveillanceView> createState() =>
      _DetailTaxSurveillanceViewState();
}

class _DetailTaxSurveillanceViewState
    extends State<_DetailTaxSurveillanceView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Detail Tax Surveillance',
          style: AppTypography.heading5.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
        foregroundColor: Colors.black,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: BlocBuilder<DetailTaxSurveillanceCubit, DetailTaxSurveillanceState>(
        builder: (context, state) {
          return Column(
            children: [
              RangeFilterWidget(
                onApply:
                    ({
                      required String startDate,
                      required String endDate,
                      required String startTime,
                      required String endTime,
                    }) {
                      final start = DateTime.parse("$startDate $startTime");
                      final end = DateTime.parse("$endDate $endTime");
                      context.read<DetailTaxSurveillanceCubit>().fetchFiltered(
                        widget.nop ?? '',
                        start,
                        end,
                      );
                    },
              ),
              if (state is TaxSurveillanceLoaded) _buildFilterSection(state),
              const Divider(height: 1, color: AppColors.border),
              Expanded(child: _buildBody(state)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(DetailTaxSurveillanceState state) {
    if (state is DetailTaxSurveillanceLoading) {
      return _buildSkeletonList();
    }

    if (state is TaxSurveillanceError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: AppColors.textHint),
              const SizedBox(height: 12),
              Text(
                state.message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textHint),
              ),
            ],
          ),
        ),
      );
    }

    if (state is TaxSurveillanceLoaded) {
      if (state.isFilterLoading) {
        return _buildSkeletonList();
      }

      final items = state.filteredItems;

      if (items.isEmpty) {
        return _buildEmptyState();
      }

      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'DIPERTAHANKAN',
              style: AppTypography.caption.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TaxSurveillanceItemCard(
                item: TaxSurveillanceItemData(
                  kategori: item.jenisKendaraan,
                  nominal: item.nominal,
                  tanggal: item.tgl,
                ),
              ),
            ),
          ),
        ],
      );
    }

    // TaxSurveillanceInitial
    return const SizedBox();
  }

  Widget _buildSkeletonList() {
    return Skeletonizer(
      enabled: true,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'DIPERTAHANKAN',
              style: AppTypography.caption.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ),
          ...List.generate(
            5,
            (_) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TaxSurveillanceItemCard(
                item: TaxSurveillanceItemData(
                  kategori: 'Motor',
                  nominal: 10000,
                  tanggal: DateTime.now(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 80, color: AppColors.textHint),
          SizedBox(height: 16),
          Text(
            'Tidak ada data untuk filter ini.',
            style: TextStyle(color: AppColors.textHint),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(TaxSurveillanceLoaded state) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(state, 'SEMUA', 'Semua'),
            const SizedBox(width: 8),
            _buildFilterChip(state, 'MOBIL', 'Mobil'),
            const SizedBox(width: 8),
            _buildFilterChip(state, 'MOTOR', 'Motor'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    TaxSurveillanceLoaded state,
    String value,
    String label,
  ) {
    final bool isSelected = value == state.selectedKategori;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: Colors.blue.shade100,
      labelStyle: TextStyle(
        color: isSelected ? Colors.blue.shade800 : Colors.black54,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: Colors.grey.shade100,
      side: BorderSide(color: isSelected ? Colors.blue : Colors.grey.shade300),
      onSelected: (bool selected) {
        if (selected) {
          context.read<DetailTaxSurveillanceCubit>().applyFilter(value);
        }
      },
    );
  }
}