import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/usecases/confirm_payment_usecase.dart';
import '../../domain/usecases/generate_qris_usecase.dart';
import 'payment_state.dart';

@injectable
class PaymentCubit extends Cubit<PaymentState> {
  final GenerateQrisUseCase _generateQrisUseCase;
  final ConfirmPaymentUseCase _confirmPaymentUseCase;
  final _secureStorage = locator<ISecureStorageManager>();

  Map<String, dynamic>? _cachedProfile;

  PaymentCubit(this._generateQrisUseCase, this._confirmPaymentUseCase)
    : super(PaymentInitial());

  // PaymentCubit(this._generateQrisUseCase, this._confirmPaymentUseCase)
  //   : super(PaymentInitial()) {
  //   getProfile();
  // }

  Future<void> generateQris({
    required String idTransaksiLokal,
    required int nominal,
  }) async {
    emit(PaymentInitial()); // 🔥 reset state lama
    emit(PaymentLoading());

    _cachedProfile ??= await _secureStorage.getJukirProfile();

    if (_cachedProfile == null) {
      if (!isClosed) {
        emit(const PaymentFailure('Profile tidak ditemukan'));
      }
      return;
    }

    final result = await _generateQrisUseCase.execute(
      idTransaksiLokal: idTransaksiLokal,
      nop: _cachedProfile!['nop'],
      nominal: nominal,
    );

    result.fold(
      (failure) {
        if (!isClosed) emit(PaymentFailure(failure.message));
      },
      (qrisEntity) {
        if (!isClosed) {
          emit(
            PaymentQrisGenerated(
              idTransaksi: qrisEntity.idTransaksi,
              qrBase64: qrisEntity.qrBase64,
              qrisBase64: qrisEntity.qrisBase64,
              nominal: qrisEntity.nominal,
              expTimeMenit: qrisEntity.expTimeMenit,
              profile: _cachedProfile,
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
