import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/features/home/data/datasources/summary_remote_datasource.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/storage/database_helper.dart';
import '../../../../core/storage/database_helper_2.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../domain/entities/dashboard_summary_non_jukir_entity.dart';
import '../../domain/repositories/i_home_repository.dart';
import '../datasources/i_tarif_remote_datasource.dart';
import '../mapper/dashboard_summary_non_jukir_mapper.dart';
import '../models/dashboard_summary_model.dart';

@LazySingleton(as: IHomeRepository)
class HomeRepositoryImpl implements IHomeRepository {
  final ITarifRemoteDataSource _tarifRemoteDS;
  final ISummaryRemoteDataSource _summaryRemoteDS;
  final ISecureStorageManager _secureStorage;
  final DatabaseHelper2 _databaseHelper;

  HomeRepositoryImpl(
    this._tarifRemoteDS,
    this._summaryRemoteDS,
    this._secureStorage,
    this._databaseHelper,
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
  Future<Either<Failure, DashboardSummaryModel>> getHybridDashboardSummary({
    required String nop,
  }) async {
    DashboardSummaryModel anchor;

    // --- FASE 1: Ambil JANGKAR (Server atau Cache) ---
    try {
      anchor = await _summaryRemoteDS.getDashboardSummary(nop: nop);

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
  Future<Either<Failure, DashboardSummaryNonJukirEntity>>
  getDashboardSummaryNonJukir() async {
    try {
      final model = await _summaryRemoteDS.getDashboardSummaryNonJukir();

      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, DashboardSummaryNonJukirEntity>>
  getDashboardSummaryNonJukirRange({String? tglAwal, String? tglAkhir}) async {
    try {
      final model = await _summaryRemoteDS.getDashboardSummaryNonJukirRange(
        tglAwal: tglAwal,
        tglAkhir: tglAkhir,
      );

      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
