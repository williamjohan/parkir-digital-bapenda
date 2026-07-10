import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:parkir_digital_bapenda/features/payment/presentation/pages/payment_dialog_helpers.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../cubit/payment_cubit.dart';
import '../cubit/payment_state.dart';
import 'payment_local_qris_view.dart';

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
    // Saat initState, Cubit akan load data dan otomatis start SignalR!
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
          title: Text(
            'Pembayaran Qris',
            style: AppTypography.heading5.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColors.surface,
          scrolledUnderElevation: 0,
          shape: const Border(
            bottom: BorderSide(color: AppColors.primary, width: 1.0),
          ),
          elevation: 0,
          foregroundColor: Colors.black,
          iconTheme: const IconThemeData(color: AppColors.primary),
        ),
        body: BlocConsumer<PaymentCubit, PaymentState>(
          //  2. Ubah listener menjadi async
          listener: (context, state) async {
            await state.whenOrNull(
              paymentSuccess: () async {
                // 3. Tampilkan Lottie Dialog dan tunggu sampai selesai (2 detik)
                // isFree = false karena ini adalah pembayaran QRIS
                await PaymentDialogHelpers.showSuccessLottie(context, false);

                // 4. Tutup halaman PaymentPage dan kembalikan nilai 'true' ke TransactionPage
                // Selalu gunakan context.mounted setelah proses await
                if (context.mounted) {
                  context.pop(true);
                }
              },
            );
          },
          builder: (context, state) {
            // UPGRADE: Gunakan maybeWhen karena state 'paymentSuccess'
            // tidak memiliki UI spesifik (hanya men-trigger pop di listener).
            return state.maybeWhen(
              initial: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              localQrisReady: (qrisImagePath, kodeQris) {
                return Column(
                  children: [
                    Expanded(
                      child: PaymentLocalQrisView(
                        kategoriKendaraan: widget.args.kategoriKendaraan,
                        showTimer: kodeQris.trim().isNotEmpty,
                        qrWidget: Image.file(
                          File(qrisImagePath),
                          width: 220,
                          height: 220,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.broken_image, size: 48),
                        ),
                      ),
                    ),
                    if (kodeQris.trim().isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          border: Border(
                            top: BorderSide(color: Colors.orange.shade200),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Pengecekan otomatis tidak tersedia. Harap periksa Di Halaman History',
                                style: AppTypography.bodySmall.copyWith(
                                  color: Colors.orange.shade900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
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
              error: (message) {
                return _QrisErrorView(
                  message: message,
                  onRetry: () => context.read<PaymentCubit>().loadQris(
                    jenisKendaraanId: widget.args.jenisKendaraanId,
                    isDemoMode: widget.args.isDemoMode,
                  ),
                );
              },
              // 🚀 5. Saat paymentSuccess terjadi, UI di latar belakang akan dirender
              // menjadi CircularProgressIndicator selagi Lottie Dialog bermain di atasnya.
              // Ini mencegah pengguna menekan tombol apapun secara tidak sengaja.
              orElse: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
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
              color: AppColors.primaryLight,
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
