import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/storage/database_helper.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../../transaction_history/data/datasources/transaction_history_remote_datasource.dart';
import '../../../transaction_history/data/models/history_item_model.dart';
import '../../../transaction_history/data/models/history_response_data_model.dart';

@lazySingleton
class GetRecentTransactionsUseCase {
  final ITransactionHistoryRemoteDataSource _remoteDataSource;
  final ISecureStorageManager _secureStorage;

  GetRecentTransactionsUseCase(this._remoteDataSource, this._secureStorage);
  Future<Either<Failure, List<HistoryItemModel>>> execute({
    required int limit,
  }) async {
    try {
      // 1. Ambil data lokal hari ini
      final localDataMap = await DatabaseHelper.instance
          .getTodayRecentTransactions(limit);

      final localTransactions = localDataMap
          .map((map) => HistoryItemModel.fromLocalDatabase(map))
          .toList();

      // 2. Ambil profil untuk tembak API
      final profile = await _secureStorage.getJukirProfile();
      if (profile == null) {
        // Kalau tidak ada profil, fallback ke lokal saja
        return Right(localTransactions);
      }

      final String nop = profile['nop']?.toString() ?? '';
      final String shift = profile['shift']?.toString() ?? '1';
      final dynamic rawPetugasId = profile['idUser'];
      final int petugasId = (rawPetugasId is int)
          ? rawPetugasId
          : int.tryParse(rawPetugasId?.toString() ?? '0') ?? 0;
      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month, now.day, 0, 0, 0);
      final endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);

      // 3. Selalu tembak API untuk data lengkap dari server
      final HistoryResponseData apiResult = await _remoteDataSource.getHistory(
        nop: nop,
        petugasId: petugasId,
        shift: shift,
        startDate: startDate,
        endDate: endDate,
        limit: limit,
      );

      final apiTransactions = apiResult.detail; // ✅ FIX

      // 4. Merge: lokal + API, dedup by orderId
      // Lokal diutamakan karena lebih fresh (baru diinput)
      final mergedMap = <String, HistoryItemModel>{};

      // Masukkan API dulu sebagai base
      for (final item in apiTransactions) {
        mergedMap[item.orderId] = item;
      }

      // Timpa dengan lokal jika orderId sama (lokal lebih fresh)
      for (final item in localTransactions) {
        mergedMap[item.orderId] = item;
      }

      // 5. Urutkan terbaru, ambil sesuai limit
      final merged = mergedMap.values.toList()
        ..sort((a, b) => b.tglTrx.compareTo(a.tglTrx));

      return Right(merged.take(limit).toList());
    } catch (e) {
      // Kalau API gagal (offline), fallback ke lokal saja
      try {
        final localDataMap = await DatabaseHelper.instance
            .getTodayRecentTransactions(limit);
        final localTransactions = localDataMap
            .map((map) => HistoryItemModel.fromLocalDatabase(map))
            .toList();
        return Right(localTransactions);
      } catch (_) {
        return Left(ServerFailure(e.toString()));
      }
    }
  }
}
