import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../../../core/utils/app_logger.dart';
import '../repositories/i_parking_transaction_repository.dart';
import '../../data/datasources/i_parking_transaction_remote_datasource.dart';

@lazySingleton
class SyncParkingTransactionsUseCase {
  final IParkingTransactionRepository _repository;
  final IParkingTransactionRemoteDataSource _remoteDataSource;
  final ISecureStorageManager _secureStorage;

  SyncParkingTransactionsUseCase(
    this._repository,
    this._remoteDataSource,
    this._secureStorage,
  );

  /// Mengembalikan jumlah data yang berhasil disinkronkan
  Future<Either<Failure, int>> execute() async {
    try {
      AppLogger.debug('>>> [SYNC] Memulai Pasukan Penyapu...');
      final jukirProfile = await _secureStorage.getJukirProfile();
      if (jukirProfile == null) {
        return const Left(CacheFailure('Data profil kosong. Tidak bisa sync.'));
      }
      final unsyncedResult = await _repository.getUnsyncedTransactions();

      return await unsyncedResult.fold((failure) => Left(failure), (
        unsyncedList,
      ) async {
        if (unsyncedList.isEmpty) {
          AppLogger.debug('>>> [SYNC] Tidak ada data tertunda. Aman!');
          return const Right(0);
        }

        int successCount = 0;
        for (final trx in unsyncedList) {
          try {
            await _remoteDataSource.insertTransaction(
              transaction: trx,
              jukirProfile: jukirProfile,
            );
            await _repository.updateTransactionStatus(
              idTransaksiLokal: trx.idTransaksiLokal,
              newStatus:
                  'SYNCED', // Atau Anda bisa buat fungsi markAsSynced khusus
            );
            if (trx.fotoKendaraan != null && trx.fotoKendaraan!.isNotEmpty) {
              final file = File(trx.fotoKendaraan!);
              if (file.existsSync()) {
                file.deleteSync();
              }
            }

            successCount++;
          } catch (e) {
            AppLogger.error('>>> [SYNC FAIL] Trx ${trx.idTransaksiLokal}: $e');
          }
        }

        AppLogger.debug(
          '>>> [SYNC DONE] Berhasil kirim $successCount dari ${unsyncedList.length} data.',
        );
        return Right(successCount);
      });
    } catch (e) {
      return Left(ServerFailure('Fatal Error Sync: $e'));
    }
  }
}
