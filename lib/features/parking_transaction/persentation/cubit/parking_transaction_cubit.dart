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

  /// Fungsi ini akan dipanggil dari CapturePage saat Jukir klik "Lanjut Bayar"
  Future<void> processNewTransaction({
    String? platNomor, // Opsional
    required String kategoriKendaraan,
    String? imagePath, // Opsional
    required bool isFree,
    required int
    modePlat, // [WAJIB ADA]: UI yang memanggil ini harus memberitahu mode apa yang dipakai
  }) async {
    emit(ParkingTransactionLoading()); // Atau state loading Anda

    final result = await _saveUseCase.execute(
      platNomor: platNomor,
      kategoriKendaraan: kategoriKendaraan,
      rawImagePath: imagePath,
      isFree: isFree,
      modePlat: modePlat,
    );

    result.fold(
      (failure) {
        if (!isClosed) emit(ParkingTransactionFailure(failure.message));
      },
      (transaction) {
        // SUKSES! UUID SQLite didapatkan, lempar ke UI untuk pindah layar!
        if (!isClosed)
          emit(ParkingTransactionSaveSuccess(transaction.idTransaksiLokal));
      },
    );
  }

  Future<void> updateStatusToPaid(String idTransaksiLokal) async {
    // Kita tidak perlu emit Loading agar UI Capture tidak berkedip
    await _updateUseCase.execute(idTransaksiLokal, 'PAID_OFFLINE');
  }
}
