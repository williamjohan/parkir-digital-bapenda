import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:parkir_digital_bapenda/shared/loading/loading_overlay.dart';
import '../../../../core/design_system/components/pb_status_snackbar.dart';
import '../../../../core/design_system/components/pb_ticket_print_dialog.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../../../features/printer/presentation/cubit/printer_cubit.dart';
import '../../../parking_transaction/data/models/local_transaction_model.dart'; // Import extension
import '../cubit/payment_cubit.dart';
import '../cubit/payment_state.dart';
import '../widgets/payment_qris_view.dart';
import 'payment_dialog_helpers.dart';

class PaymentPageArgs {
  final String idTransaksiLokal;
  final String kategoriKendaraan;
  final String platNomor;
  final int nominal;
  final String latitude;
  final String longitude;

  PaymentPageArgs({
    required this.idTransaksiLokal,
    required this.kategoriKendaraan,
    required this.platNomor,
    required this.nominal,
    required this.latitude,
    required this.longitude,
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
  bool _isCheckingStatus = false;

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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _cubit,
      child: SafeArea(
        bottom: true,
        top: false,
        child: LoadingOverlay(
          isLoading: _isCheckingStatus,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Pembayaran', style: AppTypography.heading3),
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: const IconThemeData(color: AppColors.textPrimary),
            ),
            body: BlocConsumer<PaymentCubit, PaymentState>(
              buildWhen: (previous, current) {
                if (current is PaymentCheckLoading ||
                    current is PaymentPendingInfo) {
                  return false;
                }
                return !(current is PaymentError &&
                    previous is PaymentQrisReady);
              },
              listener: (context, state) async {
                if (state is! PaymentCheckLoading && _isCheckingStatus) {
                  setState(() => _isCheckingStatus = false);
                }

                if (state is PaymentCheckLoading) {
                  // Nyalakan Overlay
                  setState(() => _isCheckingStatus = true);
                } else if (state is PaymentPendingInfo) {
                  // Munculkan Snackbar Biru/Kuning
                  PbStatusSnackbar.show(
                    context,
                    message: state.message,
                    isInfo: true,
                  );
                } else if (state is PaymentSyncing) {
                  _isSyncDialogOpen = true;
                  PaymentDialogHelpers.showSyncingDialog(context);
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

                  if (!context.mounted) return;
                  context.pop();
                } else if (state is PaymentSuccess) {
                  _dismissSyncDialog();
                  final savedTx = state.transaction;
                  final secureStorage = locator<ISecureStorageManager>();

                  final savedMac = await secureStorage.getPrinterMacAddress();

                  if (!context.mounted) return;

                  final bool isPrinterReady =
                      savedMac != null && savedMac.isNotEmpty;
                  final String deviceId =
                      _profile?['idDevice']?.toString() ?? 'UNKNOWN_DEVICE';

                  if (isPrinterReady) {
                    final mappedTransaction = savedTx.toHistoryItem(
                      _profile ?? {},
                    );
                    locator<PrinterCubit>().autoConnectAndPrint(
                      mappedTransaction,
                      deviceId,
                      _profile ?? {},
                    );
                  }

                  await PaymentDialogHelpers.showSuccessLottie(
                    context,
                    widget.args.nominal == 0,
                  );

                  if (!context.mounted) return;

                  PbTicketPrintDialog.showFromLocalTransaction(
                    context: context,
                    localTx: savedTx,
                    profile: _profile ?? {},
                    kategoriKendaraan: savedTx.kategoriKendaraan,
                    isQuickMode: savedTx.modePlat == 0,
                    noKendaraan: savedTx.platNomor,
                    tarifParkir: savedTx.nominal,
                    shift: _profile?['shift']?.toString() ?? '1',
                    isPrinterReady: isPrinterReady,
                    onClosed: () {
                      // 🚀 FIX 4: Callback ini bisa dieksekusi kapan saja di masa depan
                      if (context.mounted) context.pop(true);
                    },
                  );
                }
              },
              builder: (context, state) {
                // if (state is PaymentLoading ||
                //     state is PaymentInitial ||
                //     state is PaymentSyncing) {
                //   if (widget.args.nominal == 0) return const SizedBox.shrink();
                //   return const Center(
                //     child: CircularProgressIndicator(color: AppColors.primary),
                //   );
                // }

                if (state is PaymentQrisReady) {
                  // 🚀 Memanggil Stateless Widget yang Bersih
                  return PaymentQrisView(
                    durasi: state.qris.expTimeMenit,
                    qrisBytes: state.qrisBytes,
                    kodeQris: state.qris.kodeQris,
                    objekPajak: _profile?['namaObjekPajak'] ?? 'Objek Pajak',
                    idTransaksi: widget.args.idTransaksiLokal,
                    platNomor: widget.args.platNomor,
                    kategoriKendaraan: widget.args.kategoriKendaraan,
                    nominal: widget.args.nominal,
                    onCheckStatus: () =>
                        _cubit.checkStatusManual(state.qris.kodeQris),
                  );
                }

                // return const Center(
                //   child: Text(
                //     'Terjadi kesalahan.',
                //     style: AppTypography.bodyText,
                //   ),
                // );
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
