import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/repositories/i_device_check_repository.dart';

@LazySingleton(as: IDeviceCheckRepository)
class DeviceCheckRepositoryImpl implements IDeviceCheckRepository {
  DeviceCheckRepositoryImpl();

  @override
  Future<Either<Failure, bool>> checkPlayServicesAvailability() async {
    try {
      AppLogger.info('Memeriksa ketersediaan Google Play Services...');

      await Future.delayed(
        const Duration(seconds: 2),
      ); // Simulasi loading native check
      return const Right(true);
    } catch (e, stackTrace) {
      AppLogger.error('Error saat memeriksa Play Services', e, stackTrace);
      return const Left(
        ServerFailure('Gagal memverifikasi layanan sistem perangkat.'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> checkStorageSufficient() async {
    try {
      AppLogger.info('Memeriksa kapasitas penyimpanan perangkat...');
      await Future.delayed(const Duration(seconds: 1));
      return const Right(true);
    } catch (e, stackTrace) {
      AppLogger.error('Error saat memeriksa penyimpanan', e, stackTrace);
      return const Left(CacheFailure('Gagal mengakses penyimpanan perangkat.'));
    }
  }
}
