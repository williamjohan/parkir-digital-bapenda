// lib/features/parking_transaction/domain/repositories/i_parking_transaction_repository.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../data/models/local_transaction_model.dart';

abstract class IParkingTransactionRepository {
  /// Menyimpan transaksi baru.
  /// Repository HANYA meminta data dari UI, urusan ID Jukir akan dicarikan sendiri oleh Repository ke SecureStorage.
  Future<Either<Failure, LocalTransactionModel>> saveNewTransaction({
    String? platNomor, // [PERBAIKAN]: Menjadi opsional (bisa null)
    required String kategoriKendaraan,
    String? rawImagePath, // [PERBAIKAN]: Menjadi opsional (bisa null)
    required bool isFree,
    required int modePlat, // [TAMBAHAN BARU]: 0 = Tanpa Plat, 1 = Pakai Plat
  });

  /// Mengubah status transaksi di SQLite
  Future<Either<Failure, Unit>> updateTransactionStatus({
    required String idTransaksiLokal,
    required String newStatus,
  });

  /// Mengambil daftar transaksi yang belum tersinkronisasi
  Future<Either<Failure, List<LocalTransactionModel>>>
  getUnsyncedTransactions();
}
