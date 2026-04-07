// lib/features/quick_parking/presentation/pages/quick_park_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/design_system/components/pb_show_dialog.dart';
import '../../../../core/design_system/components/pb_status_snackbar.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/routes/app_back_handler.dart';
import '../../../../core/design_system/components/pb_ticket_preview_widget.dart';
import '../../../parking_transaction/persentation/cubit/parking_transaction_cubit.dart';
import '../../../parking_transaction/persentation/cubit/parking_transaction_state.dart';
import '../../../parking_transaction/persentation/cubit/sync_cubit.dart';
import '../../../printer/presentation/cubit/printer_cubit.dart';
import '../../../transaction_history/data/models/history_item_model.dart';

class QuickParkPage extends StatefulWidget {
  final String kategoriKendaraan; // 'motor' atau 'mobil'

  const QuickParkPage({super.key, required this.kategoriKendaraan});

  @override
  State<QuickParkPage> createState() => _QuickParkPageState();
}

class _QuickParkPageState extends State<QuickParkPage> {
  // 🧹 BERSIH! Tidak ada lagi inisialisasi _secureStorage di sini.

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
              final status = state.transaction.status;

              // 🎁 KUNCI ARSITEKTUR: Buka koper profil dari Jenderal (Cubit)!
              final profile = state.jukirProfile;

              if (status == 'FREE_OFFLINE') {
                context.read<SyncCubit>().syncDataBackground();

                // 🚀 LANGSUNG PANGGIL UI: Tanpa await, tanpa !context.mounted
                PbShowDialog.show(
                  context,
                  title: 'Berhasil!',
                  description:
                      'Parkir Gratis $kategoriTitle\nberhasil dicatat.',
                  onConfirm: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return Dialog(
                          child: PbPreviewTicketWidget(
                            deviceId: profile['idDevice'] ?? '',
                            orderId: state.transaction.idTransaksiLokal,
                            objekPajak:
                                profile['namaObjekPajak'] ?? 'Objek Pajak',
                            alamatObjekPajak:
                                profile['alamat'] ?? 'Alamat Objek Pajak',
                            waktuParkir:
                                DateFormat(
                                  'dd MMM yyyy • HH:mm',
                                  'id_ID',
                                ).format(
                                  DateTime.parse(
                                    state.transaction.waktuTransaksi,
                                  ),
                                ),
                            tipeKendaraan: widget.kategoriKendaraan,
                            isQuickMode: true,
                            isFree: profile['pungutTarif'] == 1,
                            noKendaraan: '',
                            tarifParkir: 0,
                            idTransaksi: state.transaction.idTransaksiLokal,
                            okPressed: () => Navigator.pop(context),
                            printPressed: () async {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Mengirim ke printer...'),
                                  duration: Duration(seconds: 1),
                                ),
                              );

                              // 🚀 1. THE ADAPTER: Ubah LocalModel menjadi HistoryModel di udara!
                              // (Sesuaikan field di sebelah kanan dengan nama property asli di LocalTransactionModel Anda)
                              final mappedTransaction = HistoryItemModel(
                                id: 0, // Isi 0 saja karena ID row server belum ada (ini transaksi offline)
                                orderId: state.transaction.idTransaksiLokal,
                                jenisTarif: widget
                                    .kategoriKendaraan, // Misal: 'Motor' atau 'Mobil'
                                sof: 'CASH',
                                platNumber:
                                    'Tanpa Plat', // Karena ini Quick Park
                                tglTrx: state.transaction.waktuTransaksi,
                                kredit:
                                    0, // Sesuaikan jika ada field tarif/nominal di state.transaction
                                namaPetugas: profile['namaUser'] ?? 'Petugas',
                                modePlat: 0, // 0 = tanpa plat
                              );

                              // 🚀 2. Tembakkan Model yang sudah dikonversi ke PrinterCubit
                              final success = await locator<PrinterCubit>()
                                  .printReceipt(
                                    mappedTransaction,
                                    profile['idDevice']?.toString() ??
                                        'UNKNOWN_DEVICE',
                                  );

                              if (!context.mounted) return;

                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Karcis berhasil dicetak! 🖨️',
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Gagal mencetak. Pastikan printer menyala & terhubung di Pengaturan!',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      },
                    );
                  },
                );
              } else if (status == 'PENDING_PAYMENT') {
                PbShowDialog.show(
                  context,
                  title: 'Arahkan ke Kasir',
                  description:
                      'Fitur Pembayaran/QRIS untuk $kategoriTitle sedang dipersiapkan.',
                );
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
