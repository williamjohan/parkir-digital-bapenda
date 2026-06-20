import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../../../core/utils/app_logger.dart'; // Pastikan ada logger
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
      final profile = await _secureStorage.getJukirProfile();
      if (profile == null) {
        return const Right([]);
      }

      final String nop = profile['nop']?.toString() ?? '';
      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month, now.day, 0, 0, 0);
      final endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);

      // 1. Ambil data MURNI dari API
      final HistoryResponseData apiResult = await _remoteDataSource.getHistory(
        nop: nop,
        startDate: startDate,
        endDate: endDate,
        limit: limit,
      );

      // 2. Tidak ada merging, tidak ada deduplikasi.
      // Langsung kembalikan apa yang diberikan API.
      final List<HistoryItemModel> rawData = apiResult.detail;

      AppLogger.debug('✅ [Audit] Murni dari API: ${rawData.length} item');

      return Right(rawData.take(limit).toList());
    } catch (e) {
      AppLogger.error('🚨 [Error] GetRecentTransactionsUseCase: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}
