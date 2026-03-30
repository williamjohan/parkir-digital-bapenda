// lib/features/parking_transaction/data/repositories/parking_transaction_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../domain/repositories/i_parking_transaction_repository.dart';
import '../datasources/i_parking_transaction_local_datasource.dart';
import '../models/local_transaction_model.dart';

@LazySingleton(as: IParkingTransactionRepository)
class ParkingTransactionRepositoryImpl
    implements IParkingTransactionRepository {
  final IParkingTransactionLocalDataSource _localDataSource;
  final ISecureStorageManager _secureStorage;

  ParkingTransactionRepositoryImpl(this._localDataSource, this._secureStorage);

  @override
  Future<Either<Failure, LocalTransactionModel>> saveNewTransaction({
    String? platNomor, // [PERBAIKAN]
    required String kategoriKendaraan,
    String? rawImagePath, // [PERBAIKAN]
    required bool isFree,
    required int modePlat, // [TAMBAHAN]
  }) async {
    try {
      final jukirProfile = await _secureStorage.getJukirProfile();
      if (jukirProfile == null) {
        return const Left(
          CacheFailure('Data Jukir tidak ditemukan. Silakan relogin.'),
        );
      }

      final transaction = await _localDataSource.saveNewTransaction(
        platNomor: platNomor,
        kategoriKendaraan: kategoriKendaraan,
        rawImagePath: rawImagePath,
        isFree: isFree,
        modePlat: modePlat, // Teruskan ke Data Source
        idJukir: jukirProfile['id_jukir'] ?? '',
        namaJukir: jukirProfile['nama'] ?? '',
        nop: jukirProfile['nop'] ?? '',
      );

      return Right(transaction);
    } catch (e) {
      return Left(DatabaseFailure('Gagal menyimpan parkir: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateTransactionStatus({
    required String idTransaksiLokal,
    required String newStatus,
  }) async {
    try {
      await _localDataSource.updateTransactionStatus(
        idTransaksiLokal: idTransaksiLokal,
        newStatus: newStatus,
      );
      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure('Gagal update status: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<LocalTransactionModel>>>
  getUnsyncedTransactions() async {
    try {
      final transactions = await _localDataSource.getUnsyncedTransactions();
      return Right(transactions);
    } catch (e) {
      return Left(
        DatabaseFailure('Gagal memuat data tertunda: ${e.toString()}'),
      );
    }
  }
}
