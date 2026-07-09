import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
// 🚀 Pastikan import usecase dan entity benar
import 'package:parkir_digital_bapenda/features/transaction/domain/usecases/qris_usecase.dart';
import '../../domain/constant/qris_contants.dart';
import 'payment_state.dart';

@injectable
class PaymentCubit extends Cubit<PaymentState> {
  final QrisUsecase _qrisUsecase;

  // 🚀 Menggunakan const constructor dari Freezed
  PaymentCubit(this._qrisUsecase) : super(const PaymentState.initial());

  Future<void> loadQris({
    required int jenisKendaraanId,
    required bool isDemoMode,
  }) async {
    if (isClosed) return;

    emit(const PaymentState.loading());

    if (isDemoMode) {
      final qrisString = QrisDemoConstants.getQrisByVehicleType(
        jenisKendaraanId,
      );
      // 🚀 Emit state demo Freezed
      if (!isClosed) {
        emit(PaymentState.demoQrisReady(rawQrisString: qrisString));
      }
      return;
    }

    final result = await _qrisUsecase.getLocalQris();
    if (isClosed) return;

    result.fold(
      (_) => emit(
        const PaymentState.error(message: 'Data QRIS lokal belum tersedia.'),
      ),
      (qrisMap) {
        if (isClosed) return;

        // Extract QrisLocalEntity dari Map
        final qrisEntity = qrisMap[jenisKendaraanId.toString()];

        if (qrisEntity == null || qrisEntity.path.isEmpty) {
          emit(
            const PaymentState.error(
              message: 'QRIS untuk jenis kendaraan ini tidak ditemukan.',
            ),
          );
          return;
        }

        if (!File(qrisEntity.path).existsSync()) {
          emit(
            const PaymentState.error(
              message: 'File QRIS tidak ditemukan di perangkat.',
            ),
          );
          return;
        }

        emit(
          PaymentState.localQrisReady(
            qrisImagePath: qrisEntity.path,
            kodeQris: qrisEntity.kodeQris,
          ),
        );
      },
    );
  }
}
