import 'package:dartz/dartz.dart';
import 'package:parkir_digital_bapenda/features/transaction_history/data/models/sof_summary_model.dart';
import '../../../../core/errors/failure.dart';
import '../../data/models/history_response_data_model.dart';

abstract class ITransactionHistoryRepository {
  Future<Either<Failure, HistoryResponseData>> getHistory({
    required DateTime startDate,
    required DateTime endDate,
    required String nop,
    required int page,
    required int pageSize,
    required int jenisKendaraan,
    String? idDevice,
  });

  Future<Either<Failure, List<SofSummaryModel>>> getSofBreakdown({
    required String nop,
    required DateTime startDate,
    required DateTime endDate,
    required int jenisKendaraan,
  });
}
