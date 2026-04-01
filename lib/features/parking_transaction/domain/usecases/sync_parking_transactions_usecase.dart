// lib/features/parking_transaction/domain/usecases/sync_parking_transactions_usecase.dart

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

      // 1. Cek Brankas Profil
      final jukirProfile = await _secureStorage.getJukirProfile();
      if (jukirProfile == null) {
        return const Left(CacheFailure('Data profil kosong. Tidak bisa sync.'));
      }

      // 2. Ambil semua data yang nyangkut (is_sync == 0)
      final unsyncedResult = await _repository.getUnsyncedTransactions();

      return await unsyncedResult.fold((failure) => Left(failure), (
        unsyncedList,
      ) async {
        if (unsyncedList.isEmpty) {
          AppLogger.debug('>>> [SYNC] Tidak ada data tertunda. Aman!');
          return const Right(0);
        }

        int successCount = 0;

        // 3. Loop Eksekusi Satu per Satu
        for (final trx in unsyncedList) {
          try {
            // Tembak Rudal ke Bapenda
            await _remoteDataSource.insertTransaction(
              transaction: trx,
              jukirProfile: jukirProfile,
            );

            // Jika tidak throw error = SUKSES (200 OK)
            // Update is_sync = 1 di SQLite
            await _repository.updateTransactionStatus(
              idTransaksiLokal: trx.idTransaksiLokal,
              newStatus:
                  'SYNCED', // Atau Anda bisa buat fungsi markAsSynced khusus
            );

            // [GARBAGE COLLECTOR]: Hapus file foto fisik agar HP tidak penuh!
            if (trx.fotoKendaraan != null && trx.fotoKendaraan!.isNotEmpty) {
              final file = File(trx.fotoKendaraan!);
              if (file.existsSync()) {
                file.deleteSync();
              }
            }

            successCount++;
          } catch (e) {
            // Jika 1 gagal (misal RTO), JANGAN hentikan loop.
            // Lanjut ke transaksi berikutnya, biarkan yang gagal tetap is_sync = 0.
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
