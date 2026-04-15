// lib/features/transaction_history/presentation/pages/transaction_history_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/design_system/components/pb_calendar_range_picker.dart';
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

  const TransactionHistoryPage({super.key, this.initialDate});

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
    _endDate = DateTime(targetDate.year, targetDate.month, targetDate.day);

    context.read<TransactionHistoryCubit>().fetchHistory(_startDate, _endDate);
  }

  Future<void> _showCalendarDialog() async {
    final DateTimeRange? picked = await PbCalendarRangePicker.show(
      context: context,
      initialStartDate: _startDate,
      initialEndDate: _endDate,
    );

    if (picked != null) {
      final difference = picked.end.difference(picked.start).inDays.abs();
      if (difference > 30) {
        PbStatusSnackbar.show(
          context,
          message: 'Rentang waktu maksimal pencarian adalah 30 hari.',
          isError: true,
        );
        return;
      }

      setState(() {
        _startDate = DateTime(
          picked.start.year,
          picked.start.month,
          picked.start.day,
        );
        _endDate = DateTime(
          picked.end.year,
          picked.end.month,
          picked.end.day,
          23,
          59,
          59,
        );
      });

      if (mounted) {
        context.read<TransactionHistoryCubit>().fetchHistory(
          _startDate,
          _endDate,
        );
      }
    }
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
    return BlocListener<TransactionHistoryCubit, TransactionHistoryState>(
      listener: (context, state) {
        if (state is TransactionHistoryError) {
          PbStatusSnackbar.show(context, message: state.message, isError: true);
        }
      },
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
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Menampilkan data:',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          '${DateFormat('dd MMM yyyy').format(_startDate)} - ${DateFormat('dd MMM yyyy').format(_endDate)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: _showCalendarDialog,
                    icon: const Icon(Icons.calendar_month, size: 16),
                    label: const Text('Ubah'),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            Expanded(
              child: BlocBuilder<TransactionHistoryCubit, TransactionHistoryState>(
                builder: (context, state) {
                  if (state is TransactionHistoryLoading) {
                    return LoadingOverlay(isLoading: true, child: Center());
                    // return const Center(child: CircularProgressIndicator());
                    // final bool isLoading = state is TransactionHistoryLoading;
                  } else if (state is TransactionHistoryError) {
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
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
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

                        Expanded(
                          child: data.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.receipt_long,
                                        size: 80,
                                        color: Colors.grey.shade300,
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'Tidak ada transaksi untuk filter ini.',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                )
                              : RefreshIndicator(
                                  onRefresh: () => context
                                      .read<TransactionHistoryCubit>()
                                      .fetchHistory(_startDate, _endDate),
                                  child: ListView.builder(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    padding: const EdgeInsets.only(
                                      top: 8,
                                      bottom: 80,
                                    ),
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
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
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
