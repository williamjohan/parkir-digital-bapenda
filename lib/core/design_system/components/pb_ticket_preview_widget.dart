import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/utils/currency_formatter.dart';
import 'pb_primary_button.dart';
import '../tokens/app_colors.dart';
import 'pb_qr_generator_widget.dart';
import '../../../../../core/utils/ticket_crypto_utils.dart';

class PbPreviewTicketWidget extends StatelessWidget {
  final String objekPajak;
  final String alamatObjekPajak;
  final String waktuParkir;
  final String tipeKendaraan;
  final bool isQuickMode;
  final bool isFree;
  final String noKendaraan;
  final int tarifParkir;
  final String idTransaksi;
  final VoidCallback? okPressed;
  final VoidCallback? printPressed;
  final String orderId;
  final String deviceId;

  // 🚀 JADIKAN DEFAULT TRUE (Mencegah crash jika dipanggil dari layar jadul)
  final bool isPrinterReady;

  const PbPreviewTicketWidget({
    super.key,
    required this.objekPajak,
    required this.alamatObjekPajak,
    required this.waktuParkir,
    this.isQuickMode = false,
    required this.tipeKendaraan,
    this.isFree = false,
    this.noKendaraan = '',
    required this.tarifParkir,
    required this.idTransaksi,
    required this.okPressed,
    required this.printPressed,
    required this.orderId,
    required this.deviceId,
    this.isPrinterReady = true, // 🚀 UBAH DI SINI
  });

  String get _urlAfterPayment {
    final encrypted = TicketCryptoUtils.encryptPayload(
      orderId: orderId,
      deviceId: deviceId,
    );
    return 'https://bapenda.surabaya.go.id:7077/CongratulationTaxPayment?id=$encrypted';
  }

  String get _formattedTarif {
    if (tarifParkir == 0 || isFree) return "Gratis";
    return CurrencyFormatter.toIdr(tarifParkir);
  }

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
            objekPajak,
            style: const TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(alamatObjekPajak, textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text(waktuParkir),

          const SizedBox(height: 12),
          const Divider(),

          /// DETAIL KENDARAAN
          Text.rich(
            TextSpan(
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              children: [
                // 1. Tipe Kendaraan (Contoh: Motor)
                TextSpan(text: tipeKendaraan),

                // 2. Plat Nomor (Hanya muncul jika string tidak kosong)
                if (noKendaraan.isNotEmpty) ...[
                  const TextSpan(
                    text: '  •  ',
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextSpan(text: noKendaraan),
                ],

                // 3. Tarif / Gratis
                const TextSpan(
                  text: '  •  ',
                  style: TextStyle(color: Colors.grey),
                ),
                TextSpan(
                  text: _formattedTarif,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // Sentuhan UX: Hijau jika Gratis, Hitam jika Bayar
                    color: (tarifParkir == 0 || isFree)
                        ? Colors.green.shade700
                        : Colors.black,
                  ),
                ),
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
            child: PbQrCodeGenerateWidget(url: _urlAfterPayment, size: 200),
          ),

          const SizedBox(height: 12),

          /// ID TRANSAKSI
          const Text(
            "ID TRANSAKSI",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Text(idTransaksi, textAlign: TextAlign.center),

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
