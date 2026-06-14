import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/storage/database_helper.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../domain/repositories/i_home_repository.dart';
import '../datasources/i_summary_remote_datasource.dart';
import '../datasources/i_tarif_remote_datasource.dart';
import '../models/dashboard_summary_model.dart';
import '../models/tarif_model.dart';
import '../models/weekly_chart_item_model.dart';

@LazySingleton(as: IHomeRepository)
class HomeRepositoryImpl implements IHomeRepository {
  final ITarifRemoteDataSource _tarifRemoteDS;
  final ISummaryRemoteDataSource _summaryRemoteDS;
  final ISecureStorageManager _secureStorage;

  HomeRepositoryImpl(
    this._tarifRemoteDS,
    this._summaryRemoteDS,
    this._secureStorage,
  );

  @override
  Future<Either<Failure, void>> syncTarif() async {
    try {
      //  PINTU MASUK: Ambil dari API
      final tarifList = await _tarifRemoteDS.getTarif();

      // Konversi List Model ke JSON String
      final jsonString = jsonEncode(tarifList.map((e) => e.toJson()).toList());

      //  SIMPAN KE BRANKAS: Menjamin data masuk ke SecureStorage
      await _secureStorage.saveMasterTarif(jsonString);

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Gagal menyimpan tarif lokal: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, DashboardSummaryModel>>
  getHybridDashboardSummary() async {
    DashboardSummaryModel anchor;

    // --- FASE 1: Ambil JANGKAR (Server atau Cache) ---
    try {
      // Tembak Server
      anchor = await _summaryRemoteDS.getDashboardSummary();

      // Backup ke Brankas jika sewaktu-waktu offline
      // Gunakan fungsi SAVE dan kirimkan string JSON-nya
      await _secureStorage.saveDashboardAnchor(jsonEncode(anchor.toJson()));
    } catch (e) {
      // Jika Offline/Gagal Server, bongkar Brankas Preference.
      // Gunakan fungsi GET untuk membaca brankas
      final savedAnchor = await _secureStorage.getDashboardAnchor();

      if (savedAnchor != null) {
        anchor = DashboardSummaryModel.fromJson(jsonDecode(savedAnchor));
      } else {
        // Fallback mutlak jika baru instal dan langsung offline
        anchor = const DashboardSummaryModel(
          jumlahMotorHariIni: 0,
          jumlahMobilHariIni: 0,
          totalNominalHariIni: 0,
          totalNominalBersihUntukWajibPajak: 0,
          totalNominalBersihUntukBapenda: 0,
        );
      }
    }

    // --- FASE 2: Ambil DELTA (Antrian SQLite Offline) ---
    try {
      final pendingData = await DatabaseHelper.instance
          .getUnsyncedDailySummary();

      // --- FASE 3: THE HYBRID FORMULA (Jangkar + Delta) ---
      final hybridModel = DashboardSummaryModel(
        jumlahMotorHariIni:
            anchor.jumlahMotorHariIni + (pendingData['motor']?.toInt() ?? 0),
        jumlahMobilHariIni:
            anchor.jumlahMobilHariIni + (pendingData['mobil']?.toInt() ?? 0),
        totalNominalHariIni:
            anchor.totalNominalHariIni +
            (pendingData['nominal']?.toDouble() ?? 0.0),
        totalNominalBersihUntukWajibPajak:
            anchor.totalNominalBersihUntukWajibPajak,
        totalNominalBersihUntukBapenda: anchor.totalNominalBersihUntukBapenda,
      );

      return Right(hybridModel);
    } catch (e) {
      // Jika SQLite bermasalah, tetap tampilkan data server sebagai penyelamat
      return Right(anchor);
    }
  }

  @override
  Future<Either<Failure, List<WeeklyChartItemModel>>> getWeeklyChart() async {
    try {
      final chartData = await _summaryRemoteDS.getWeeklyChart();
      return Right(chartData);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Gagal memuat grafik: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<TarifModel>>> getLocalTarifs() async {
    try {
      // PINTU KELUAR: Ambil dari Brankas (Bukan API!)
      // Inilah yang menjamin Chucker tidak akan nembak API lagi saat buka TransactionPage
      final jsonString = await _secureStorage.getMasterTarif();

      if (jsonString == null || jsonString.isEmpty) {
        return const Left(CacheFailure('Data tarif belum tersedia.'));
      }

      final List<dynamic> jsonList = jsonDecode(jsonString);
      final localData = jsonList
          .map((json) => TarifModel.fromJson(json))
          .toList();

      return Right(localData);
    } catch (e) {
      return const Left(CacheFailure('Gagal membaca data dari brankas.'));
    }
  }
}
