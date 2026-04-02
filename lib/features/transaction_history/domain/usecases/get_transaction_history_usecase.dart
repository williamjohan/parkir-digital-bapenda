import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../data/datasources/transaction_history_remote_datasource.dart';
import '../../data/models/history_item_model.dart';

@lazySingleton
class GetTransactionHistoryUseCase {
  final ITransactionHistoryRemoteDataSource _remoteDataSource;
  final ISecureStorageManager _secureStorage;

  // Catatan: Idealnya memanggil Repository, tapi untuk kecepatan eksekusi
  // kita bypass langsung ke RemoteDataSource (bisa di-refactor ke Repo nanti jika diperlukan).
  GetTransactionHistoryUseCase(this._remoteDataSource, this._secureStorage);

  Future<Either<Failure, List<HistoryItemModel>>> execute({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      // 1. Ambil Profil Jukir diam-diam dari Brankas
      final profile = await _secureStorage.getJukirProfile();
      if (profile == null) {
        return const Left(
          CacheFailure('Sesi Jukir tidak ditemukan. Silakan login ulang.'),
        );
      }

      // 2. Ekstrak data yang dibutuhkan API
      final String nop = profile['nop']?.toString() ?? '';
      final String shift = profile['shift']?.toString() ?? '1';

      final dynamic rawPetugasId = profile['idUser'];
      final int petugasId = (rawPetugasId is int)
          ? rawPetugasId
          : int.tryParse(rawPetugasId?.toString() ?? '0') ?? 0;

      // 3. Tembakkan ke API
      final result = await _remoteDataSource.getHistory(
        nop: nop,
        petugasId: petugasId,
        shift: shift,
        startDate: startDate,
        endDate: endDate,
      );

      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
