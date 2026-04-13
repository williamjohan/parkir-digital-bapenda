import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/storage/database_helper.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../data/datasources/transaction_history_remote_datasource.dart';
import '../../data/models/history_item_model.dart';

@lazySingleton
class GetTransactionHistoryUseCase {
  final ITransactionHistoryRemoteDataSource _remoteDataSource;
  final ISecureStorageManager _secureStorage;

  GetTransactionHistoryUseCase(this._remoteDataSource, this._secureStorage);

  Future<Either<Failure, List<HistoryItemModel>>> execute({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    // 1. Ambil data lokal jika rentang mencakup hari ini
    List<HistoryItemModel> localTransactions = [];
    final now = DateTime.now();
    final todayOnly = DateTime(now.year, now.month, now.day);
    final startOnly = DateTime(startDate.year, startDate.month, startDate.day);
    final endOnly = DateTime(endDate.year, endDate.month, endDate.day);
    final isToday =
        !todayOnly.isBefore(startOnly) && !todayOnly.isAfter(endOnly);

    if (isToday) {
      try {
        final localDataMap = await DatabaseHelper.instance
            .getTodayRecentTransactions(999); // ambil semua hari ini
        localTransactions = localDataMap
            .map((map) => HistoryItemModel.fromLocalDatabase(map))
            .toList();
      } catch (_) {}
    }

    // 2. Coba tembak API
    try {
      final profile = await _secureStorage.getJukirProfile();
      if (profile == null) {
        // Tidak ada profil — kembalikan lokal saja jika ada
        if (localTransactions.isNotEmpty) return Right(localTransactions);
        return const Left(CacheFailure('Sesi habis'));
      }

      final String nop = profile['nop']?.toString() ?? '';
      final String shift = profile['shift']?.toString() ?? '1';
      final dynamic rawPetugasId = profile['idUser'];
      final int petugasId = (rawPetugasId is int)
          ? rawPetugasId
          : int.tryParse(rawPetugasId?.toString() ?? '0') ?? 0;

      final normalizedStart = DateTime(
        startDate.year,
        startDate.month,
        startDate.day,
        12,
      );
      final normalizedEnd = DateTime(
        endDate.year,
        endDate.month,
        endDate.day,
        12,
      );

      final apiResult = await _remoteDataSource.getHistory(
        nop: nop,
        petugasId: petugasId,
        shift: shift,
        startDate: normalizedStart,
        endDate: normalizedEnd,
        limit: null,
      );

      // 3. Jika rentang bukan hari ini, langsung return API
      if (!isToday) return Right(apiResult);

      // 4. Jika hari ini, merge lokal + API
      // Lokal menang jika orderId sama (transaksi baru belum tentu ada di BE)
      final mergedMap = <String, HistoryItemModel>{};
      for (final item in apiResult) {
        mergedMap[item.orderId] = item;
      }
      for (final item in localTransactions) {
        mergedMap[item.orderId] = item;
      }

      final merged = mergedMap.values.toList()
        ..sort((a, b) => b.tglTrx.compareTo(a.tglTrx));

      return Right(merged);
    } catch (e) {
      // API gagal/offline — fallback ke lokal jika ada
      if (localTransactions.isNotEmpty) return Right(localTransactions);
      if (e is ServerException) return Left(ServerFailure(e.message));
      return Left(ServerFailure(e.toString()));
    }
  }
}
