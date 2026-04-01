// lib/features/quick_parking/presentation/pages/quick_park_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/components/pb_show_dialog.dart';
import '../../../../core/design_system/components/pb_status_snackbar.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/routes/app_back_handler.dart';
import '../../../parking_transaction/persentation/cubit/parking_transaction_cubit.dart';
import '../../../parking_transaction/persentation/cubit/parking_transaction_state.dart';
import '../../../parking_transaction/persentation/cubit/sync_cubit.dart';

class QuickParkPage extends StatefulWidget {
  final String kategoriKendaraan; // 'motor' atau 'mobil'

  const QuickParkPage({super.key, required this.kategoriKendaraan});

  @override
  State<QuickParkPage> createState() => _QuickParkPageState();
}

class _QuickParkPageState extends State<QuickParkPage> {
  void _handleTapParkir(BuildContext context) {
    context.read<ParkingTransactionCubit>().processNewTransaction(
      platNomor: null, // Tanpa plat
      kategoriKendaraan: widget.kategoriKendaraan,
      imagePath: null, // Tanpa foto
      modePlat: 0, // 0 = Tanpa Plat
    );
  }

  @override
  Widget build(BuildContext context) {
    final String kategoriTitle =
        widget.kategoriKendaraan[0].toUpperCase() +
        widget.kategoriKendaraan.substring(1).toLowerCase();

    return AppBackHandler(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Parkir Cepat $kategoriTitle',
            style: AppTypography.heading3,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocConsumer<ParkingTransactionCubit, ParkingTransactionState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) {
            if (state is ParkingTransactionFailure) {
              PbStatusSnackbar.show(
                context,
                message: state.message,
                isError: true,
              );
            } else if (state is ParkingTransactionSaveSuccess) {
              // [KUNCI ARSITEKTUR]: Cek status transaksinya!
              final status = state.transaction.status;

              if (status == 'FREE_OFFLINE') {
                // 1. Jika Gratis: Tampilkan sukses kecil dan langsung tendang ke Home
                PbStatusSnackbar.show(
                  context,
                  message: 'Parkir Gratis $kategoriTitle berhasil dicatat!',
                  isError: false,
                );
                context.read<SyncCubit>().syncDataBackground();

                context.pop(); // Kembali ke Home
              } else if (status == 'PENDING_PAYMENT') {
                // 2. Jika Berbayar: Arahkan ke Halaman QRIS
                // (Sementara kita beri dialog peringatan sampai halaman QRIS siap)
                PbShowDialog.show(
                  context,
                  title: 'Arahkan ke Kasir',
                  description:
                      'Fitur Pembayaran/QRIS untuk $kategoriTitle sedang dipersiapkan.',
                );

                // Nanti kodenya diganti menjadi seperti ini:
                // context.pushNamed('payment_page', extra: state.transaction);
              }
            }
          },
          builder: (context, state) {
            final bool isLocked = state is ParkingTransactionLoading;

            return SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: isLocked ? null : () => _handleTapParkir(context),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: isLocked ? 230 : 250,
                        height: isLocked ? 230 : 250,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isLocked
                              ? AppColors.border
                              : AppColors.primary,
                          boxShadow: [
                            if (!isLocked)
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.4),
                                blurRadius: 30,
                                spreadRadius: 10,
                                offset: const Offset(0, 10),
                              ),
                          ],
                        ),
                        child: Center(
                          child: isLocked
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 4,
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.touch_app,
                                      size: 60,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'TAP PARKIR',
                                      style: AppTypography.heading1.copyWith(
                                        color: Colors.white,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    Text(
                      'Tekan lingkaran untuk mencatat\nkendaraan tanpa plat nomor.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyRegular.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
