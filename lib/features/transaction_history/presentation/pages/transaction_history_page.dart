// lib/features/transaction_history/presentation/pages/transaction_history_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/design_system/components/pb_calendar_range_picker.dart';
import '../../../../core/design_system/components/pb_ticket_preview_widget.dart';
// 🚀 [BARU] Pastikan import Snackbar sudah ada
import '../../../../core/design_system/components/pb_status_snackbar.dart';
import '../../data/models/history_item_model.dart';
import '../cubit/transaction_history_cubit.dart';
import '../cubit/transaction_history_state.dart';
import '../widgets/history_card_widget.dart';

class TransactionHistoryPage extends StatefulWidget {
  // 🚀 [BARU] Parameter untuk menangkap tanggal dari Home
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

    // 🚀 [REFACTOR] Gunakan tanggal kiriman dari Home, atau hari ini jika null
    final targetDate = widget.initialDate ?? DateTime.now();

    _startDate = DateTime(targetDate.year, targetDate.month, targetDate.day);
    _endDate = DateTime(targetDate.year, targetDate.month, targetDate.day);

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
      // 🚀 [UI VALIDATION]: Pencegahan ganda (Opsional).
      // Cubit akan menolak > 30 hari, tapi kita juga bisa mencegah state UI berubah jika tidak valid.
      final difference = picked.end.difference(picked.start).inDays.abs();
      if (difference > 30) {
        PbStatusSnackbar.show(
          context,
          message: 'Rentang waktu maksimal pencarian adalah 30 hari.',
          isError: true,
        );
        return; // Batal mengubah tanggal
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

  // Bottom Sheet untuk Modal Preview Karcis
  void _showPreviewKarcis(
    BuildContext context,
    HistoryItemModel item,
    Map<String, dynamic> profile,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        String formattedDate = item.tglTrx;
        try {
          final date = DateTime.parse(item.tglTrx);
          formattedDate = DateFormat(
            'dd MMM yyyy • HH:mm',
            'id_ID',
          ).format(date);
        } catch (_) {}

        return Dialog(
          child: PbPreviewTicketWidget(
            deviceId: profile['idDevice']?.toString() ?? '',
            orderId: item.orderId,
            objekPajak: profile['namaObjekPajak'] ?? 'Objek Pajak',
            alamatObjekPajak: profile['alamat'] ?? 'Alamat Objek Pajak',
            waktuParkir: formattedDate,
            tipeKendaraan: item.jenisTarif,
            isQuickMode: item.modePlat == 0,
            isFree: item.kredit == 0 || item.jenisTarif == 'FREE',
            noKendaraan: item.platNumber == '-' ? '' : item.platNumber,
            tarifParkir: item.kredit,
            idTransaksi: item.orderId,
            okPressed: () => Navigator.pop(context),
            printPressed: () {
              // TODO: Integrasi Printer Bluetooth
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 🚀 [BARU] Bungkus Scaffold dengan BlocListener untuk menangkap pesan Error/Validasi
    return BlocListener<TransactionHistoryCubit, TransactionHistoryState>(
      listener: (context, state) {
        if (state is TransactionHistoryError) {
          PbStatusSnackbar.show(context, message: state.message, isError: true);
        }
      },
      child: Scaffold(
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
                    // Tampilkan pesan error di tengah layar selain dari Snackbar
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
