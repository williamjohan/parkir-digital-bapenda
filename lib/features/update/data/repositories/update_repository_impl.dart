import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/update_entity.dart';
import '../../domain/repositories/i_update_repository.dart';
import '../datasources/update_remote_datasource.dart';

@LazySingleton(as: IUpdateRepository)
class UpdateRepositoryImpl implements IUpdateRepository {
  final IUpdateRemoteDataSource _remoteDataSource;

  UpdateRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, UpdateEntity?>> checkUpdate() async {
    try {
      // 1. Ambil JSON dari Nextcloud
      final data = await _remoteDataSource.fetchUpdateJson();
      final serverBuildNumber =
          int.tryParse(data['buildNumber'].toString()) ?? 0;

      // 2. Ambil versi lokal HP Jukir
      final packageInfo = await PackageInfo.fromPlatform();
      final localBuildNumber = int.tryParse(packageInfo.buildNumber) ?? 0;

      // 3. Bandingkan
      if (serverBuildNumber > localBuildNumber) {
        return Right(
          UpdateEntity(
            versionName: data['versionName'] ?? 'Unknown',
            buildNumber: serverBuildNumber,
            changelog: data['changelog'] ?? '-',
            downloadUrl: data['url'] ?? '',
          ),
        );
      } else {
        return const Right(null); // Aplikasi sudah mutakhir
      }
    } catch (e) {
      return Left(
        ServerFailure("Gagal memeriksa pembaruan. Pastikan internet stabil."),
      );
    }
  }
}
