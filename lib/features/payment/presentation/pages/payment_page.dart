import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/components/pb_status_snackbar.dart';
import '../../../../core/design_system/components/pb_ticket_print_dialog.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/components/pb_primary_button.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../widgets/card_detail_parkir.dart';
import '../widgets/card_qris_widget.dart';
import '../cubit/payment_cubit.dart';
import '../cubit/payment_state.dart';

class PaymentPageArgs {
  final String
  idTransaksiLokal; // Tetap dipertahankan agar tidak merusak Router
  final String kategoriKendaraan;
  final String platNomor;
  final int nominal;

  PaymentPageArgs({
    required this.idTransaksiLokal,
    required this.kategoriKendaraan,
    required this.platNomor,
    required this.nominal,
  });
}

class PaymentPage extends StatefulWidget {
  final PaymentPageArgs args;
  const PaymentPage({super.key, required this.args});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late final PaymentCubit _cubit;
  Map<String, dynamic>? _profile;

  // 🚀 Indikator untuk memastikan kita bisa pop dialog loading dengan aman
  bool _isSyncDialogOpen = false;

  @override
  void initState() {
    super.initState();
    _cubit = locator<PaymentCubit>();
    _initPayment();
  }

  Future<void> _initPayment() async {
    _profile = await locator<ISecureStorageManager>().getJukirProfile();
    if (mounted) {
      // 🚀 THE MAGIC ROUTER: Tentukan apakah ini gratis atau berbayar!
      if (widget.args.nominal == 0) {
        // Langsung lompat ke Finalisasi (Insert data & Print)
        _cubit.processFreePayment(widget.args);
      } else {
        // Lanjut tampilkan QRIS
        _cubit.initiateQrisPayment(widget.args);
      }
    }
  }

  /// Helper untuk mematikan dialog loading jika sedang menyala
  void _dismissSyncDialog() {
    if (_isSyncDialogOpen && mounted) {
      Navigator.of(context, rootNavigator: true).pop();
      _isSyncDialogOpen = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _cubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pembayaran', style: AppTypography.heading3),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
        ),
        body: BlocConsumer<PaymentCubit, PaymentState>(
          buildWhen: (previous, current) {
            if (current is PaymentError && previous is PaymentQrisReady) {
              return false; // Perisai QRIS: Cegah layar blank jika ada false alarm
            }
            return true;
          },
          listener: (context, state) async {
            // ----------------------------------------------------
            // 1. FASE MENYIMPAN DATA (SYNCING)
            // ----------------------------------------------------
            if (state is PaymentSyncing) {
              _isSyncDialogOpen = true;
              showDialog(
                context: context,
                barrierDismissible: false, // Tidak bisa di-klik di luar
                builder: (context) => PopScope(
                  canPop: false, // Back button Android dimatikan
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
              ).then((_) => _isSyncDialogOpen = false);
            }
            // ----------------------------------------------------
            // 2. FASE ERROR
            // ----------------------------------------------------
            else if (state is PaymentError) {
              _dismissSyncDialog(); // Tutup loading jika ada
              PbStatusSnackbar.show(
                context,
                message: state.message,
                isError: true,
              );
            }
            // ----------------------------------------------------
            // 3. FASE TIMEOUT
            // ----------------------------------------------------
            else if (state is PaymentTimeout) {
              _dismissSyncDialog();
              PbStatusSnackbar.show(
                context,
                message: state.message,
                isError: true,
              );
              await Future.delayed(const Duration(seconds: 2));
              if (context.mounted) context.pop();
            }
            // ----------------------------------------------------
            // 4. FASE SUKSES & AUTO-PRINT 🚀
            // ----------------------------------------------------
            else if (state is PaymentSuccess) {
              _dismissSyncDialog(); // Tutup loading memproses

              // Munculkan notifikasi hijau
              PbStatusSnackbar.show(context, message: state.message);

              // 🚀 AMBIL DATA ASLI DARI CUBIT (Sudah tersimpan di DB & API)
              final savedTx = state.transaction;

              if (mounted) {
                // Munculkan dialog print otomatis!
                PbTicketPrintDialog.showFromLocalTransaction(
                  context: context,
                  localTx: savedTx,
                  profile: _profile ?? {},
                  kategoriKendaraan: savedTx.kategoriKendaraan,
                  isQuickMode: savedTx.modePlat == 0,
                  noKendaraan: savedTx.platNomor ?? '-',
                  tarifParkir: savedTx.nominal,
                  shift: _profile?['shift']?.toString() ?? '1',
                  onClosed: () {
                    // Jika dialog print ditutup, tendang kembali ke Transaction Page
                    // Bawa parameter 'true' agar halaman depan tahu transaksi berhasil direfresh
                    context.pop(true);
                  },
                );
              }
            }
          },
          builder: (context, state) {
            // Jika state Syncing, pertahankan UI terakhir (QRIS) agar layar tidak putih
            if (state is PaymentLoading ||
                state is PaymentInitial ||
                state is PaymentSyncing) {
              // Jika ini transaksi gratis (nominal 0), tidak perlu tampilkan "Menghasilkan QRIS"
              // Biarkan layar putih kosong sedikit sebelum popup loading muncul
              if (widget.args.nominal == 0) return const SizedBox.shrink();

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

            if (state is PaymentQrisReady) {
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CardQrisWidget(
                        url: state.qris.qrisValue,
                        objekPajak:
                            _profile?['namaObjekPajak'] ?? 'Objek Pajak',
                        idTransaksi:
                            widget.args.idTransaksiLokal, // sekadar display ID
                      ),
                      const SizedBox(height: 16),
                      CardDetailParkirWidget(
                        platNomor: widget.args.platNomor,
                        kategoriKendaraan: widget.args.kategoriKendaraan,
                        nominal: widget.args.nominal,
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        "Diterima di semua e-wallet dan bank",
                        style: AppTypography.caption,
                      ),
                      const SizedBox(height: 32),
                      PbPrimaryButton(
                        text: 'Cek Status Pembayaran',
                        onPressed: () {
                          _cubit.checkStatusManual(state.qris.kodeQris);
                        },
                      ),
                    ],
                  ),
                ),
              );
            }

            // Fallback (Error State yang tidak tertahan perisai)
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Terjadi kesalahan.',
                    style: AppTypography.bodyText,
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('Kembali'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
