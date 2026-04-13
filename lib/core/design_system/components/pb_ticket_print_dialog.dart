import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parkir_digital_bapenda/core/design_system/components/pb_ticket_preview_widget.dart';
import 'package:parkir_digital_bapenda/core/di/injection.dart';
import 'package:parkir_digital_bapenda/features/printer/presentation/cubit/printer_cubit.dart';
import 'package:parkir_digital_bapenda/features/transaction_history/data/models/history_item_model.dart';
import 'package:parkir_digital_bapenda/features/parking_transaction/data/models/local_transaction_model.dart';

class PbTicketPrintDialog {
  /// 🚪 PINTU MASUK 1: Untuk Quick Park & Capture Page (Data Lokal Baru)
  static void showFromLocalTransaction({
    required BuildContext context,
    required LocalTransactionModel localTx,
    required Map<String, dynamic> profile,
    required String kategoriKendaraan,
    required bool isQuickMode,
    required String noKendaraan,
    required int tarifParkir,
    VoidCallback? onClosed, // 🚀 Delegasi Callback untuk pembersihan layar
  }) {
    // Adapter: Ubah dari LocalTransactionModel menjadi HistoryItemModel di udara
    final mappedTransaction = HistoryItemModel(
      id: 0, // 0 karena belum masuk server
      orderId: localTx.idTransaksiLokal,
      jenisTarif: kategoriKendaraan,
      sof: 'CASH',
      platNumber: noKendaraan,
      tglTrx: localTx.waktuTransaksi,
      kredit: tarifParkir,
      namaPetugas: profile['namaUser'] ?? 'Petugas',
      modePlat: isQuickMode ? 0 : 1,
    );

    _showCoreDialog(
      context: context,
      profile: profile,
      transaction: mappedTransaction,
      kategoriKendaraan: kategoriKendaraan,
      isQuickMode: isQuickMode,
      noKendaraan: noKendaraan,
      tarifParkir: tarifParkir,
      onClosed: onClosed,
    );
  }

  /// 🚪 PINTU MASUK 2: Untuk History Page (Data sudah valid dari Server)
  static void showFromHistory({
    required BuildContext context,
    required HistoryItemModel historyTx,
    required Map<String, dynamic> profile,
    VoidCallback? onClosed,
  }) {
    final String rawKategori = historyTx.jenisTarif;
    final String formattedKategori = rawKategori.isNotEmpty
        ? '${rawKategori[0].toUpperCase()}${rawKategori.substring(1).toLowerCase()}'
        : 'Mobil';
    _showCoreDialog(
      context: context,
      profile: profile,
      transaction: historyTx,
      kategoriKendaraan: formattedKategori,
      isQuickMode: historyTx.modePlat == 0,
      noKendaraan: historyTx.platNumber,
      tarifParkir: historyTx.kredit,
      onClosed: onClosed,
    );
  }

  /// ⚙️ CORE ENGINE: Merender UI Dialog dan Logika Bluetooth Printer (Private)
  static void _showCoreDialog({
    required BuildContext context,
    required Map<String, dynamic> profile,
    required HistoryItemModel transaction,
    required String kategoriKendaraan,
    required bool isQuickMode,
    required String noKendaraan,
    required int tarifParkir,
    VoidCallback? onClosed,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          child: PbPreviewTicketWidget(
            deviceId: profile['idDevice']?.toString() ?? '',
            orderId: transaction.orderId,
            objekPajak: profile['namaObjekPajak'] ?? 'Objek Pajak',
            alamatObjekPajak: profile['alamat'] ?? 'Alamat Objek Pajak',
            waktuParkir: DateFormat(
              'dd MMM yyyy • HH:mm',
              'id_ID',
            ).format(DateTime.parse(transaction.tglTrx)),
            tipeKendaraan: kategoriKendaraan,
            isQuickMode: isQuickMode,
            isFree: profile['pungutTarif'] == 1,
            noKendaraan: noKendaraan,
            tarifParkir: tarifParkir,
            idTransaksi: transaction.orderId,

            // --- 🚀 TOMBOL OK (TUTUP & BERSIHKAN LAYAR) ---
            okPressed: () {
              Navigator.pop(dialogContext); // Tutup dialog karcis
              if (onClosed != null) {
                onClosed(); // Eksekusi fungsi titipan dari halaman pemanggil
              }
            },

            // --- 🚀 TOMBOL CETAK (BLUETOOTH PRINTING) ---
            printPressed: () async {
              // 1. Tampilkan notifikasi sedang memproses
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Mengirim ke printer...'),
                  duration: Duration(seconds: 1),
                ),
              );

              // 2. Tembak data ke Cubit melalui Locator (Aman dari dalam Dialog)
              final success = await locator<PrinterCubit>().printReceipt(
                transaction,
                profile['idDevice']?.toString() ?? 'UNKNOWN_DEVICE',
                profile,
              );

              // 3. Cek apakah dialog masih terbuka
              if (!context.mounted) return;

              // 4. Feedback hasil cetak
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Karcis berhasil dicetak! 🖨️'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Gagal mencetak. Pastikan printer menyala & terhubung di Pengaturan!',
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}
