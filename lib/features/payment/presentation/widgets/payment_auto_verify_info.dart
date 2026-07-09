import 'package:flutter/material.dart';
import '../../../../../core/design_system/tokens/app_typography.dart';

class PaymentAutoVerifyInfo extends StatelessWidget {
  const PaymentAutoVerifyInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFFE082)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 16,
            color: Color(0xFFF9A825),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Transaksi akan tercatat otomatis setelah pembayaran berhasil diverifikasi oleh sistem.',
              style: AppTypography.caption.copyWith(
                color: const Color(0xFF795548),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
