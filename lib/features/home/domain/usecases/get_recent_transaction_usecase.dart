import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../transaction_history/domain/repositories/i_transaction_history_repository.dart';
import '../../../transaction_history/data/models/history_item_model.dart';

@lazySingleton
class GetRecentTransactionsUseCase {
  final ITransactionHistoryRepository _repository;
  GetRecentTransactionsUseCase(this._repository);

  Future<Either<Failure, List<HistoryItemModel>>> execute({
    required int limit,
    required String nop,
  }) async {
    try {
      if (nop.isEmpty) return const Right([]);

      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month, now.day, 0, 0, 0);
      final endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);

      final result = await _repository.getHistory(
        nop: nop,
        startDate: startDate,
        endDate: endDate,
      );

      return result.fold(
        (failure) {
          AppLogger.error(
            '🚨 [Error] GetRecentTransactionsUseCase: ${failure.message}',
          );
          return Left(failure);
        },
        (historyData) {
          final List<HistoryItemModel> rawData = historyData.detail;
          AppLogger.debug('✅ [Audit] Murni dari API: ${rawData.length} item');

          return Right(rawData.take(limit).toList());
        },
      );
    } catch (e) {
      AppLogger.error('🚨 [Fatal Error] GetRecentTransactionsUseCase: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}
