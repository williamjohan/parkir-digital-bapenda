import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/features/home/data/datasources/summary_remote_datasource.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/storage/database_helper.dart';
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

  HomeRepositoryImpl(
    this._tarifRemoteDS,
    this._summaryRemoteDS,
    this._secureStorage,
  );

  @override
  Future<Either<Failure, void>> syncTarif() async {
    try {
      final tarifList = await _tarifRemoteDS.getTarif();
      final jsonString = jsonEncode(tarifList.map((e) => e.toJson()).toList());
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
    try {
      anchor = await _summaryRemoteDS.getDashboardSummary(nop: nop);
      await _secureStorage.saveDashboardAnchor(jsonEncode(anchor.toJson()));
    } catch (e) {
      final savedAnchor = await _secureStorage.getDashboardAnchor();

      if (savedAnchor != null) {
        anchor = DashboardSummaryModel.fromJson(jsonDecode(savedAnchor));
      } else {
        anchor = const DashboardSummaryModel(
          jumlahMotorHariIni: 0,
          jumlahMobilHariIni: 0,
          totalNominalHariIni: 0,
          totalNominalBersihUntukWajibPajak: 0,
          totalNominalBersihUntukBapenda: 0,
        );
      }
    }
    try {
      final pendingData = await DatabaseHelper.instance
          .getUnsyncedDailySummary();
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
