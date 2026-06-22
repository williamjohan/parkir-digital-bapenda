import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:parkir_digital_bapenda/features/transaction/presentation/widgets/card_data_jukir.dart';
import 'package:parkir_digital_bapenda/features/transaction/presentation/widgets/tarif_empty_widget.dart';
import '../../../../../core/design_system/components/pb_primary_button.dart';
import '../../../../../core/design_system/tokens/app_colors.dart';
import '../../../../../core/design_system/tokens/app_typography.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../../payment/presentation/pages/payment_page.dart';
import '../cubit/transaction_cubit.dart';
import '../cubit/transaction_state.dart';
import '../widgets/card_jenis_kendaraan.dart';

class TransactionPage extends StatefulWidget {
  final Map<String, dynamic>? itemOP;
  final bool isFree;

  const TransactionPage({super.key, required this.isFree, this.itemOP});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  late Future<Map<String, dynamic>?> _profileFuture;

  @override
  void initState() {
    super.initState();
    print('itemOP = ${widget.itemOP}');

    if (widget.itemOP != null) {
      context.read<TransactionCubit>().getDataJukir(widget.itemOP!['nop']);
    }

    context.read<TransactionCubit>().init(widget.isFree);

    _profileFuture = GetIt.I<ISecureStorageManager>().getJukirProfile();
  }

  void _navigateToPayment(TransactionState state) {
    final selected = state.selectedTarif!;

    final args = PaymentPageArgs(
      jenisKendaraanId: selected.id,
      kategoriKendaraan: selected.jenisTarif,
    );

    context.push(AppRoutes.payment, extra: args).then((result) {
      if (!context.mounted) return;
      context.read<TransactionCubit>().resetForm();

      if (result == true) {
        context.pop(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionCubit, TransactionState>(
      listener: (context, state) {
        // 🚀 Satu-satunya listener: validasi lolos → navigasi ke PaymentPage.
        // Tidak ada cek lokasi, tidak ada insert transaksi.
        if (state.status == TransactionStatus.success) {
          _navigateToPayment(state);
        }
      },
      builder: (context, state) {
        final bool isLoading = state.status == TransactionStatus.loading;

        return SafeArea(
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
            body: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: state.isTarifEmpty
                        ? const TarifEmptyWidget()
                        : Column(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 8),
                                      FutureBuilder<Map<String, dynamic>?>(
                                        future: _profileFuture,
                                        builder: (context, snapshot) {
                                          final profile = snapshot.data;

                                          return CardJenisKendaraan(
                                            op: widget.itemOP != null
                                                ? widget.itemOP!['nama_op']
                                                : profile?['namaObjekPajak'] ??
                                                      '',
                                            alamat: widget.itemOP != null
                                                ? widget.itemOP!['alamat_op']
                                                : profile?['alamat'] ?? '',
                                            tarifList: state.tarifList,
                                            selectedTarif: state.selectedTarif,
                                            isFree: widget.isFree,
                                            onSelected: (tarif) => context
                                                .read<TransactionCubit>()
                                                .selectTarif(tarif),
                                          );
                                        },
                                      ),

                                      const SizedBox(height: 16),
                                      if (widget.itemOP != null)
                                        CardDataJukir(
                                          dataJukirList: state.dataJukirList,
                                        ),
                                    ],
                                  ),
                                ),
                              ),

                              // 🚀 Tombol lanjut — aktif hanya jika kendaraan dipilih
                              const SizedBox(height: 8),
                              PbPrimaryButton(
                                text: widget.isFree
                                    ? 'Simpan Parkir Gratis'
                                    : 'Lanjut Pembayaran',
                                onPressed: state.selectedTarif != null
                                    ? () => context
                                          .read<TransactionCubit>()
                                          .proceedToPayment()
                                    : null,
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                  ),
          ),
        );
      },
    );
  }
}
