// lib/features/payment/presentation/cubit/payment_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/generate_qris_usecase.dart';
import '../../domain/usecases/confirm_payment_usecase.dart';
import 'payment_state.dart';

@injectable
class PaymentCubit extends Cubit<PaymentState> {
  final GenerateQrisUseCase _generateQrisUseCase;
  final ConfirmPaymentUseCase _confirmPaymentUseCase;

  PaymentCubit(this._generateQrisUseCase, this._confirmPaymentUseCase)
    : super(PaymentInitial());

  Future<void> generateQris({
    required String platNomor,
    required String kategoriKendaraan,
    required String fotoKendaraan,
  }) async {
    emit(PaymentLoading());

    // Simulasi jeda waktu memanggil API QRIS (Bisa dihapus jika API asli sangat cepat)
    await Future.delayed(const Duration(seconds: 1));

    final result = await _generateQrisUseCase.execute(
      platNomor: platNomor,
      kategoriKendaraan: kategoriKendaraan,
      fotoKendaraan: fotoKendaraan,
    );

    result.fold(
      (failure) {
        // [AUDITOR GUARD]: Selalu cek isClosed agar terhindar dari Ghost Error!
        if (!isClosed) emit(PaymentFailure(failure.message));
      },
      (qrisEntity) {
        if (!isClosed) {
          emit(
            PaymentQrisGenerated(
              qrisEntity.idTransaksi,
              qrisEntity.qrString,
              qrisEntity.nominal,
            ),
          );
        }
      },
    );
  }

  Future<void> confirmPayment(String idTransaksi) async {
    emit(PaymentLoading());

    final result = await _confirmPaymentUseCase.execute(idTransaksi);

    result.fold(
      (failure) {
        if (!isClosed) emit(PaymentFailure(failure.message));
      },
      (_) {
        if (!isClosed) emit(PaymentConfirmed());
      },
    );
  }
}
