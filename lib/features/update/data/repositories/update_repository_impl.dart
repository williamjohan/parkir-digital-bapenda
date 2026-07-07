import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
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
      final data = await _remoteDataSource.fetchUpdateJson();

      final serverBuildNumber =
          int.tryParse(data['buildNumber'].toString()) ?? 0;
      return Right(
        UpdateEntity(
          versionName: data['versionName'] ?? 'Unknown',
          buildNumber: serverBuildNumber,
          changelog: data['changelog'] ?? '-',
          downloadUrl: data['url'] ?? '',
          isForceUpdate: data['isForceUpdate'] ?? false,
        ),
      );
    } catch (e) {
      return const Left(
        ServerFailure("Gagal memeriksa pembaruan. Pastikan internet stabil."),
      );
    }
  }
}
