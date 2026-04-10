import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../data/datasources/transaction_history_remote_datasource.dart';
import '../../data/models/history_item_model.dart';

// lib/features/transaction_history/domain/usecases/get_transaction_history_usecase.dart
// lib/features/transaction_history/domain/usecases/get_transaction_history_usecase.dart

@lazySingleton
class GetTransactionHistoryUseCase {
  final ITransactionHistoryRemoteDataSource _remoteDataSource;
  final ISecureStorageManager _secureStorage;

  GetTransactionHistoryUseCase(this._remoteDataSource, this._secureStorage);

  Future<Either<Failure, List<HistoryItemModel>>> execute({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final profile = await _secureStorage.getJukirProfile();
      if (profile == null) return const Left(CacheFailure('Sesi habis'));

      final String nop = profile['nop']?.toString() ?? '';
      final String shift = profile['shift']?.toString() ?? '1';
      final dynamic rawPetugasId = profile['idUser'];

      // Pastikan petugasId adalah integer murni sebelum dikirim ke DS
      final int petugasId = (rawPetugasId is int)
          ? rawPetugasId
          : int.tryParse(rawPetugasId?.toString() ?? '0') ?? 0;

      // 🚀 [STRATEGI NORMALISASI]:
      // Mengikuti pola sukses Home yang menggunakan DateTime.now()
      // Kita set jam ke waktu 'aman' agar tidak bergeser tanggal saat toUtc()
      final normalizedStart = DateTime(
        startDate.year,
        startDate.month,
        startDate.day,
        12,
        0,
        0,
      );
      final normalizedEnd = DateTime(
        endDate.year,
        endDate.month,
        endDate.day,
        12,
        0,
        0,
      );

      final result = await _remoteDataSource.getHistory(
        nop: nop,
        petugasId: petugasId,
        shift: shift,
        startDate: normalizedStart,
        endDate: normalizedEnd,
        limit: null, // Sesuai kesepakatan, history ambil semua (limit nullable)
      );

      return Right(result);
    } catch (e) {
      if (e is ServerException) return Left(ServerFailure(e.message));
      return Left(ServerFailure(e.toString()));
    }
  }
}
