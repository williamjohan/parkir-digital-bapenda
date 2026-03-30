// lib/features/parking_transaction/presentation/cubit/parking_transaction_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/save_parking_transaction_usecase.dart';
import '../../domain/usecases/update_parking_status_usecase.dart';
import 'parking_transaction_state.dart';

@injectable
class ParkingTransactionCubit extends Cubit<ParkingTransactionState> {
  final SaveParkingTransactionUseCase _saveUseCase;
  final UpdateParkingStatusUseCase _updateUseCase;

  ParkingTransactionCubit(this._saveUseCase, this._updateUseCase)
    : super(ParkingTransactionInitial());

  /// Fungsi ini universal, bisa dipanggil dari CapturePage maupun QuickParkPage
  Future<void> processNewTransaction({
    String? platNomor, // Opsional
    required String kategoriKendaraan,
    String? imagePath, // Opsional
    required int modePlat, // [WAJIB ADA]: 0 = Tanpa Plat, 1 = Pakai Plat
  }) async {
    emit(ParkingTransactionLoading());

    // 1. Eksekusi UseCase tanpa parameter isFree
    final result = await _saveUseCase.execute(
      platNomor: platNomor,
      kategoriKendaraan: kategoriKendaraan,
      rawImagePath: imagePath,
      modePlat: modePlat,
    );

    // 2. Tangani hasil dari mesin SQLite
    result.fold(
      (failure) {
        if (!isClosed) emit(ParkingTransactionFailure(failure.message));
      },
      (transaction) {
        // [PERBAIKAN ARSITEKTUR]: Lempar seluruh objek transaction, bukan cuma ID-nya!
        if (!isClosed) {
          emit(ParkingTransactionSaveSuccess(transaction));
        }
      },
    );
  }

  Future<void> updateStatusToPaid(String idTransaksiLokal) async {
    // Kita tidak perlu emit Loading agar UI Capture tidak berkedip
    await _updateUseCase.execute(idTransaksiLokal, 'PAID_OFFLINE');
  }
}
