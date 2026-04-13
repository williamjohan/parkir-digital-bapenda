import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/storage/database_helper.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../../transaction_history/data/datasources/transaction_history_remote_datasource.dart';
import '../../../transaction_history/data/models/history_item_model.dart';

@lazySingleton
class GetRecentTransactionsUseCase {
  final ITransactionHistoryRemoteDataSource _remoteDataSource;
  final ISecureStorageManager _secureStorage;

  GetRecentTransactionsUseCase(this._remoteDataSource, this._secureStorage);

  Future<Either<Failure, List<HistoryItemModel>>> execute({
    required int limit,
  }) async {
    try {
      // ==========================================
      // 1. CEK LOKAL DULU (HANYA TRANSAKSI HARI INI)
      // ==========================================
      // Menggunakan fungsi getTodayRecentTransactions yang baru kita buat di DatabaseHelper
      final localDataMap = await DatabaseHelper.instance
          .getTodayRecentTransactions(limit);

      if (localDataMap.isNotEmpty) {
        // ⚠️ CATATAN AUDITOR: Pastikan mapping SQLite ke Model ini aman.
        // Jika nama kolom SQLite (waktu_transaksi) berbeda dengan key JSON API (misal: tglTrx),
        // gunakan factory khusus seperti HistoryItemModel.fromLocalDatabase(map)
        final localTransactions = localDataMap
            .map((map) => HistoryItemModel.fromJson(map))
            .toList();

        return Right(localTransactions);
      }

      // ==========================================
      // 2. JIKA LOKAL KOSONG (Tembak API, khusus HARI INI saja)
      // ==========================================
      final profile = await _secureStorage.getJukirProfile();
      if (profile == null) {
        return const Left(
          CacheFailure('Sesi Jukir tidak ditemukan. Silakan login ulang.'),
        );
      }

      final String nop = profile['nop']?.toString() ?? '';
      final String shift = profile['shift']?.toString() ?? '1';
      final dynamic rawPetugasId = profile['idUser'];
      final int petugasId = (rawPetugasId is int)
          ? rawPetugasId
          : int.tryParse(rawPetugasId?.toString() ?? '0') ?? 0;

      // 🚀 [KUNCI PERUBAHAN]: Kunci rentang waktu murni hanya hari ini!
      final today = DateTime.now();

      // Tembak API Server sebagai penyelamat
      final apiTransactions = await _remoteDataSource.getHistory(
        nop: nop,
        petugasId: petugasId,
        shift: shift,
        startDate: today,
        endDate: today,
        limit: limit,
      );

      // Urutkan dari yang terbaru untuk memastikan UI selalu menampilkan yang terkini
      final sortedTransactions = List<HistoryItemModel>.from(apiTransactions)
        ..sort((a, b) => b.tglTrx.compareTo(a.tglTrx));

      // Tidak perlu lagi memanggil .take(limit) karena BE sudah membatasinya dari sana.

      return Right(sortedTransactions);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
