import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'package:parkir_digital_bapenda/features/transaction/widgets/card_metode_pembayaran.dart';
import 'package:parkir_digital_bapenda/features/transaction/widgets/card_nopol_widget.dart';

import '../../../core/design_system/tokens/app_typography.dart';
import '../widgets/card_jenis_kendaraan.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: GestureDetector(
          onDoubleTap: () {
            // Hanya bisa dibuka saat mode Debug (Aman dari user asli!)
            if (kDebugMode) {
              ChuckerFlutter.showChuckerScreen();
            }
          },
          child: const Text('Transaksi Parkir', style: AppTypography.heading5),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            CardNopolWidget(),
            SizedBox(height: 16),
            CardJenisKendaraan(),
            SizedBox(height: 16),
            CardMetodePembayaranWidget(),
          ],
        ),
      ),
    );
  }
}
