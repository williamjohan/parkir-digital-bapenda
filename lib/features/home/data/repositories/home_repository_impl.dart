import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/features/home/data/datasources/dashboard_summary_remote_datasource.dart';
import 'package:parkir_digital_bapenda/features/home/data/models/dashboard_summary_non_jukir/dashboard_summary_non_jukir_model.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/storage/app_preferences.dart';
import '../../../../core/storage/i_secure_storage_manager.dart';
import '../../domain/entities/dashboard_summary_jukir_entity.dart';
import '../../domain/entities/dashboard_summary_non_jukir_entity.dart';
import '../../domain/entities/dashboard_summary_pengawas.entity.dart';
import '../../domain/repositories/i_home_repository.dart';
import '../models/dashboard_summary_jukir/dashboard_summary_jukir_model.dart';
import '../models/dashboard_summary_pengawas/dashboard_summary_pengawas_model.dart';
//RENCANA REFACTOR KEDEPAN :
/*
FUNGSI Getdashboard itu satu , baru didalam nya kita logic , role nya apa, 
baru disuapin ambil dari datasource mana , dan nanti return nya ke entitas yang 
juga berhubungan dengan rolenya, akhirnya ini clean tidak ada method satu satu di repository, 
dan Cubit juga bersih , cuma tau panngil loaddashboard summary.
*/

@LazySingleton(as: IHomeRepository)
class HomeRepositoryImpl implements IHomeRepository {
  final ISummaryRemoteDataSource _summaryRemoteDS;
  final ISecureStorageManager _secureStorage;
  final AppPreferences _appPreferences;

  HomeRepositoryImpl(
    this._summaryRemoteDS,
    this._secureStorage,
    this._appPreferences,
  );

  @override
  Future<Either<Failure, DashboardSummaryJukirEntity>>
  getDashboardSummaryJukir({required String nop}) async {
    try {
      final model = await _summaryRemoteDS.getDashboardSummaryJukir(nop: nop);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
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

  // Ini Implement untuk get pendapatan digitial  Role Bapenda.(Home Drawer)
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

  @override
  Future<Either<Failure, DashboardSummaryPengawasEntity>>
  getDashboardSummaryPengawas({
    required String nomorObjek,
    required int shift,
    required String jenis,
  }) async {
    try {
      final model = await _summaryRemoteDS.getDashboardSummaryPengawas(
        nomorObjek: nomorObjek,
        shift: shift,
        jenis: jenis,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Terjadi kesalahan: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> getOpLastUpdate() async {
    try {
      final model = await _summaryRemoteDS.getOpLastUpdate();

      final localDate = await _secureStorage.getOpLastUpdate();

      // sama dengan yang tersimpan
      if (localDate == model.data) {
        return const Right(true);
      }

      // berbeda -> update storage
      await _secureStorage.saveOpLastUpdate(model.data);
      return const Right(false);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Terjadi kesalahan: ${e.toString()}'));
    }
  }

  @override
  String? getNomorObjekPengawasan() =>
      _appPreferences.getNomorObjekPengawasan();

  @override
  ShiftPengawasan? getShiftObjekPengawasan() =>
      _appPreferences.getShiftObjekPengawasan();

  @override
  JenisPengawasan? getJenisObjekPengawasan() =>
      _appPreferences.getJenisObjekPengawasan();
}
