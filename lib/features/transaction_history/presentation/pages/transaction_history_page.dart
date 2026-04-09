// lib/features/transaction_history/presentation/pages/transaction_history_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/design_system/components/pb_calendar_range_picker.dart';
import '../../../../core/design_system/components/pb_ticket_preview_widget.dart';
import '../../../../core/design_system/components/pb_ticket_print_dialog.dart';
import '../../data/models/history_item_model.dart';
import '../cubit/transaction_history_cubit.dart';
import '../cubit/transaction_history_state.dart';
import '../widgets/history_card_widget.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, now.day); // Jam 00:00:00
    _endDate = DateTime(
      now.year,
      now.month,
      now.day,
      23,
      59,
      59,
    ); // Jam 23:59:59

    // Tarik data saat landing
    context.read<TransactionHistoryCubit>().fetchHistory(_startDate, _endDate);
  }

  // --- Date picker
  Future<void> _showCalendarDialog() async {
    final DateTimeRange? picked = await PbCalendarRangePicker.show(
      context: context,
      initialStartDate: _startDate,
      initialEndDate: _endDate,
    );

    if (picked != null) {
      setState(() {
        // Pastikan jamnya diset ke 00:00:00 untuk Start, dan 23:59:59 untuk End
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

      // Minta Jenderal (Cubit) menembak API Bapenda dengan tanggal baru
      if (mounted) {
        context.read<TransactionHistoryCubit>().fetchHistory(
          _startDate,
          _endDate,
        );
      }
    }
  }

  // Bottom Sheet untuk Modal Preview Karcis
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
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(title: const Text('Riwayat Pendapatan')),
      body: Column(
        children: [
          // --- INFO FILTER BAR DI ATAS ---
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

          // --- LIST DATA ---
          Expanded(
            child: BlocBuilder<TransactionHistoryCubit, TransactionHistoryState>(
              builder: (context, state) {
                if (state is TransactionHistoryLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TransactionHistoryError) {
                  return Center(child: Text(state.message));
                } else if (state is TransactionHistoryLoaded) {
                  final data = state.filteredTransactions;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🎁 [FITUR BARU]: BARIS FILTER KATEGORI (CHIPS)
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

                      // AREA LIST TRANSAKSI
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
          // [KUNCI ARSITEKTUR]: Panggil fungsi filter LOKAL di Cubit! Tidak perlu loading API.
          context.read<TransactionHistoryCubit>().applyLocalFilter(
            kategori: value,
          );
        }
      },
    );
  }
}
