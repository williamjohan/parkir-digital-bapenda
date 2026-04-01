import 'dart:convert';

import 'package:flutter/material.dart';
import '../core/design_system/components/pb_primary_button.dart';
import '../core/design_system/tokens/app_colors.dart';
import 'qr_generator_widget.dart';

class PreviewTicketWidget extends StatelessWidget {
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

  const PreviewTicketWidget({
    super.key,
    required this.objekPajak,
    required this.alamatObjekPajak,
    required this.waktuParkir,
    required this.tipeKendaraan,
    this.isQuickMode = false,
    this.isFree = false,
    this.noKendaraan = '',
    required this.tarifParkir,
    required this.idTransaksi,
    required this.okPressed,
    required this.printPressed,
    required this.orderId,
    required this.deviceId,
  });

  /// 🔐 Helper encrypt (sementara base64)
  String _encrypt(String input) {
    return base64Encode(utf8.encode(input));
  }

  /// 🔗 Generate URL
  String get _urlAfterPayment {
    final raw = '$orderId|$deviceId';
    final encrypted = _encrypt(raw);

    final url =
        'https://bapenda.surabaya.go.id:7077/CongratulationTaxPayment?id=$encrypted';

    // 🔍 DEBUG
    print('================ QR DEBUG ================');
    print('ORDER ID   : $orderId');
    print('DEVICE ID  : $deviceId');
    print('RAW        : $raw');
    print('ENCRYPTED  : $encrypted');
    print('FINAL URL  : $url');
    print('==========================================');

    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 350, // biar dialog ga terlalu lebar
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // penting biar ga full tinggi
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// HEADER
          const Text(
            "Tiket Parkir",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          // const SizedBox(height: 4),
          const Text("BAPENDA Kota Surabaya"),
          // const SizedBox(height: 12),

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

          /// DETAIL
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(child: Text(tipeKendaraan)),

              const SizedBox(width: 6),
              const Text('•'),
              const SizedBox(width: 6),
              Flexible(child: Text(isQuickMode ? '[Tanpa Plat]' : noKendaraan)),

              const SizedBox(width: 6),
              const Text('•'),
              const SizedBox(width: 6),

              Flexible(
                child: Text(
                  "Rp$tarifParkir",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// QR
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              border: Border.all(color: AppColors.primary, width: 2),
              borderRadius: BorderRadius.circular(16),
            ),

            // child: const Center(
            //   child: Icon(Icons.qr_code_2, size: 120, color: AppColors.primary),
            // ),
            child: QrCodeGenerateWidget(
              url:
                  _urlAfterPayment, // atau bisa diganti dengan data lain (misal qrisString)
              size: 200,
            ),
          ),

          const SizedBox(height: 12),

          /// ID
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
              Expanded(
                child: PbPrimaryButton(
                  text: "",
                  icon: Icons.print,
                  onPressed: printPressed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
