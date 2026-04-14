// lib/features/parking_transaction/data/repositories/parking_transaction_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../domain/repositories/i_parking_transaction_repository.dart';
import '../datasources/i_parking_transaction_local_datasource.dart';
import '../datasources/i_parking_transaction_remote_datasource.dart';
import '../models/local_transaction_model.dart';

@LazySingleton(as: IParkingTransactionRepository)
class ParkingTransactionRepositoryImpl
    implements IParkingTransactionRepository {
  final IParkingTransactionLocalDataSource _localDataSource;
  final ISecureStorageManager _secureStorage;
  final IParkingTransactionRemoteDataSource _remoteDataSource;

  ParkingTransactionRepositoryImpl(
    this._localDataSource,
    this._remoteDataSource,
    this._secureStorage,
  );

  @override
  Future<Either<Failure, LocalTransactionModel>> saveNewTransaction({
    String? platNomor,
    required String jenisTarif,
    required int nominal,
    required String metodePembayaran,
    required int modePlat,
    String? rawImagePath,
    String? latitude,
    String? longitude,
  }) async {
    try {
      // 1. Buka Brankas
      final jukirProfile = await _secureStorage.getJukirProfile();
      if (jukirProfile == null) {
        return const Left(
          CacheFailure('Data Jukir tidak ditemukan. Silakan relogin.'),
        );
      }

      // 2. Integrasi logika tarif Bapenda
      final dynamic rawPungutTarif = jukirProfile['pungutTarif'];
      final bool isFree = rawPungutTarif == 1 || rawPungutTarif == '1';

      // 3. Simpan ke SQLite dulu (offline-first)
      final transaction = await _localDataSource.saveNewTransaction(
        platNomor: platNomor,
        jenisTarif: jenisTarif,
        nominal: nominal,
        metodePembayaran: metodePembayaran,
        rawImagePath: rawImagePath,
        modePlat: modePlat,
        isFree: isFree,
        idJukir: jukirProfile['idUser'] ?? '',
        namaJukir: jukirProfile['namaUser'] ?? '',
        nop: jukirProfile['nop'] ?? '',
        latitude: latitude,
        longitude: longitude,
      );

      // 4. ✅ Fire-and-forget: coba sync ke BE
      // Jika gagal, data tetap aman di SQLite dengan is_sync = 0
      try {
        await _remoteDataSource.insertTransaction(
          transaction: transaction,
          jukirProfile: jukirProfile,
        );

        // 5. 🚀 [PERBAIKAN]: Panggil fungsi updateSyncStatus, BUKAN updateTransactionStatus
        await _localDataSource.updateSyncStatus(
          idTransaksiLokal: transaction.idTransaksiLokal,
          isSync: 1, // 1 berarti sukses terkirim ke API
        );
      } catch (remoteError) {
        // Tidak throw ke atas — user tetap dapat success response
        // Data akan di-retry oleh background sync worker nantinya
      }

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
