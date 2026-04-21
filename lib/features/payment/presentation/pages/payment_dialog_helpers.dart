// lib/features/payment/presentation/widgets/payment_dialog_helpers.dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/constants/app_asset_constant.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';

class PaymentDialogHelpers {
  /// Dialog Sinkronisasi (Loading)
  static void showSyncingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: const Row(
            children: [
              CircularProgressIndicator(color: AppColors.primary),
              SizedBox(width: 24),
              Expanded(
                child: Text(
                  "Memproses Transaksi...",
                  style: AppTypography.bodyText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Dialog Lottie Pembayaran Sukses
  static Future<void> showSuccessLottie(
    BuildContext context,
    bool isFree,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (context) {
        // 🚀 THE FIX: KUNCI TOMBOL KEMBALI HP SELAMA ANIMASI LOTTIE JALAN!
        return PopScope(
          canPop: false,
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  AppAssetLottie.paymentSuccessOrange,
                  width: 200,
                  height: 200,
                  repeat: false,
                ),
                const SizedBox(height: 16),
                Text(
                  isFree ? "Data Parkir Tersimpan!" : "Pembayaran Berhasil!",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    await Future.delayed(const Duration(seconds: 2));
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}
