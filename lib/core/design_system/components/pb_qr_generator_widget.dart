import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class PbQrCodeGenerateWidget extends StatelessWidget {
  final String url;
  final double size;

  const PbQrCodeGenerateWidget({super.key, required this.url, this.size = 200});

  @override
  Widget build(BuildContext context) {
    final qrCode = QrCode.fromData(
      data: url,
      errorCorrectLevel: QrErrorCorrectLevel.H,
    );

    final qrImage = QrImage(qrCode);

    const decoration = PrettyQrDecoration(
      shape: PrettyQrSmoothSymbol(color: Colors.black),
      background: Colors.white,
      quietZone: PrettyQrQuietZone.standard,
    );

    return SizedBox(
      width: size,
      height: size,
      child: PrettyQrView(qrImage: qrImage, decoration: decoration),
    );
  }
}
