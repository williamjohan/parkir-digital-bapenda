// lib/features/payment/presentation/pages/payment_page.dart
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
import '../../../../core/storage/database_helper.dart';
import '../../../parking_transaction/data/models/local_transaction_model.dart';
import '../widgets/card_detail_parkir.dart';
import '../widgets/card_qris_widget.dart';
import '../cubit/payment_cubit.dart';
import '../cubit/payment_state.dart';

// 1. KELAS BUNGKUS ARGUMEN
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
  late PaymentCubit _cubit;
  Map<String, dynamic>? _profile;

  @override
  void initState() {
    super.initState();
    _cubit = locator<PaymentCubit>();
    _initPayment();
  }

  // 🚀 Tarik Profil dulu, baru perintahkan Cubit untuk minta QRIS
  Future<void> _initPayment() async {
    _profile = await locator<ISecureStorageManager>().getJukirProfile();
    if (mounted) {
      final nop = _profile?['nop'] ?? '';
      _cubit.initiateQrisPayment(nop, widget.args.nominal.toDouble());
    }
  }

  @override
  void dispose() {
    _cubit.close(); // 🚀 Memastikan SignalR mati saat Jukir back/keluar
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pembayaran QRIS', style: AppTypography.heading3),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
        ),
        body: BlocConsumer<PaymentCubit, PaymentState>(
          listener: (context, state) async {
            if (state is PaymentError) {
              PbStatusSnackbar.show(
                context,
                message: state.message,
                isError: true,
              );
            } else if (state is PaymentTimeout) {
              PbStatusSnackbar.show(
                context,
                message: state.message,
                isError: true,
              );
              context.pop(); // Kembali ke home karena QRIS kedaluwarsa
            }
            // 🚀 JIKA SIGNALR ATAU MANUAL CHECK BILANG LUNAS:
            else if (state is PaymentSuccess) {
              PbStatusSnackbar.show(context, message: state.message);

              // 1. Update Database Lokal menjadi PAID_ONLINE & SYNCED
              await DatabaseHelper.instance.updateTransactionStatus(
                widget.args.idTransaksiLokal,
                'PAID_ONLINE',
              );
              await DatabaseHelper.instance.markTransactionAsSynced(
                widget.args.idTransaksiLokal,
              );

              // 2. Buat Dummy Local Data untuk dilempar ke Printer Dialog
              final dummyTxForPrint = LocalTransactionModel(
                idTransaksiLokal: widget.args.idTransaksiLokal,
                nominal: widget.args.nominal,
                platNomor: widget.args.platNomor,
                kategoriKendaraan: widget.args.kategoriKendaraan,
                metodePembayaran: 'QRIS',
                waktuTransaksi: DateTime.now().toIso8601String(),
                status: 'PAID_ONLINE',
                idJukir: _profile?['idUser']?.toString() ?? '',
                namaJukir: _profile?['namaUser'] ?? '',
                // nop: _profile?['nop'] ?? '',
                modePlat:
                    widget.args.platNomor.isEmpty ||
                        widget.args.platNomor == '-'
                    ? 0
                    : 1,
                isSync: 1,
              );

              // 3. Tampilkan Layar Karcis & Print!
              if (mounted) {
                PbTicketPrintDialog.showFromLocalTransaction(
                  context: context,
                  localTx: dummyTxForPrint,
                  profile: _profile ?? {},
                  kategoriKendaraan: widget.args.kategoriKendaraan,
                  isQuickMode:
                      widget.args.platNomor.isEmpty ||
                      widget.args.platNomor == '-',
                  noKendaraan: widget.args.platNomor,
                  tarifParkir: widget.args.nominal,
                  shift: _profile?['shift']?.toString() ?? '1',
                  onClosed: () {
                    context.pop(
                      true,
                    ); // Tutup halaman payment setelah dialog karcis ditutup
                  },
                );
              }
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

                      // 🚀 TOMBOL MANUAL CHECK (Penyelamat jika SignalR delay)
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

            return const Center(
              child: Text(
                'Terjadi kesalahan. Silakan kembali.',
                style: AppTypography.bodyText,
              ),
            );
          },
        ),
      ),
    );
  }
}
