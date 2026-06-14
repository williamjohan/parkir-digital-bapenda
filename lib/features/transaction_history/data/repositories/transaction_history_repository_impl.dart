import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/storage/database_helper.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../domain/repositories/i_transaction_history_repository.dart';
import '../datasources/transaction_history_remote_datasource.dart';
import '../models/history_item_model.dart';
import '../models/history_response_data_model.dart';

// Registrasi Injectable agar otomatis dikenali oleh GetIt/Locator
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
    // =========================
    // 1. Ambil data lokal (SQLite)
    // =========================
    List<HistoryItemModel> localTransactions = [];
    final now = DateTime.now();
    final todayOnly = DateTime(now.year, now.month, now.day);
    final startOnly = DateTime(startDate.year, startDate.month, startDate.day);
    final endOnly = DateTime(endDate.year, endDate.month, endDate.day);
    final isToday =
        !todayOnly.isBefore(startOnly) && !todayOnly.isAfter(endOnly);

    if (isToday) {
      try {
        final localDataMap = await DatabaseHelper.instance
            .getTodayRecentTransactions(999);
        localTransactions = localDataMap
            .map((map) => HistoryItemModel.fromLocalDatabase(map))
            .toList();
      } catch (_) {}
    }

    // =========================
    // 2. Hit API (Remote)
    // =========================
    try {
      final profile = await _secureStorage.getJukirProfile();

      // 🚀 Fallback jika profil hilang tapi ada data lokal
      if (profile == null) {
        if (localTransactions.isNotEmpty) {
          final totalKotor = localTransactions.fold(
            0,
            (sum, e) => sum + e.kredit,
          );
          return Right(
            HistoryResponseData(
              roda2: 0,
              roda4: 0,
              jumlahTransaksi: localTransactions.length,
              totalPendapatan: totalKotor,
              totalPendapatanWajibPajak: totalKotor
                  .toDouble(), // Sementara anggap bersih jika offline total
              totalPendapatanBapenda: 0.0,
              detail: localTransactions,
            ),
          );
        }
        return const Left(CacheFailure('Sesi habis'));
      }

      final String nop = profile['nop']?.toString() ?? '';
      final String shift = profile['shift']?.toString() ?? '1';
      final dynamic rawPetugasId = profile['idUser'];
      final int petugasId = (rawPetugasId is int)
          ? rawPetugasId
          : int.tryParse(rawPetugasId?.toString() ?? '0') ?? 0;

      final apiResult = await _remoteDataSource.getHistory(
        nop: nop,
        petugasId: petugasId,
        shift: shift,
        startDate: startDate,
        endDate: endDate,
        limit: null,
      );

      // =========================
      // 3. Kalau bukan hari ini, langsung kembalikan API
      // =========================
      if (!isToday) {
        return Right(apiResult);
      }
      // =========================
      // 5. Recalculate summary
      // =========================
      int roda2 = 0;
      int roda4 = 0;
      int totalPendapatanKotor = 0;

      double totalPajak = 0;
      double totalBersih = 0;

      for (final item in apiResult.detail) {
        if (item.jenisTarif == 'MOTOR') roda2++;
        if (item.jenisTarif == 'MOBIL') roda4++;

        totalPendapatanKotor += item.kredit;

        // Hitung pajak Hibrida menggunakan "tarifPajak" bawaan masing-masing item.
        // Jika dari API pajaknya 10, dia akan potong 10%.
        // Jika offline (lokal) pajaknya 0, dia tidak akan potong pajak sampai berhasil di-sync.
        final double pajakItem = (item.kredit * item.tarifPajak) / 100;
        final double bersihItem = item.kredit - pajakItem;

        totalPajak += pajakItem;
        totalBersih += bersihItem;
      }

      return Right(
        HistoryResponseData(
          roda2: roda2,
          roda4: roda4,
          jumlahTransaksi: apiResult.detail.length,
          totalPendapatan: totalPendapatanKotor,
          totalPendapatanWajibPajak: totalBersih,
          totalPendapatanBapenda: totalPajak,
          detail: apiResult.detail,
        ),
      );
    } catch (e) {
      // =========================
      // 6. Fallback ke lokal (Gagal API)
      // =========================
      if (localTransactions.isNotEmpty) {
        final totalKotor = localTransactions.fold(
          0,
          (sum, e) => sum + e.kredit,
        );
        return Right(
          HistoryResponseData(
            roda2: localTransactions
                .where((e) => e.jenisTarif == 'MOTOR')
                .length,
            roda4: localTransactions
                .where((e) => e.jenisTarif == 'MOBIL')
                .length,
            jumlahTransaksi: localTransactions.length,
            totalPendapatan: totalKotor,
            totalPendapatanWajibPajak: totalKotor
                .toDouble(), // Offline, belum ada potongan
            totalPendapatanBapenda: 0.0,
            detail: localTransactions,
          ),
        );
      }

      if (e is ServerException) {
        return Left(ServerFailure(e.message));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
