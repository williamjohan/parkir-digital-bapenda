import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../data/models/history_response_data_model.dart';

abstract class ITransactionHistoryRepository {
  Future<Either<Failure, HistoryResponseData>> getHistory({
    required DateTime startDate,
    required DateTime endDate,
  });
}
