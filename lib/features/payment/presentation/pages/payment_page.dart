import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../cubit/payment_cubit.dart';
import '../cubit/payment_state.dart';
import '../widgets/payment_local_qris_view.dart';

class PaymentPageArgs {
  final int jenisKendaraanId;
  final String kategoriKendaraan;
  final bool isDemoMode;

  PaymentPageArgs({
    required this.jenisKendaraanId,
    required this.kategoriKendaraan,
    this.isDemoMode = false,
  });
}

class PaymentPage extends StatefulWidget {
  final PaymentPageArgs args;
  const PaymentPage({super.key, required this.args});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  void initState() {
    super.initState();
    context.read<PaymentCubit>().loadQris(
      jenisKendaraanId: widget.args.jenisKendaraanId,
      isDemoMode: widget.args.isDemoMode,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Pembayaran QRIS', style: AppTypography.heading3),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
        ),
        body: BlocBuilder<PaymentCubit, PaymentState>(
          builder: (context, state) {
            // 🚀 ARCHITECTURE UPGRADE: Menggunakan .when() dari Freezed
            // Ini menjamin 100% Exhaustive Matching. Tidak ada state yang terlewat!
            return state.when(
              initial: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              // 🚀 STATE 1: Data Lokal Jukir (kodeQris sudah standby di sini)
              localQrisReady: (qrisImagePath, kodeQris) {
                return PaymentLocalQrisView(
                  kategoriKendaraan: widget.args.kategoriKendaraan,
                  qrWidget: Image.file(
                    File(qrisImagePath),
                    width: 220,
                    height: 220,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image, size: 48),
                  ),
                );
              },
              // 🚀 STATE 2: Demo Bapenda
              demoQrisReady: (rawQrisString) {
                return PaymentLocalQrisView(
                  kategoriKendaraan: '${widget.args.kategoriKendaraan} (Demo)',
                  qrWidget: QrImageView(
                    data: rawQrisString,
                    version: QrVersions.auto,
                    size: 220,
                    backgroundColor: Colors.white,
                  ),
                );
              },
              // 🚀 STATE 3: Error Handling
              error: (message) {
                return _QrisErrorView(
                  message: message,
                  onRetry: () => context.read<PaymentCubit>().loadQris(
                    jenisKendaraanId: widget.args.jenisKendaraanId,
                    isDemoMode: widget.args.isDemoMode,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _QrisErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _QrisErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.qr_code_2_outlined,
              size: 64,
              color: AppColors.border,
            ),
            const SizedBox(height: 16),
            Text(
              'QRIS Tidak Tersedia',
              style: AppTypography.heading5.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTypography.bodyRegular.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Coba Lagi'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
