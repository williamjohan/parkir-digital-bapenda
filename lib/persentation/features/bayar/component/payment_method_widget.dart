import 'package:flutter/material.dart';

class PaymentMethodWidget extends StatelessWidget {
  final String selectedPayment;
  final Function(String) onChanged;

  const PaymentMethodWidget({
    super.key,
    required this.selectedPayment,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // List pembayaran sesuai gambar
    final payments = [
      {'id': 'QRIS', 'icon': Icons.qr_code, 'label': 'QRIS'},
      {'id': 'BRIZZI', 'icon': Icons.credit_card, 'label': 'BRIZZI'},
      {
        'id': 'e-Money',
        'icon': Icons.account_balance_wallet,
        'label': 'e-Money',
      },
      {'id': 'Flazz', 'icon': Icons.contactless, 'label': 'Flazz'},
      {'id': 'TapCash', 'icon': Icons.wifi_tethering, 'label': 'TapCash'},
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: payments.map((payment) {
        // Hitung lebar item agar muat 3 kolom (kurang lebih)
        // Lebar layar dikurangi padding, dibagi 3
        final double itemWidth =
            (MediaQuery.of(context).size.width - 40 - 24) / 3;

        return _buildPaymentCard(
          payment['id'] as String,
          payment['label'] as String,
          payment['icon'] as IconData,
          itemWidth,
        );
      }).toList(),
    );
  }

  Widget _buildPaymentCard(
    String id,
    String label,
    IconData icon,
    double width,
  ) {
    final bool isSelected = selectedPayment == id;

    return GestureDetector(
      onTap: () => onChanged(id),
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: Colors.blueAccent, width: 2)
              : Border.all(color: Colors.transparent),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF5566FF), size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
