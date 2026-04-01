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

  /// Fungsi ini universal, bisa dipanggil dari CapturePage (Pakai Plat)
  /// maupun QuickParkPage (Tanpa Plat)
  Future<void> processNewTransaction({
    String? platNomor,
    required String kategoriKendaraan,
    String? imagePath,
    required int modePlat,
  }) async {
    // Beri tahu UI untuk memunculkan Loading (Sambil menunggu GPS 3 detik & Kompresi Foto)
    emit(ParkingTransactionLoading());

    // 1. Eksekusi UseCase (GPS dan Kompresi Foto terjadi di dalam sini secara gaib!)
    final result = await _saveUseCase.execute(
      platNomor: platNomor,
      kategoriKendaraan: kategoriKendaraan,
      rawImagePath: imagePath,
      modePlat: modePlat,
    );

    // 2. Tangani hasil lemparan dari SQLite
    result.fold(
      (failure) {
        if (!isClosed) {
          emit(ParkingTransactionFailure(failure.message));
        }
      },
      (transaction) {
        if (!isClosed) {
          // [KUNCI ARSITEKTUR]: Lempar seluruh objek transaction ke UI!
          // UI (BlocListener) nanti yang akan mengecek:
          // if (transaction.status == 'FREE_OFFLINE') -> Tampilkan Sukses & Kembali ke Home
          // if (transaction.status == 'PENDING_PAYMENT') -> Navigasi ke halaman QRIS
          emit(ParkingTransactionSaveSuccess(transaction));
        }
      },
    );
  }

  /// Dipanggil OLEH HALAMAN QRIS jika Jukir mengonfirmasi pembayaran
  Future<void> updateStatusToPaid(String idTransaksiLokal) async {
    // Tidak perlu emit Loading agar UI QRIS tidak berkedip
    final result = await _updateUseCase.execute(
      idTransaksiLokal,
      'PAID_OFFLINE',
    );

    result.fold(
      (failure) {
        if (!isClosed) emit(ParkingTransactionFailure(failure.message));
      },
      (_) {
        // Jika sukses update ke PAID_OFFLINE, beri tahu UI untuk kembali ke Home
        if (!isClosed) emit(ParkingTransactionUpdateSuccess());
      },
    );
  }
}
