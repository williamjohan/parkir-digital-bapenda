import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/features/home/domain/entities/dashboard_summary_jukir_entity.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../transaction_history/data/models/history_item_model.dart';
import '../../../transaction_history/domain/repositories/i_transaction_history_repository.dart';
import '../entities/dashboard_summary_non_jukir_entity.dart';
import '../entities/dashboard_summary_pengawas.entity.dart';
import '../repositories/i_home_repository.dart';

@lazySingleton
class HomeUsecase {
  final IHomeRepository _repository;
  final ITransactionHistoryRepository _historyRepository;

  HomeUsecase(this._repository, this._historyRepository);

  Future<Either<Failure, DashboardSummaryJukirEntity>>
  getDashboardSummaryJukir({required String nop}) {
    return _repository.getDashboardSummaryJukir(nop: nop);
  }

  Future<Either<Failure, DashboardSummaryNonJukirEntity>>
  getDashboardSummaryNonJukirRange({String? tglAwal, String? tglAkhir}) {
    return _repository.getDashboardSummaryNonJukirRange(
      tglAwal: tglAwal,
      tglAkhir: tglAkhir,
    );
  }

  Future<Either<Failure, DashboardSummaryNonJukirEntity>>
  getDashboardSummaryNonJukir() {
    return _repository.getDashboardSummaryNonJukir();
  }

  Future<Either<Failure, DashboardSummaryPengawasEntity>>
  getDashboardSummaryPengawas() {
    return _repository.getDashboardSummaryPengawas();
  }

  Future<Either<Failure, List<HistoryItemModel>>> getRecentTransactions({
    required int limit,
    required String nop,
  }) async {
    try {
      if (nop.isEmpty) return const Right([]);

      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month, now.day, 0, 0, 0);
      final endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);

      final result = await _historyRepository.getHistory(
        nop: nop,
        startDate: startDate,
        endDate: endDate,
        page: 1,
        pageSize: limit,
        jenisKendaraan: 0,
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
