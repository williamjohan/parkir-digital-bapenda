// lib/features/transaction_history/presentation/pages/transaction_history_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkir_digital_bapenda/features/transaction_history/presentation/widgets/hidtory_recap_widget.dart';
import 'package:parkir_digital_bapenda/features/transaction_history/presentation/widgets/range_filter_widget.dart';
import '../../../../core/design_system/components/pb_status_snackbar.dart';
import '../../../../core/design_system/components/pb_ticket_print_dialog.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../shared/loading/loading_overlay.dart';
import '../../data/models/history_item_model.dart';
import '../cubit/transaction_history_cubit.dart';
import '../cubit/transaction_history_state.dart';
import '../widgets/history_card_widget.dart';

class TransactionHistoryPage extends StatefulWidget {
  final DateTime? initialDate;
  final bool isFree;

  const TransactionHistoryPage({
    super.key,
    this.initialDate,
    required this.isFree,
  });

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();

    final targetDate = widget.initialDate ?? DateTime.now();

    _startDate = DateTime(targetDate.year, targetDate.month, targetDate.day);

    _endDate = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
      23,
      59,
      59,
    );

    context.read<TransactionHistoryCubit>().fetchHistory(_startDate, _endDate);
  }

  // 🚀 [REFACTOR CLEAN CODE]: Cukup Panggil Pintu Masuk 2 dari Dialog Engine Anda!
  void _showPreviewKarcis(
    BuildContext context,
    HistoryItemModel item,
    Map<String, dynamic> profile,
  ) {
    PbTicketPrintDialog.showFromHistory(
      context: context,
      historyTx: item,
      profile: profile,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionHistoryCubit, TransactionHistoryState>(
      listener: (context, state) {
        if (state is TransactionHistoryError) {
          PbStatusSnackbar.show(context, message: state.message, isError: true);
        }
      },
      builder: (context, state) {
        final bool isLoading = state is TransactionHistoryLoading;
        return LoadingOverlay(
          isLoading: isLoading,
          child: SafeArea(
            bottom: true,
            top: false,
            child: Scaffold(
              backgroundColor: Colors.grey.shade50,
              appBar: AppBar(
                title: const Text(
                  'Riwayat Pendapatan',
                  style: AppTypography.heading5,
                ),
                centerTitle: true,
                backgroundColor: AppColors.surface,
                elevation: 0,
                foregroundColor: Colors.black,
              ),
              body: Column(
                children: [
                  // --- HEADER TANGGAL (Selalu Tampil) ---
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

                          setState(() {
                            _startDate = start;
                            _endDate = end;
                          });

                          context.read<TransactionHistoryCubit>().fetchHistory(
                            start,
                            end,
                          );
                        },
                  ),
                  // --- AREA KONTEN BAWAH ---
                  Expanded(child: _buildContent(context, state)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, TransactionHistoryState state) {
    if (state is TransactionHistoryError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            state.message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      );
    } else if (state is TransactionHistoryLoaded) {
      final data = state.filteredTransactions;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Kategori (Motor/Mobil/Semua)
          Column(
            children: [
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.only(top: 8, left: 8, right: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(
                        context,
                        'SEMUA',
                        state.selectedKategori,
                        'Semua',
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        context,
                        'MOBIL',
                        state.selectedKategori,
                        'Mobil',
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        context,
                        'MOTOR',
                        state.selectedKategori,
                        'Motor',
                      ),
                    ],
                  ),
                ),
              ),
              Divider(color: AppColors.textHint),
            ],
          ),
          SizedBox(height: 8),
          HistoryRecapWidget(
            roda2: state.roda2.toString(),
            roda4: state.roda4.toString(),
            totalPendapatan: state.totalPendapatan.toString(),
            isFree: widget.isFree,
          ),

          // List Data atau Empty State
          Expanded(
            child: data.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long,
                          size: 80,
                          color: AppColors.textHint,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Tidak ada transaksi untuk filter ini.',
                          style: TextStyle(color: AppColors.textHint),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () => context
                        .read<TransactionHistoryCubit>()
                        .fetchHistory(_startDate, _endDate),
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(top: 8, bottom: 80),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return HistoryCardWidget(
                          item: data[index],
                          onPreviewTap: () => _showPreviewKarcis(
                            context,
                            data[index],
                            state.jukirProfile,
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      );
    }

    // Jika state sedang Loading atau Initial, render area kosong
    // karena layar SUDAH DITUTUPI oleh LoadingOverlay dari luar.
    return const SizedBox();
  }

  Widget _buildFilterChip(
    BuildContext context,
    String value,
    String selectedValue,
    String label,
  ) {
    final bool isSelected = value == selectedValue;
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
          context.read<TransactionHistoryCubit>().applyLocalFilter(
            kategori: value,
          );
        }
      },
    );
  }
}
