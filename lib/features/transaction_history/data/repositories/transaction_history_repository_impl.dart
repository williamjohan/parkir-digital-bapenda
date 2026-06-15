import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../domain/repositories/i_transaction_history_repository.dart';
import '../datasources/transaction_history_remote_datasource.dart';
import '../models/history_response_data_model.dart';

@LazySingleton(as: ITransactionHistoryRepository)
class TransactionHistoryRepositoryImpl
    implements ITransactionHistoryRepository {
  final ITransactionHistoryRemoteDataSource _remoteDataSource;
  final ISecureStorageManager _secureStorage;

  TransactionHistoryRepositoryImpl(this._remoteDataSource, this._secureStorage);

  @override
  Future<Either<Failure, HistoryResponseData>> getHistory({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      // 1. Ambil profil
      final profile = await _secureStorage.getJukirProfile();
      if (profile == null) {
        return const Left(CacheFailure('Sesi habis'));
      }

      final String nop = profile['nop']?.toString() ?? '';
      final String shift = profile['shift']?.toString() ?? '1';
      final dynamic rawPetugasId = profile['idUser'];
      final int petugasId = (rawPetugasId is int)
          ? rawPetugasId
          : int.tryParse(rawPetugasId?.toString() ?? '0') ?? 0;

      // 2. Hit API (Remote) - Tanpa limit (biarkan Backend yang handle semua data)
      final apiResult = await _remoteDataSource.getHistory(
        nop: nop,
        petugasId: petugasId,
        shift: shift,
        startDate: startDate,
        endDate: endDate,
        limit: null,
      );

      // 3. Kembalikan data murni dari API
      // Backend sudah menghitung summary (roda2, roda4, total), kita tinggal pakai.
      return Right(apiResult);
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
