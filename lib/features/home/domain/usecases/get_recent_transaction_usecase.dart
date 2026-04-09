// lib/features/home/domain/usecases/get_recent_transactions_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../../transaction_history/data/datasources/transaction_history_remote_datasource.dart';
import '../../../transaction_history/data/models/history_item_model.dart';

@lazySingleton
class GetRecentTransactionsUseCase {
  final ITransactionHistoryRemoteDataSource _remoteDataSource;
  final ISecureStorageManager _secureStorage;

  GetRecentTransactionsUseCase(this._remoteDataSource, this._secureStorage);

  Future<Either<Failure, List<HistoryItemModel>>> execute({
    required int limit,
  }) async {
    try {
      // 1. Ambil profil jukir
      final profile = await _secureStorage.getJukirProfile();
      if (profile == null) {
        return const Left(
          CacheFailure('Sesi Jukir tidak ditemukan. Silakan login ulang.'),
        );
      }

      // 2. Ekstrak data yang dibutuhkan API
      final String nop = profile['nop']?.toString() ?? '';
      final String shift = profile['shift']?.toString() ?? '1';

      final dynamic rawPetugasId = profile['idUser'];
      final int petugasId = (rawPetugasId is int)
          ? rawPetugasId
          : int.tryParse(rawPetugasId?.toString() ?? '0') ?? 0;

      // 3. Set rentang tanggal: 7 hari terakhir (cukup untuk ambil 5 transaksi)
      final endDate = DateTime.now();
      final startDate = endDate.subtract(const Duration(days: 7));

      // 4. Ambil data dari API
      final allTransactions = await _remoteDataSource.getHistory(
        nop: nop,
        petugasId: petugasId,
        shift: shift,
        startDate: startDate,
        endDate: endDate,
      );

      // 5. Urutkan dari yang terbaru (berdasarkan tglTrx descending)
      final sortedTransactions = List<HistoryItemModel>.from(allTransactions)
        ..sort((a, b) => b.tglTrx.compareTo(a.tglTrx));

      // 6. Ambil hanya 'limit' transaksi teratas
      final recentTransactions = sortedTransactions.take(limit).toList();

      return Right(recentTransactions);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
