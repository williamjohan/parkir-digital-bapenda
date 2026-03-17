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
    required String idTransaksiLokal, // Menerima lemparan ID dari fitur parkir
    required String kategoriKendaraan,
  }) async {
    emit(PaymentLoading());

    // [PERBAIKAN]: Sesuaikan pemanggilan execute dengan kontrak UseCase yang baru!
    final result = await _generateQrisUseCase.execute(
      idTransaksiLokal: idTransaksiLokal,
      kategoriKendaraan: kategoriKendaraan,
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
