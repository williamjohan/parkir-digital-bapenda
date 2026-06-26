import 'package:flutter/material.dart';
import '../../../../../core/design_system/tokens/app_colors.dart';
import '../../../../../core/design_system/tokens/app_typography.dart';

class CardMetodePembayaranWidget extends StatelessWidget {
  final String? selectedValue; // Datang dari state.metodePembayaran
  final Function(String value)
  onTap; // Dilempar ke context.read<TransactionCubit>().selectPayment()

  const CardMetodePembayaranWidget({
    super.key,
    required this.selectedValue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "METODE PEMBAYARAN",
                style: AppTypography.heading6.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(width: 2),
              Text("*", style: TextStyle(color: AppColors.error)),
            ],
          ),
          const SizedBox(height: 16),

          /// QRIS
          PaymentItem(
            title: "QRIS",
            subTitle: "Scan kode QR yang diberikan",
            icon: Icons.qr_code,
            isSelected:
                selectedValue == "qris", // 🚀 [ENHANCE]: Cek dari Cubit State
            onTap: () => onTap("qris"),
          ),

          const SizedBox(height: 8),

          /// E-CARD
        ],
      ),
    );
  }
}

class PaymentItem extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentItem({
    super.key,
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.2)
                      : AppColors.textHint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: isSelected
                      ? AppColors.primaryDark
                      : AppColors.textSecondary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.bodyRegular.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected ? AppColors.primary : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subTitle,
                      style: AppTypography.bodySmall.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
