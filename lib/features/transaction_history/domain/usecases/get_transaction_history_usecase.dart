import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/storage/database_helper.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../data/datasources/transaction_history_remote_datasource.dart';
import '../../data/models/history_item_model.dart';
import '../../data/models/history_response_data_model.dart';

@lazySingleton
class GetTransactionHistoryUseCase {
  final ITransactionHistoryRemoteDataSource _remoteDataSource;
  final ISecureStorageManager _secureStorage;

  GetTransactionHistoryUseCase(this._remoteDataSource, this._secureStorage);

  Future<Either<Failure, HistoryResponseData>> execute({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    // =========================
    // 1. Ambil data lokal
    // =========================
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
            .getTodayRecentTransactions(999);

        localTransactions = localDataMap
            .map((map) => HistoryItemModel.fromLocalDatabase(map))
            .toList();
      } catch (_) {}
    }

    // =========================
    // 2. Hit API
    // =========================
    try {
      final profile = await _secureStorage.getJukirProfile();

      if (profile == null) {
        if (localTransactions.isNotEmpty) {
          return Right(
            HistoryResponseData(
              roda2: 0,
              roda4: 0,
              jumlahTransaksi: localTransactions.length,
              totalPendapatan: localTransactions.fold(
                0,
                (sum, e) => sum + e.kredit,
              ),
              detail: localTransactions,
            ),
          );
        }
        return const Left(CacheFailure('Sesi habis'));
      }

      final String nop = profile['nop']?.toString() ?? '';
      final String shift = profile['shift']?.toString() ?? '1';

      final dynamic rawPetugasId = profile['idUser'];
      final int petugasId = (rawPetugasId is int)
          ? rawPetugasId
          : int.tryParse(rawPetugasId?.toString() ?? '0') ?? 0;

      final apiResult = await _remoteDataSource.getHistory(
        nop: nop,
        petugasId: petugasId,
        shift: shift,
        startDate: startDate,
        endDate: endDate,
        limit: null,
      );

      // =========================
      // 3. Kalau bukan hari ini
      // =========================
      if (!isToday) {
        return Right(apiResult);
      }

      // =========================
      // 4. Merge local + API
      // =========================
      final mergedMap = <String, HistoryItemModel>{};

      for (final item in apiResult.detail) {
        mergedMap[item.orderId] = item;
      }

      for (final item in localTransactions) {
        mergedMap[item.orderId] = item;
      }

      final mergedList = mergedMap.values.toList()
        ..sort((a, b) => b.tglTrx.compareTo(a.tglTrx));

      // =========================
      // 5. Recalculate summary
      // =========================
      int roda2 = 0;
      int roda4 = 0;
      int totalPendapatan = 0;

      for (final item in mergedList) {
        if (item.jenisTarif == 'MOTOR') roda2++;
        if (item.jenisTarif == 'MOBIL') roda4++;
        totalPendapatan += item.kredit;
      }

      return Right(
        HistoryResponseData(
          roda2: roda2,
          roda4: roda4,
          jumlahTransaksi: mergedList.length,
          totalPendapatan: totalPendapatan,
          detail: mergedList,
        ),
      );
    } catch (e) {
      // =========================
      // 6. Fallback ke lokal
      // =========================
      if (localTransactions.isNotEmpty) {
        return Right(
          HistoryResponseData(
            roda2: localTransactions
                .where((e) => e.jenisTarif == 'MOTOR')
                .length,
            roda4: localTransactions
                .where((e) => e.jenisTarif == 'MOBIL')
                .length,
            jumlahTransaksi: localTransactions.length,
            totalPendapatan: localTransactions.fold(
              0,
              (sum, e) => sum + e.kredit,
            ),
            detail: localTransactions,
          ),
        );
      }

      if (e is ServerException) {
        return Left(ServerFailure(e.message));
      }

      return Left(ServerFailure(e.toString()));
    }
  }
}
