// lib/features/payment/presentation/pages/payment_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/components/pb_status_snackbar.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/components/pb_primary_button.dart';
import '../cubit/payment_cubit.dart';
import '../cubit/payment_state.dart';

// 1. KELAS BUNGKUS ARGUMEN DARI HALAMAN SEBELUMNYA
class PaymentPageArgs {
  final String platNomor;
  final String kategoriKendaraan;
  final String fotoKendaraan; // Base64

  PaymentPageArgs({
    required this.platNomor,
    required this.kategoriKendaraan,
    required this.fotoKendaraan,
  });
}

class PaymentPage extends StatelessWidget {
  final PaymentPageArgs args;

  const PaymentPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Sang Jenderal langsung diperintah membuat QRIS dan Insert SQLite saat halaman dibuka!
      create: (context) => locator<PaymentCubit>()
        ..generateQris(
          platNomor: args.platNomor,
          kategoriKendaraan: args.kategoriKendaraan,
          fotoKendaraan: args.fotoKendaraan,
        ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pembayaran QRIS', style: AppTypography.heading3),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
        ),
        body: BlocConsumer<PaymentCubit, PaymentState>(
          listener: (context, state) {
            if (state is PaymentFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.success,
                ),
              );
            } else if (state is PaymentConfirmed) {
              PbStatusSnackbar.show(context, message: 'Pembayaran Berhasil!');

              context.pop(true); // Kembali ke halaman Capture
            }
          },
          builder: (context, state) {
            if (state is PaymentLoading || state is PaymentInitial) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppColors.primary),
                    SizedBox(height: 16),
                    Text('Menghasilkan QRIS...', style: AppTypography.bodyText),
                  ],
                ),
              );
            }

            if (state is PaymentQrisGenerated) {
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Scan QR Code ini',
                      style: AppTypography.heading2,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Plat: ${args.platNomor} - ${args.kategoriKendaraan.toUpperCase()} - Rp ${state.nominal}',
                      style: AppTypography.bodyText,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 32),

                    // KOTAK DUMMY QRIS
                    Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        border: Border.all(color: AppColors.primary, width: 2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.qr_code_2,
                          size: 150,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'ID: ${state.idTransaksi}',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),

                    const Spacer(),

                    // TOMBOL "SELESAI" (Memicu konfirmasi PAID di SQLite)
                    PbPrimaryButton(
                      text: 'Selesai (Simulasi Lunas)',
                      onPressed: () {
                        context.read<PaymentCubit>().confirmPayment(
                          state.idTransaksi,
                        );
                      },
                    ),
                  ],
                ),
              );
            }

            return const Center(
              child: Text('Terjadi kesalahan.', style: AppTypography.bodyText),
            );
          },
        ),
      ),
    );
  }
}
