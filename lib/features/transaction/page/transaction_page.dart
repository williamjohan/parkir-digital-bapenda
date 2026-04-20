import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:parkir_digital_bapenda/features/transaction/widgets/tarif_empty_widget.dart';
import '../../../../core/design_system/components/pb_primary_button.dart';
import '../../../../core/design_system/components/pb_status_snackbar.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../core/design_system/components/pb_show_dialog.dart';
import '../../../shared/loading/loading_overlay.dart';
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
  bool isTarifEmpty = false;

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

  void _showLocationDisabledDialog(BuildContext context) {
    PbShowDialog.show(
      context,
      icon: Icons.location_off_outlined,
      iconColor: AppColors.error,
      title: 'Lokasi Tidak Aktif',
      description: 'Aktifkan layanan GPS untuk menyimpan transaksi parkir.',
      showBtnKeluar: true,
      buttonText: 'Aktifkan',
      onConfirm: () => Geolocator.openLocationSettings(),
    );
  }

  void _showPermissionDeniedDialog(BuildContext context, String message) {
    PbShowDialog.show(
      context,
      icon: Icons.security_outlined,
      iconColor: AppColors.error,
      title: 'Izin Lokasi Ditolak',
      description: message, // Pesan ini dikirim dari Location Service
      showBtnKeluar: true,
      buttonText: 'Buka Pengaturan',
      // openAppSettings() akan membuka info aplikasi agar user bisa mencentang izin lokasi
      onConfirm: () => Geolocator.openAppSettings(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionCubit, TransactionState>(
      listener: (context, state) {
        // [SCENARIO GAGAL VALIDASI/SYSTEM]
        if (state.status == TransactionStatus.failure) {
          PbStatusSnackbar.show(
            context,
            message: state.errorMessage ?? 'Gagal memproses',
            isError: true,
          );
        }

        if (state.status == TransactionStatus.locationDisabled) {
          _showLocationDisabledDialog(context);
        } else if (state.status == TransactionStatus.locationPermissionDenied) {
          _showPermissionDeniedDialog(
            context,
            state.errorMessage ?? 'Izin lokasi dibutuhkan.',
          );
        }

        if (state.isTarifEmpty && state.isFree == false) {
          setState(() {
            isTarifEmpty = true;
          });
        }

        // 🚀 [SCENARIO BERHASIL VALIDASI FORM]
        if (state.status == TransactionStatus.success) {
          // 1. Rakit Data
          final finalJenisTarif =
              state.selectedTarif?.jenisTarif ?? 'Objek Pajak Gratis';
          final finalNominal = state.selectedTarif?.tarif.toInt() ?? 0;
          final finalPlat = state.nopol.trim();

          // ID Sementara, karena ID asli akan dibuat oleh SQLite nanti saat Lunas
          final dummyId = "TRX-${DateTime.now().millisecondsSinceEpoch}";

          final args = PaymentPageArgs(
            idTransaksiLokal: dummyId,
            kategoriKendaraan: finalJenisTarif,
            platNomor: finalPlat,
            nominal: finalNominal,
            latitude: state.latitude ?? '0',
            longitude: state.longitude ?? '0',
          );

          // 2. Lempar ke PaymentPage (Untuk Semua Transaksi: Bayar & Gratis)
          // PaymentPage akan mem-bypass QRIS secara otomatis jika nominal == 0
          context.push(AppRoutes.payment, extra: args).then((result) {
            // 3. Jika kembali dengan status sukses (karcis tercetak)
            if (context.mounted && result == true) {
              // Reset UI Form
              context.read<TransactionCubit>().resetForm();
              _nopolController.clear();

              // Tutup halaman Transaksi dan kembalikan sinyal sukses ke Home
              context.pop(true);
            }
          });
        }
      },
      builder: (context, state) {
        final bool isOverlayActive =
            state.status == TransactionStatus.loading ||
            state.status == TransactionStatus.submitting;

        return LoadingOverlay(
          isLoading: isOverlayActive,
          child: SafeArea(
            bottom: true,
            top: false,
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
              body: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: isTarifEmpty
                    ? TarifEmptyWidget()
                    : Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  // 🚀 CARD NOPOL
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
                                        final plat =
                                            result['platNomor'] as String;
                                        final image =
                                            result['imagePath'] as String;

                                        _nopolController.text = plat;
                                        context
                                            .read<TransactionCubit>()
                                            .updateFromOcr(plat, image);
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 16),

                                  // 🚀 CARD KENDARAAN
                                  CardJenisKendaraan(
                                    tarifList: state.tarifList,
                                    selectedTarif: state.selectedTarif,
                                    isFree: widget.isFree,
                                    onSelected: (tarif) => context
                                        .read<TransactionCubit>()
                                        .selectTarif(tarif),
                                  ),

                                  const SizedBox(height: 16),

                                  // 🚀 CARD PEMBAYARAN
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

                          // 🚀 TOMBOL SIMPAN
                          const SizedBox(height: 8),
                          PbPrimaryButton(
                            text: widget.isFree
                                ? "Simpan Parkir Gratis"
                                : "Lanjut Pembayaran",
                            onPressed: state.isValid
                                ? () {
                                    FocusScope.of(
                                      context,
                                    ).unfocus(); // Tutup keyboard
                                    context
                                        .read<TransactionCubit>()
                                        .submitTransaction();
                                  }
                                : null,
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
