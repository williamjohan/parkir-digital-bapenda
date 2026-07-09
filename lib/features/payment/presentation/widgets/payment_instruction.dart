import 'package:flutter/material.dart';
import '../../../../../core/design_system/tokens/app_colors.dart';
import '../../../../../core/design_system/tokens/app_typography.dart';

class PaymentInstruction extends StatelessWidget {
  const PaymentInstruction({super.key});

  static const _steps = [
    'Buka aplikasi mobile banking atau dompet digital Anda',
    'Pilih menu Scan QR / QRIS',
    'Arahkan kamera ke kode QRIS di atas',
    'Periksa detail dan konfirmasi pembayaran',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.list_alt_rounded,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 6),
              Text(
                'Cara Pembayaran',
                style: AppTypography.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ..._steps.asMap().entries.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.only(right: 8, top: 1),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${e.key + 1}',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      e.value,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
