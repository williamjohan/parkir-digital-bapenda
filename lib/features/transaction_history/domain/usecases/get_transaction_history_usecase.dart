import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../../data/models/history_response_data_model.dart';
import '../repositories/i_transaction_history_repository.dart';

@lazySingleton
class GetTransactionHistoryUseCase {
  final ITransactionHistoryRepository _repository;

  GetTransactionHistoryUseCase(this._repository);

  Future<Either<Failure, HistoryResponseData>> execute({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return _repository.getHistory(startDate: startDate, endDate: endDate);
  }
}
