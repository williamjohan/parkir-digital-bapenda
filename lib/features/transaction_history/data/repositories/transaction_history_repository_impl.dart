import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/repositories/i_transaction_history_repository.dart';
import '../datasources/transaction_history_remote_datasource.dart';
import '../models/history_response_data_model.dart';

@LazySingleton(as: ITransactionHistoryRepository)
class TransactionHistoryRepositoryImpl
    implements ITransactionHistoryRepository {
  final ITransactionHistoryRemoteDataSource _remoteDataSource;

  TransactionHistoryRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, HistoryResponseData>> getHistory({
    required DateTime startDate,
    required DateTime endDate,
    required String nop,
    String? idDevice,
  }) async {
    try {
      final apiResult = await _remoteDataSource.getHistory(
        nop: nop,
        startDate: startDate,
        endDate: endDate,
        limit: null,
        idDevice: idDevice,
      );
      return Right(apiResult);
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
