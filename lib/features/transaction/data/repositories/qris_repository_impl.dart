import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../../../core/utils/qris_image_helper.dart';
import '../../domain/repositories/i_qris_repository.dart';
import '../datasources/qris_remote_data_source.dart';

@LazySingleton(as: IQrisRepository)
class QrisRepositoryImpl implements IQrisRepository {
  final IQrisRemoteDataSource _remoteDataSource;
  final ISecureStorageManager _secureStorage;

  QrisRepositoryImpl(this._remoteDataSource, this._secureStorage);

  @override
  Future<Either<Failure, Unit>> syncQrisToLocal() async {
    try {
      final remoteData = await _remoteDataSource.getQrisRompi();
      final Map<String, String> qrisPathsMap = {};

      for (final item in remoteData) {
        final jenisKendaraan = JenisKendaraanId.fromInt(item.jenisKendaraanId);

        if (jenisKendaraan != JenisKendaraanId.tidakDiketahui) {
          final filePath = await Base64ImageHelper.saveQrisBase64ToFile(
            jenisKendaraanId: item.jenisKendaraanId,
            base64String: item.qrisImageBase64,
          );
          qrisPathsMap[item.jenisKendaraanId.toString()] = filePath;
        }
      }

      if (qrisPathsMap.isNotEmpty) {
        await _secureStorage.saveQrisImagePaths(jsonEncode(qrisPathsMap));
      }
      return const Right(unit);
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message));
      }
      return Left(ServerFailure('Gagal sinkronisasi QRIS: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Map<String, String>>> getLocalQrisPaths() async {
    try {
      final localJsonString = await _secureStorage.getQrisImagePaths();

      if (localJsonString != null && localJsonString.isNotEmpty) {
        final Map<String, dynamic> decodedMap = jsonDecode(localJsonString);
        final Map<String, String> localPathsMap = decodedMap.map(
          (key, value) => MapEntry(key, value.toString()),
        );
        return Right(localPathsMap);
      }

      return const Left(
        CacheFailure('Data QRIS belum tersedia di memori lokal.'),
      );
    } catch (_) {
      return const Left(
        CacheFailure('Gagal membaca data QRIS dari memori lokal.'),
      );
    }
  }
}
