// lib/features/transaction/page/transaction_page.dart

import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/components/pb_primary_button.dart';
import '../../../../core/design_system/components/pb_status_snackbar.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../core/design_system/components/pb_ticket_print_dialog.dart';
import '../../payment/presentation/pages/payment_page.dart';
import '../cubit/transaction_cubit.dart';
import '../cubit/transaction_state.dart';
import '../widgets/card_jenis_kendaraan.dart';
import '../widgets/card_metode_pembayaran.dart';
import '../widgets/card_nopol_widget.dart';

class TransactionPage extends StatefulWidget {
  final bool isFree;

  const TransactionPage({super.key, required this.isFree});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final TextEditingController _nopolController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<TransactionCubit>().init(widget.isFree);
  }

  @override
  void dispose() {
    _nopolController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionCubit, TransactionState>(
      listener: (context, state) {
        // [SCENARIO GAGAL]
        if (state.status == TransactionStatus.failure) {
          PbStatusSnackbar.show(
            context,
            message: state.errorMessage ?? 'Gagal memproses',
            isError: true,
          );
        }

        // [SCENARIO BERHASIL]
        if (state.status == TransactionStatus.success &&
            state.savedTransaction != null) {
          final tx = state.savedTransaction!;
          final profile = state.jukirProfile;

          if (state.isFree) {
            // ==========================================
            // 🚀 ALUR GRATIS: UI hanya memanggil Dialog
            // ==========================================
            PbStatusSnackbar.show(
              context,
              message: 'Data Parkir Gratis Tersimpan!',
            );

            PbTicketPrintDialog.showFromLocalTransaction(
              context: context,
              localTx: tx,
              profile: profile,
              kategoriKendaraan: tx.kategoriKendaraan,
              isQuickMode: tx.modePlat == 0,
              noKendaraan: tx.platNomor ?? '-',
              tarifParkir: tx.nominal,
              shift: profile['shift']?.toString() ?? '1',
              onClosed: () {
                // context.read<HomeCubit>().loadDashboardData();
                context.pop();
              },
            );
          } else {
            // ==========================================
            // 🚀 ALUR BERBAYAR: UI hanya melakukan Routing
            // ==========================================
            context
                .push(
                  AppRoutes.payment,
                  extra: PaymentPageArgs(
                    idTransaksiLokal: tx.idTransaksiLokal,
                    kategoriKendaraan: tx.kategoriKendaraan,
                    platNomor: tx.platNomor ?? '-',
                    nominal: tx.nominal,
                  ),
                )
                .then((result) {
                  if (context.mounted) {
                    // context.read<HomeCubit>().loadDashboardData();
                  }
                });
          }
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: GestureDetector(
            onDoubleTap: () {
              if (kDebugMode) ChuckerFlutter.showChuckerScreen();
            },
            child: const Text(
              'Transaksi Parkir',
              style: AppTypography.heading5,
            ),
          ),
          backgroundColor: AppColors.surface,
          elevation: 0,
          centerTitle: true,
        ),
        body: BlocBuilder<TransactionCubit, TransactionState>(
          builder: (context, state) {
            // Tampilkan loading saat Cubit sedang membuka Brankas (SQLite/Storage)
            if (state.status == TransactionStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          // 🚀 1. CARD NOPOL (Dilengkapi tombol Kamera AI)
                          CardNopolWidget(
                            controller: _nopolController,
                            onChanged: (val) => context
                                .read<TransactionCubit>()
                                .updateNopol(val),
                            onCameraTap: () async {
                              final result = await context
                                  .push<Map<String, dynamic>>(
                                    AppRoutes.capture,
                                  );

                              if (!context.mounted) return;

                              if (result != null) {
                                final plat = result['platNomor'] as String;
                                final image = result['imagePath'] as String;

                                _nopolController.text = plat;
                                context.read<TransactionCubit>().updateFromOcr(
                                  plat,
                                  image,
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 16),

                          // 🚀 2. CARD KENDARAAN (Adaptif untuk Gratis maupun Berbayar)
                          CardJenisKendaraan(
                            tarifList: state.tarifList,
                            selectedTarif: state.selectedTarif,
                            isFree: widget
                                .isFree, // Gunakan widget.isFree untuk menghindari glitch UI
                            onSelected: (tarif) => context
                                .read<TransactionCubit>()
                                .selectTarif(tarif),
                          ),

                          const SizedBox(height: 16),

                          // 🚀 3. CARD PEMBAYARAN (ANTI-GLITCH: Pakai widget.isFree!)
                          // Karena widget.isFree sudah ada sejak frame ke-1, UI tidak akan berkedip
                          if (!widget.isFree) ...[
                            CardMetodePembayaranWidget(
                              selectedValue: state.metodePembayaran,
                              onTap: (value) => context
                                  .read<TransactionCubit>()
                                  .selectPayment(value),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ],
                      ),
                    ),
                  ),
                  // 🚀 4. TOMBOL SIMPAN
                  const SizedBox(height: 8),
                  PbPrimaryButton(
                    text: widget.isFree
                        ? "Simpan Parkir Gratis"
                        : "Lanjut Pembayaran",
                    isLoading: state.status == TransactionStatus.submitting,
                    onPressed: state.isValid
                        ? () {
                            FocusScope.of(
                              context,
                            ).unfocus(); // Tutup keyboard otomatis
                            context
                                .read<TransactionCubit>()
                                .submitTransaction();
                          }
                        : null, // Disabled jika data belum lengkap (Cubit yang menentukan!)
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
