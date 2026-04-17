import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
// import 'package:lottie/lottie.dart';
import '../../../../core/design_system/components/pb_status_snackbar.dart';
import '../../../../core/design_system/components/pb_ticket_print_dialog.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/components/pb_primary_button.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../../../features/printer/presentation/cubit/printer_cubit.dart';
import '../../../../features/transaction_history/data/models/history_item_model.dart';
import '../widgets/card_detail_parkir.dart';
import '../widgets/card_qris_widget.dart';
import '../cubit/payment_cubit.dart';
import '../cubit/payment_state.dart';

class PaymentPageArgs {
  final String idTransaksiLokal;
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
      if (widget.args.nominal == 0) {
        _cubit.processFreePayment(widget.args);
      } else {
        _cubit.initiateQrisPayment(widget.args);
      }
    }
  }

  void _dismissSyncDialog() {
    if (_isSyncDialogOpen && mounted) {
      Navigator.of(context, rootNavigator: true).pop();
      _isSyncDialogOpen = false;
    }
  }

  /// 🚀 HELPER: Tampilkan Lottie Transisi Sukses
  Future<void> _showSuccessLottie() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Nanti ganti path asset ini dengan file JSON Lottie Anda
              // Lottie.asset('assets/lottie/success_payment.json', width: 200, height: 200, repeat: false),

              // Placeholder sementara sebelum Anda punya file Lottie:
              const Icon(
                Icons.check_circle,
                color: Colors.greenAccent,
                size: 120,
              ),
              const SizedBox(height: 16),
              const Text(
                "Pembayaran Berhasil!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );

    // Beri jeda 2 detik agar animasi dinikmati pengguna
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.of(context, rootNavigator: true).pop(); // Tutup Lottie
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
              return false;
            }
            return true;
          },
          listener: (context, state) async {
            if (state is PaymentSyncing) {
              _isSyncDialogOpen = true;
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => PopScope(
                  canPop: false,
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
            } else if (state is PaymentError) {
              _dismissSyncDialog();
              PbStatusSnackbar.show(
                context,
                message: state.message,
                isError: true,
              );
            } else if (state is PaymentTimeout) {
              _dismissSyncDialog();
              PbStatusSnackbar.show(
                context,
                message: state.message,
                isError: true,
              );
              await Future.delayed(const Duration(seconds: 2));
              if (context.mounted) context.pop();
            } else if (state is PaymentSuccess) {
              _dismissSyncDialog();

              final savedTx = state.transaction;
              final secureStorage = locator<ISecureStorageManager>();

              // 🚀 1. CEK STATUS KESIAPAN PRINTER
              final savedMac = await secureStorage.getPrinterMacAddress();
              final bool isPrinterReady =
                  savedMac != null && savedMac.isNotEmpty;
              final String deviceId =
                  _profile?['idDevice']?.toString() ?? 'UNKNOWN_DEVICE';

              // 🚀 2. AUTO-PRINT (SILENT BACKGROUND) JIKA PRINTER READY
              if (isPrinterReady) {
                // Adapter Manual: Ubah LocalTransactionModel ke HistoryItemModel
                final mappedTransaction = HistoryItemModel(
                  id: 0,
                  orderId: savedTx.idTransaksiLokal,
                  jenisTarif: savedTx.kategoriKendaraan,
                  sof: savedTx.nominal == 0 ? 'FREE' : 'CASH', // Sesuaikan
                  platNumber: savedTx.platNomor ?? '-',
                  tglTrx: savedTx.waktuTransaksi,
                  kredit: savedTx.nominal,
                  namaPetugas: _profile?['namaUser'] ?? 'Petugas',
                  modePlat: savedTx.modePlat,
                  shift: _profile?['shift']?.toString() ?? '1',
                );

                // Tembak print siluman tanpa menunggu await secara penuh (Fire and Forget ringan)
                // agar animasi Lottie bisa langsung jalan tanpa ngelag
                locator<PrinterCubit>().autoConnectAndPrint(
                  mappedTransaction,
                  deviceId,
                  _profile ?? {},
                );
              }

              // 🚀 3. TAMPILKAN ANIMASI LOTTIE (JEDA 2 DETIK)
              if (mounted) await _showSuccessLottie();

              // 🚀 4. MUNCULKAN DIALOG TIKET FINAL
              if (mounted) {
                // Nanti di dalam PbTicketPrintDialog, kita akan butuh mengirim parameter `isPrinterReady`
                // agar dialog tahu apakah harus menampilkan tombol biru atau tombol merah.
                PbTicketPrintDialog.showFromLocalTransaction(
                  context: context,
                  localTx: savedTx,
                  profile: _profile ?? {},
                  kategoriKendaraan: savedTx.kategoriKendaraan,
                  isQuickMode: savedTx.modePlat == 0,
                  noKendaraan: savedTx.platNomor ?? '-',
                  tarifParkir: savedTx.nominal,
                  shift: _profile?['shift']?.toString() ?? '1',
                  isPrinterReady:
                      isPrinterReady, // ⚠️ PARAMETER BARU UNTUK DIALOG
                  onClosed: () {
                    context.pop(true);
                  },
                );
              }
            }
          },
          builder: (context, state) {
            if (state is PaymentLoading ||
                state is PaymentInitial ||
                state is PaymentSyncing) {
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
                        idTransaksi: widget.args.idTransaksiLokal,
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
