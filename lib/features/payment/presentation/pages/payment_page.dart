import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../cubit/payment_cubit.dart';
import '../cubit/payment_state.dart';
import '../widgets/payment_local_qris_view.dart';

// ─── ARGS ─────────────────────────────────────────────────────────────────────

class PaymentPageArgs {
  final int jenisKendaraanId;
  final String kategoriKendaraan;

  // Field legacy — dipertahankan agar tidak break kode lain.
  // TODO: hapus setelah semua flow migrasi ke QRIS Rompi.
  final String idTransaksiLokal;
  final String platNomor;
  final int nominal;
  final String latitude;
  final String longitude;

  PaymentPageArgs({
    required this.jenisKendaraanId,
    required this.kategoriKendaraan,
    this.idTransaksiLokal = '',
    this.platNomor = '',
    this.nominal = 0,
    this.latitude = '0',
    this.longitude = '0',
  });
}

// ─── PAGE ─────────────────────────────────────────────────────────────────────
// BlocProvider ada di router (app_router.dart), bukan di sini.
// PaymentPage hanya membaca cubit via context.read — tidak create, tidak dispose.
// Lifecycle cubit sepenuhnya dikendalikan oleh BlocProvider di router.

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
    // Cubit sudah tersedia di context karena BlocProvider ada di router.
    // Panggil loadLocalQris di sini — aman karena widget sudah mounted.
    context.read<PaymentCubit>().loadLocalQris(widget.args.jenisKendaraanId);
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
            if (state is PaymentLocalQrisLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (state is PaymentLocalQrisReady) {
              return PaymentLocalQrisView(
                imagePath: state.qrisImagePath,
                kategoriKendaraan: widget.args.kategoriKendaraan,
                // TODO: aktifkan saat SignalR siap
                // onCheckStatus: () => context.read<PaymentCubit>().checkStatus(),
              );
            }

            if (state is PaymentLocalQrisError) {
              return _QrisErrorView(
                message: state.message,
                onRetry: () => context.read<PaymentCubit>().loadLocalQris(
                  widget.args.jenisKendaraanId,
                ),
              );
            }

            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          },
        ),
      ),
    );
  }
}

// ─── ERROR VIEW ───────────────────────────────────────────────────────────────

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
