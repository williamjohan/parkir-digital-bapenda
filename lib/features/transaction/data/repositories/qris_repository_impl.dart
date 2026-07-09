import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/storage/i_secure_storage_manager.dart';
import '../../../../core/utils/base64_image_helper.dart';
import '../../domain/entities/qris_entity.dart';
import '../../domain/repositories/i_qris_repository.dart';
import '../datasources/qris_remote_data_source.dart';
import '../models/qris/qris_model.dart';

@LazySingleton(as: IQrisRepository)
class QrisRepositoryImpl implements IQrisRepository {
  final IQrisRemoteDataSource _remoteDataSource;
  final ISecureStorageManager _secureStorage;

  QrisRepositoryImpl(this._remoteDataSource, this._secureStorage);

  @override
  Future<Either<Failure, Unit>> syncQrisToLocal() async {
    try {
      final remoteModels = await _remoteDataSource.getQrisRompi();
      final remoteEntities = remoteModels.map((m) => m.toEntity()).toList();

      final Map<String, QrisLocalModel> localModelsMap = {};

      for (final item in remoteEntities) {
        final jenisKendaraan = JenisKendaraanId.fromInt(item.jenisKendaraanId);

        if (jenisKendaraan != JenisKendaraanId.tidakDiketahui) {
          final filePath = await Base64ImageHelper.saveQrisBase64ToFile(
            jenisKendaraanId: item.jenisKendaraanId,
            base64String: item.qrisImageBase64,
          );
          localModelsMap[item.jenisKendaraanId.toString()] = QrisLocalModel(
            path: filePath,
            kodeQris: item.kodeQris,
          );
        }
      }

      if (localModelsMap.isNotEmpty) {
        final jsonMap = localModelsMap.map(
          (key, model) => MapEntry(key, model.toJson()),
        );
        await _secureStorage.saveQrisMetadata(jsonEncode(jsonMap));
      }

      return const Right(unit);
    } catch (e) {
      if (e is ServerException) return Left(ServerFailure(e.message));
      return Left(ServerFailure('Gagal sinkronisasi QRIS: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Map<String, QrisLocalEntity>>>
  getLocalQrisMetaDatas() async {
    try {
      final localJsonString = await _secureStorage.getQrisMetadata();

      if (localJsonString != null && localJsonString.isNotEmpty) {
        final Map<String, dynamic> decodedMap = jsonDecode(localJsonString);

        final Map<String, QrisLocalEntity> resultEntities = {};

        decodedMap.forEach((key, value) {
          final localModel = QrisLocalModel.fromJson(
            value as Map<String, dynamic>,
          );
          resultEntities[key] = localModel.toEntity();
        });

        return Right(resultEntities);
      }

      return const Left(CacheFailure('Data QRIS belum tersedia.'));
    } catch (_) {
      return const Left(CacheFailure('Gagal membaca data QRIS.'));
    }
  }
}
