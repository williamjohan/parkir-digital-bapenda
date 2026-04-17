// lib/features/payment/presentation/widgets/payment_qris_view.dart

import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/components/pb_primary_button.dart';
import 'card_detail_parkir.dart';
import 'card_qris_widget.dart';

class PaymentQrisView extends StatelessWidget {
  final String qrisUrl;
  final String kodeQris;
  final String objekPajak;
  final String idTransaksi;
  final String platNomor;
  final String kategoriKendaraan;
  final int nominal;
  final VoidCallback onCheckStatus;

  const PaymentQrisView({
    super.key,
    required this.qrisUrl,
    required this.kodeQris,
    required this.objekPajak,
    required this.idTransaksi,
    required this.platNomor,
    required this.kategoriKendaraan,
    required this.nominal,
    required this.onCheckStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CardQrisWidget(
              url: qrisUrl,
              objekPajak: objekPajak,
              idTransaksi: idTransaksi,
            ),
            const SizedBox(height: 16),
            CardDetailParkirWidget(
              platNomor: platNomor,
              kategoriKendaraan: kategoriKendaraan,
              nominal: nominal,
            ),
            const SizedBox(height: 32),
            const Text(
              "Diterima di semua e-wallet dan bank",
              style: AppTypography.caption,
            ),
            const SizedBox(height: 32),
            PbPrimaryButton(
              text: 'Cek Status Pembayaran',
              onPressed: onCheckStatus,
            ),
          ],
        ),
      ),
    );
  }
}
