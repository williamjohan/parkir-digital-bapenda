// lib/features/parking_transaction/domain/repositories/i_parking_transaction_repository.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../data/models/local_transaction_model.dart';

abstract class IParkingTransactionRepository {
  /// Menyimpan transaksi baru ke penyimpanan lokal (SQLite).
  /// Parameter disesuaikan dengan kontrak Swagger Bapenda agar sinkron saat Sync.
  Future<Either<Failure, LocalTransactionModel>> saveNewTransaction({
    String? platNomor, // Maps ke: platNumber (Swagger)
    required String jenisTarif, // Maps ke: jenisTarif (Swagger - String)
    required int nominal, // Maps ke: kredit (Swagger - Decimal)
    required String metodePembayaran, // Maps ke: sof (Swagger - String)
    required int modePlat,
    String? rawImagePath, // Akan diproses menjadi fotoNopol (Swagger)
    String? latitude, // Maps ke: latitude (Swagger)
    String? longitude, // Maps ke: longitude (Swagger)
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
