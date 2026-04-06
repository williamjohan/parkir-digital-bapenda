// lib/features/payment/presentation/cubit/payment_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../domain/usecases/generate_qris_usecase.dart';
import '../../domain/usecases/confirm_payment_usecase.dart';
import 'payment_state.dart';

@injectable
class PaymentCubit extends Cubit<PaymentState> {
  final GenerateQrisUseCase _generateQrisUseCase;
  final ConfirmPaymentUseCase _confirmPaymentUseCase;
  final _secureStorage = locator<ISecureStorageManager>();

  Map<String, dynamic>? _cachedProfile;

  PaymentCubit(this._generateQrisUseCase, this._confirmPaymentUseCase)
    : super(PaymentInitial());

  Future<void> generateQris({
    required String idTransaksiLokal, // Menerima lemparan ID dari fitur parkir
    required String kategoriKendaraan,
  }) async {
    emit(PaymentLoading());

    // Load profile internal tanpa emit
    _cachedProfile ??= await _secureStorage.getJukirProfile();

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
              _cachedProfile,
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
