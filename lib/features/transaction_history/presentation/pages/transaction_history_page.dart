// lib/features/transaction_history/presentation/pages/transaction_history_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/design_system/components/pb_cupertino_date_picker.dart';
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
    // [BUG FIX]: Set default ke HARI INI secara Penuh (00:00:00 - 23:59:59)
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

  // --- UX ENHANCEMENT: Bottom Sheet Filter Rentang ---
  void _showFilterMenu() {
    // Variable sementara di dalam bottom sheet
    DateTime tempStart = _startDate;
    DateTime tempEnd = _endDate;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final startStr = DateFormat('dd MMM yyyy').format(tempStart);
            final endStr = DateFormat('dd MMM yyyy').format(tempEnd);

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Filter Rentang Tanggal',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Tombol Pilih Tanggal Awal
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    title: const Text(
                      'Dari Tanggal',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    subtitle: Text(
                      startStr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.calendar_month,
                      color: Colors.blue,
                    ),
                    onTap: () async {
                      final picked = await PbCupertinoDatePicker.show(
                        context: context,
                        initialDate: tempStart,
                      );
                      if (picked != null) {
                        setModalState(
                          () => tempStart = DateTime(
                            picked.year,
                            picked.month,
                            picked.day,
                          ),
                        ); // 00:00:00
                      }
                    },
                  ),
                  const SizedBox(height: 12),

                  // Tombol Pilih Tanggal Akhir
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    title: const Text(
                      'Sampai Tanggal',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    subtitle: Text(
                      endStr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.calendar_month,
                      color: Colors.blue,
                    ),
                    onTap: () async {
                      final picked = await PbCupertinoDatePicker.show(
                        context: context,
                        initialDate: tempEnd,
                      );
                      if (picked != null) {
                        setModalState(
                          () => tempEnd = DateTime(
                            picked.year,
                            picked.month,
                            picked.day,
                            23,
                            59,
                            59,
                          ),
                        ); // 23:59:59
                      }
                    },
                  ),
                  const SizedBox(height: 24),

                  // Tombol Terapkan
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(bottomSheetContext); // Tutup modal
                      setState(() {
                        _startDate = tempStart;
                        _endDate = tempEnd;
                      });
                      // Fetch API dengan tanggal yang sudah diupdate
                      this.context.read<TransactionHistoryCubit>().fetchHistory(
                        _startDate,
                        _endDate,
                      );
                    },
                    child: const Text(
                      'Terapkan Filter',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Bottom Sheet untuk Modal Preview Karcis
  void _showPreviewKarcis(BuildContext context, String orderId) {
    // ... (sama seperti kode sebelumnya) ...
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
                        style: TextStyle(fontSize: 12, color: Colors.grey),
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
                  onPressed: _showFilterMenu,
                  icon: const Icon(Icons.tune, size: 16),
                  label: const Text('Ubah'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // --- LIST DATA ---
          Expanded(
            child:
                BlocBuilder<TransactionHistoryCubit, TransactionHistoryState>(
                  builder: (context, state) {
                    if (state is TransactionHistoryLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is TransactionHistoryError) {
                      return Center(child: Text(state.message));
                    } else if (state is TransactionHistoryLoaded) {
                      final data = state.filteredTransactions;
                      if (data.isEmpty) {
                        return Center(
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
                                'Belum ada transaksi di tanggal ini.',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        );
                      }

                      return RefreshIndicator(
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
                                data[index].orderId,
                              ),
                            );
                          },
                        ),
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
}
