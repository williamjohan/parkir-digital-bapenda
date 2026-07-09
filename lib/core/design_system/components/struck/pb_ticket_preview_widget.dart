import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/utils/currency_formatter.dart';
import 'package:parkir_digital_bapenda/features/transaction_history/data/models/history_item_ui_extension.dart';
import '../../../../features/transaction_history/data/models/history_item_model.dart';
import '../../tokens/app_colors.dart';
import '../pb_primary_button.dart';
import '../pb_qr_generator_widget.dart';

class PbPreviewTicketWidget extends StatelessWidget {
  final VoidCallback? okPressed;
  final VoidCallback? printPressed;
  final HistoryItemModel item;
  // final Map<String, dynamic> itemOp;
  // 🚀 JADIKAN DEFAULT TRUE (Mencegah crash jika dipanggil dari layar jadul)
  final bool isPrinterReady;

  const PbPreviewTicketWidget({
    super.key,
    required this.okPressed,
    required this.printPressed,
    required this.item,
    required this.isPrinterReady, // 🚀 UBAH DI SINI
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 350),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// HEADER
          const Text(
            "Tiket Parkir",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Text("BAPENDA Kota Surabaya"),

          /// INFO LOKASI
          Text(
            item.namaOp,
            style: const TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(item.alamatOp, textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text(item.formattedDate),

          const SizedBox(height: 12),
          const Divider(),

          /// DETAIL KENDARAAN
          Text.rich(
            TextSpan(
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              children: [
                // 1. Tipe Kendaraan (Contoh: Motor)
                TextSpan(text: item.jenisTarif),

                // 2. Plat Nomor (Hanya muncul jika string tidak kosong)
                const TextSpan(
                  text: '  •  ',
                  style: TextStyle(color: Colors.grey),
                ),
                TextSpan(text: CurrencyFormatter.toIdr(item.kredit)),
              ],
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          /// QR CODE
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              border: Border.all(color: AppColors.primary, width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: PbQrCodeGenerateWidget(url: item.encUrl, size: 200),
          ),

          const SizedBox(height: 12),

          /// ID TRANSAKSI
          const Text(
            "ID TRANSAKSI",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Text(item.orderId, textAlign: TextAlign.center),

          const SizedBox(height: 16),

          /// BUTTONS
          Row(
            children: [
              Expanded(
                child: PbPrimaryButton(text: "OK", onPressed: okPressed),
              ),
              const SizedBox(width: 8),

              // 🚀 LOGIKA TOMBOL DINAMIS: CEK PRINTER READY ATAU TIDAK
              Expanded(
                child: isPrinterReady
                    // JIKA READY: Tampilkan Tombol Cetak Biru Biasa
                    ? PbPrimaryButton(
                        text: "Cetak",
                        iconRight: Icons.print,
                        onPressed: printPressed,
                      )
                    // JIKA BELUM SETTING: Tampilkan Tombol Merah "Hubungkan"
                    : ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: printPressed,
                        icon: const Icon(Icons.bluetooth_disabled, size: 18),
                        label: const FittedBox(
                          child: Text(
                            "Hubungkan",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
