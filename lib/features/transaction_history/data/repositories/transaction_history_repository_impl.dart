import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/features/transaction_history/data/models/sof_summary_model.dart';
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
    required int page,
    required int pageSize,
    required int jenisKendaraan,
    String? idDevice,
  }) async {
    try {
      final apiResult = await _remoteDataSource.getHistory(
        nop: nop,
        startDate: startDate,
        endDate: endDate,
        page: page,
        pageSize: pageSize,
        jenisKendaraan: jenisKendaraan,
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

  @override
  Future<Either<Failure, List<SofSummaryModel>>> getSofBreakdown({
    required String nop,
    required DateTime startDate,
    required DateTime endDate,
    required int jenisKendaraan,
  }) async {
    try {
      final result = await _remoteDataSource.getSofBreakdown(
        nop: nop,
        startDate: startDate,
        endDate: endDate,
        jenisKendaraan: jenisKendaraan
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
