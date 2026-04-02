import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:pointycastle/export.dart';

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

  String _encrypt(String plainText) {
    // KEY: SHA256 dari secret string → 32 bytes
    final keyBytes = Uint8List.fromList(
      sha256.convert(utf8.encode('pisah-key-untuk-semua-bahasa')).bytes,
    );

    // IV: MD5 dari init-vector string → 16 bytes ✅ FIX UTAMA
    final ivBytes = Uint8List.fromList(
      md5.convert(utf8.encode('pisah-init-vector')).bytes,
    );

    final data = Uint8List.fromList(utf8.encode(plainText));

    // AES-CBC dengan PKCS7 padding ✅ FIX UTAMA (sebelumnya ECB, salah!)
    final cipher = PaddedBlockCipherImpl(
      PKCS7Padding(),
      CBCBlockCipher(AESEngine()),
    );

    cipher.init(
      true, // true = encrypt
      PaddedBlockCipherParameters(
        ParametersWithIV(KeyParameter(keyBytes), ivBytes), // CBC butuh IV
        null,
      ),
    );

    final encryptedBytes = cipher.process(data);

    // Base64 URL-safe, sama persis dengan C#
    final result = base64Encode(
      encryptedBytes,
    ).replaceAll('+', '-').replaceAll('/', '_').replaceAll('=', '');

    return result;
  }

  /// 🔗 Generate URL untuk QR Code
  String get _urlAfterPayment {
    // Separator [PISAH] sesuai C#
    final raw = '$orderId[PISAH]$deviceId';

    final encrypted = _encrypt(raw);

    final url =
        'https://bapenda.surabaya.go.id:7077/CongratulationTaxPayment?id=$encrypted';

    // 🔍 DEBUG — otomatis hilang di release build
    assert(() {
      debugPrint('================ QR DEBUG ================');
      debugPrint('ORDER ID   : $orderId');
      debugPrint('DEVICE ID  : $deviceId');
      debugPrint('RAW        : $raw');
      debugPrint('ENCRYPTED  : $encrypted');
      debugPrint(
        'EXPECTED   : XoQ_wkHbMg7_k-ZL00gqlAd7apSOr791Qoh8hD7iQSflEegrWUvNpomdKHuWpXCy',
      );
      debugPrint(
        'MATCH      : ${encrypted == 'XoQ_wkHbMg7_k-ZL00gqlAd7apSOr791Qoh8hD7iQSflEegrWUvNpomdKHuWpXCy'}',
      );
      debugPrint('FINAL URL  : $url');
      debugPrint('==========================================');
      return true;
    }());

    return url;
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

          /// QR CODE
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              border: Border.all(color: AppColors.primary, width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: QrCodeGenerateWidget(url: _urlAfterPayment, size: 200),
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
