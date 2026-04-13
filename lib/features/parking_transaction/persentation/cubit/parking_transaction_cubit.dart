// lib/features/parking_transaction/presentation/cubit/parking_transaction_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../domain/usecases/save_parking_transaction_usecase.dart';
import '../../domain/usecases/update_parking_status_usecase.dart';
import 'parking_transaction_state.dart';

@injectable
class ParkingTransactionCubit extends Cubit<ParkingTransactionState> {
  final SaveParkingTransactionUseCase _saveUseCase;
  final ISecureStorageManager _secureStorage;
  final UpdateParkingStatusUseCase _updateUseCase;

  ParkingTransactionCubit(
    this._saveUseCase,
    this._updateUseCase,
    this._secureStorage,
  ) : super(ParkingTransactionInitial());

  /// Fungsi ini universal, bisa dipanggil dari CapturePage (Pakai Plat)
  /// maupun QuickParkPage (Tanpa Plat)
  Future<void> processNewTransaction({
    String? platNomor,
    required String jenisTarif, // Teks "Motor"/"Mobil"
    required int nominal, // Harga
    required String metodePembayaran, // 'qris' atau 'card' atau 'free'
    required int modePlat, // 1 jika ada plat, 0 jika tanpa plat
    String? imagePath, // Path gambar dari kamera OCR (jika ada)
  }) async {
    emit(ParkingTransactionLoading());

    final profile = await _secureStorage.getJukirProfile() ?? {};

    // 1. Eksekusi UseCase
    final result = await _saveUseCase.execute(
      platNomor: platNomor,
      jenisTarif: jenisTarif,
      nominal: nominal,
      metodePembayaran: metodePembayaran,
      modePlat: modePlat,
      rawImagePath: imagePath,
    );

    // 2. Tangani hasil
    result.fold(
      (failure) {
        if (!isClosed) {
          emit(ParkingTransactionFailure(failure.message));
        }
      },
      (transaction) {
        if (!isClosed) {
          emit(
            ParkingTransactionSaveSuccess(
              transaction: transaction,
              jukirProfile: Map<String, dynamic>.from(profile),
            ),
          );
        }
      },
    );
  }

  /// Dipanggil OLEH HALAMAN QRIS jika Jukir mengonfirmasi pembayaran
  Future<void> updateStatusToPaid(String idTransaksiLokal) async {
    final result = await _updateUseCase.execute(
      idTransaksiLokal,
      'PAID_OFFLINE',
    );

    result.fold(
      (failure) {
        if (!isClosed) emit(ParkingTransactionFailure(failure.message));
      },
      (_) {
        if (!isClosed) emit(ParkingTransactionUpdateSuccess());
      },
    );
  }
}
