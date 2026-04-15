// lib/features/parking_transaction/domain/repositories/i_parking_transaction_repository.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../data/models/local_transaction_model.dart';

abstract class IParkingTransactionRepository {
  Future<Either<Failure, LocalTransactionModel>> saveNewTransaction({
    String? platNomor,
    required String jenisTarif,
    required int nominal,
    required String metodePembayaran,
    String? noKartuKue, // 🚀 TAMBAHKAN INI
    required int modePlat,
    String? rawImagePath,
    String? latitude,
    String? longitude,
  });

  /// Mengubah status transaksi di SQLite (misal: dari PENDING ke SYNCED)
  Future<Either<Failure, Unit>> updateTransactionStatus({
    required String idTransaksiLokal,
    required String newStatus,
  });

  /// Mengambil daftar transaksi yang belum tersinkronisasi (is_sync = 0)
  Future<Either<Failure, List<LocalTransactionModel>>>
  getUnsyncedTransactions();
}
