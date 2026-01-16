// lib/presentation/features/bayar/component/payment_success_dialog.dart
import 'package:flutter/material.dart';
import '../cubit/bayar_cubit.dart';

class PaymentSuccessDialog {
  static void show(
    BuildContext context,
    BayarPaymentSuccess state,
    VoidCallback onOkPressed,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Column(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 60),
              SizedBox(height: 10),
              Text("Pembayaran Berhasil!", textAlign: TextAlign.center),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(),
              _row("Order ID", state.transaction.orderId),
              _row("Bank", state.transaction.acquirer),
              _row("Plat No", state.transaction.platNumber),
              _row("Total", "Rp. ${state.transaction.kredit}"),
              const SizedBox(height: 10),
              const Text(
                "Data transaksi telah disimpan.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  onOkPressed();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5566FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("OK", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        );
      },
    );
  }

  static Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
