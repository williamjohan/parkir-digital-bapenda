// lib/features/payment/presentation/pages/payment_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/design_system/components/pb_status_snackbar.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/components/pb_primary_button.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../../../shared/ticket_preview_widget.dart';
import '../cubit/payment_cubit.dart';
import '../cubit/payment_state.dart';

// 1. KELAS BUNGKUS ARGUMEN (Boleh bawa platNomor untuk murni ditampilin di UI)
class PaymentPageArgs {
  final String idTransaksiLokal;
  final String kategoriKendaraan;
  final String platNomor;

  PaymentPageArgs({
    required this.idTransaksiLokal,
    required this.kategoriKendaraan,
    required this.platNomor,
  });
}

class PaymentPage extends StatelessWidget {
  final PaymentPageArgs args;
  final _secureStorage = locator<ISecureStorageManager>();

  PaymentPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<PaymentCubit>()
        ..generateQris(
          idTransaksiLokal: args.idTransaksiLokal,
          kategoriKendaraan: args.kategoriKendaraan,
          // Perhatikan: Cubit TETAP TIDAK MEMINTA platNomor! Sangat Clean!
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
              context.pop(true); // Kembali ke halaman sebelumnya
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

                    // Plat Nomor ditampilkan di sini dari args!
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

                    // TOMBOL "SELESAI"
                    PbPrimaryButton(
                      text: 'Selesai (Simulasi Lunas)',
                      onPressed: () async {
                        final profile = await _secureStorage.getJukirProfile();

                        if (!context.mounted) return; // 🔥 WAJIB

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return Dialog(
                              child: PreviewTicketWidget(
                                deviceId: profile?['idDevice'] ?? '',
                                orderId: state.idTransaksi,
                                objekPajak:
                                    profile?['namaObjekPajak'] ?? 'Objek Pajak',
                                alamatObjekPajak:
                                    profile?['alamat'] ?? 'Alamat Objek Pajak',
                                waktuParkir: DateFormat(
                                  'dd MMM yyyy • HH:mm',
                                  'id_ID',
                                ).format(DateTime.now()),
                                tipeKendaraan: args.kategoriKendaraan == 'motor'
                                    ? 'Motor'
                                    : 'Mobil',
                                isQuickMode: false,
                                isFree: profile?['pungutTarif'] == 1,
                                noKendaraan: args.platNomor,
                                tarifParkir: state.nominal,
                                idTransaksi: state.idTransaksi,
                                okPressed: () {
                                  Navigator.pop(context); // tutup dialog
                                  // context.pop(
                                  //   true,
                                  // ); // balik ke halaman sebelumnya
                                  // context.read<PaymentCubit>().confirmPayment(
                                  //   state.idTransaksi,
                                  // );
                                },
                                printPressed: () {
                                  // nanti bisa integrasi printer di sini
                                },
                              ),
                            );
                          },
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
