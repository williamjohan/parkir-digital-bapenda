import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart'; // 🚀 IMPORT GOROUTER
import 'package:parkir_digital_bapenda/core/routes/app_routes.dart'; // 🚀 IMPORT APPROUTES
import 'package:parkir_digital_bapenda/features/transaction_history/data/models/history_item_model.dart';
import 'package:parkir_digital_bapenda/core/design_system/components/pb_ticket_preview_widget.dart';
import 'package:parkir_digital_bapenda/core/di/injection.dart';
import 'package:parkir_digital_bapenda/features/printer/presentation/cubit/printer_cubit.dart';
import 'package:parkir_digital_bapenda/features/transaction_history/data/models/history_item_ui_extension.dart';
import '../../../features/parking_transaction/data/models/local_transaction_model.dart';

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
    required String shift,
    bool isPrinterReady =
        true, // 🚀 PARAMETER BARU (Default True agar tidak merusak page lain)
    VoidCallback? onClosed,
  }) {
    final mappedTransaction = HistoryItemModel(
      id: 0,
      orderId: localTx.idTransaksiLokal,
      jenisTarif: kategoriKendaraan,
      sof: 'CASH', // Akan di-override jika pakai logic dinamis sebelumnya
      platNumber: noKendaraan,
      tglTrx: localTx.waktuTransaksi,
      kredit: tarifParkir,
      namaPetugas: profile['namaUser'] ?? 'Petugas',
      modePlat: isQuickMode ? 0 : 1,
      shift: shift,
    );

    _showCoreDialog(
      context: context,
      profile: profile,
      transaction: mappedTransaction,
      kategoriKendaraan: kategoriKendaraan,
      isQuickMode: isQuickMode,
      noKendaraan: mappedTransaction.isNoPlate
          ? ''
          : mappedTransaction.platNumber.toUpperCase(),
      tarifParkir: tarifParkir,
      isPrinterReady: isPrinterReady,
      onClosed: onClosed,
    );
  }

  /// 🚪 PINTU MASUK 2: Untuk History Page (Data sudah valid dari Server)
  static void showFromHistory({
    required BuildContext context,
    required HistoryItemModel historyTx,
    required Map<String, dynamic> profile,
    bool isPrinterReady = true, // 🚀 PARAMETER BARU
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
      noKendaraan: historyTx.isNoPlate
          ? ''
          : historyTx.platNumber.toUpperCase(),
      tarifParkir: historyTx.kredit,
      isPrinterReady: isPrinterReady, // 🚀 Teruskan ke Core
      onClosed: onClosed,
    );
  }

  ///  Merender UI Dialog dan Logika Bluetooth Printer (Private)
  static void _showCoreDialog({
    required BuildContext context,
    required Map<String, dynamic> profile,
    required HistoryItemModel transaction,
    required String kategoriKendaraan,
    required bool isQuickMode,
    required String noKendaraan,
    required int tarifParkir,
    required bool isPrinterReady,
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
            isPrinterReady: isPrinterReady,
            okPressed: () {
              Navigator.pop(dialogContext);
              if (onClosed != null) {
                onClosed();
              }
            },

            // TOMBOL CETAK / HUBUNGKAN PRINTER ---
            printPressed: () async {
              if (!isPrinterReady) {
                context.push(AppRoutes.printerSetting);
                return;
              }

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Mengirim ke printer...'),
                  duration: Duration(seconds: 1),
                ),
              );

              final success = await locator<PrinterCubit>().printReceipt(
                transaction,
                profile['idDevice']?.toString() ?? 'UNKNOWN_DEVICE',
                profile,
              );

              if (!context.mounted) return;

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
