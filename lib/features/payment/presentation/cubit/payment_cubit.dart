import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../transaction/domain/usecases/get_local_qris_usecase.dart';
import '../../domain/constant/qris_contants.dart';
import 'payment_state.dart';

@injectable
class PaymentCubit extends Cubit<PaymentState> {
  final GetLocalQrisUseCase _getLocalQrisUseCase;

  PaymentCubit(this._getLocalQrisUseCase) : super(PaymentInitial());
  Future<void> loadQris({
    required int jenisKendaraanId,
    required bool isDemoMode,
  }) async {
    if (isClosed) return;
    emit(PaymentLocalQrisLoading());
    if (isDemoMode) {
      final qrisString = QrisDemoConstants.getQrisByVehicleType(
        jenisKendaraanId,
      );
      if (!isClosed) emit(PaymentDemoQrisReady(qrisString));
      return;
    }
    final result = await _getLocalQrisUseCase.execute();
    if (isClosed) return;

    result.fold(
      (_) =>
          emit(const PaymentLocalQrisError('Data QRIS lokal belum tersedia.')),
      (qrisMap) {
        if (isClosed) return;

        final imagePath = qrisMap[jenisKendaraanId.toString()];

        if (imagePath == null || imagePath.isEmpty) {
          emit(
            const PaymentLocalQrisError(
              'QRIS untuk jenis kendaraan ini tidak ditemukan.',
            ),
          );
          return;
        }

        if (!File(imagePath).existsSync()) {
          emit(
            const PaymentLocalQrisError(
              'File QRIS tidak ditemukan di perangkat.',
            ),
          );
          return;
        }

        emit(PaymentLocalQrisReady(imagePath));
      },
    );
  }
}
