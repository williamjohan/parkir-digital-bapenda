import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
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
  final bool isDemoMode;

  const TransactionPage({
    super.key,
    required this.isFree,
    this.itemOP,
    this.isDemoMode = false,
  });

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  late Future<Map<String, dynamic>?> _profileFuture;
  bool get _requiresJukir => widget.itemOP != null;

  @override
  void initState() {
    super.initState();
    context.read<TransactionCubit>().init(
      isFree: widget.isFree,
      isDemoMode: widget.isDemoMode,
    );

    _profileFuture = GetIt.I<ISecureStorageManager>().getJukirProfile();
  }

  Future<void> _navigateToPayment(TransactionState state) async {
    final selected = state.selectedTarif!;
    final args = PaymentPageArgs(
      jenisKendaraanId: selected.id,
      kategoriKendaraan: selected.jenisTarif,
      isDemoMode: widget.isDemoMode,
    );
    final result = await context.push(AppRoutes.payment, extra: args);
    if (!mounted) return;
    context.read<TransactionCubit>().resetForm();
    if (result == true) {
      context.pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionCubit, TransactionState>(
      listener: (context, state) {
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
              title: Text(
                'Transaksi Parkir',
                style: AppTypography.heading5.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
              backgroundColor: AppColors.surface,
              scrolledUnderElevation: 0,
              shape: Border(
                bottom: BorderSide(color: AppColors.primary, width: 1.0),
              ),
              elevation: 0,
              foregroundColor: Colors.black,
              iconTheme: IconThemeData(color: AppColors.primary),
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
                              _buildDemoModeBanner(),
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
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              PbPrimaryButton(
                                text: widget.isFree
                                    ? 'Simpan Parkir Gratis'
                                    : 'Lanjut Pembayaran',
                                onPressed: state.isValid(_requiresJukir)
                                    ? () => context
                                          .read<TransactionCubit>()
                                          .proceedToPayment(_requiresJukir)
                                    : null,
                              ),
                            ],
                          ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildDemoModeBanner() {
    if (!widget.isDemoMode) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: AppColors.warning, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Mode Demo — transaksi ini hanya simulasi.',
              style: AppTypography.bodySmall.copyWith(color: AppColors.warning),
            ),
          ),
        ],
      ),
    );
  }
}
