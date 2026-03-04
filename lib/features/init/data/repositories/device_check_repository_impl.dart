// lib/features/init/data/repositories/device_check_repository_impl.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/repositories/i_device_check_repository.dart';

class DeviceCheckRepositoryImpl implements IDeviceCheckRepository {
  // Constructor, nantinya bisa untuk inject Local/Remote Datasource jika butuh
  DeviceCheckRepositoryImpl();

  @override
  Future<Either<Failure, bool>> checkPlayServicesAvailability() async {
    try {
      AppLogger.info('Memeriksa ketersediaan Google Play Services...');
      //TODO: Implementasi pengecekan Play Services yang sebenarnya menggunakan package seperti 'google_api_availability'.
      // CATATAN ARSITEK:
      // Untuk implementasi native sungguhan, biasanya kita butuh package 'google_api_availability'.
      // Agar flow arsitektur kita tidak terblokir error dependency saat ini,
      // kita buat simulasi proses (mock) yang mengembalikan nilai true.
      // Clean Architecture memungkinkan kita men-swap logic ini kapan saja tanpa merusak UI/Domain.

      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulasi loading native check

      // Jika berhasil/tersedia
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

      // Simulasi pengecekan storage
      await Future.delayed(const Duration(seconds: 1));

      // Jika storage cukup
      return const Right(true);
    } catch (e, stackTrace) {
      AppLogger.error('Error saat memeriksa penyimpanan', e, stackTrace);
      return const Left(CacheFailure('Gagal mengakses penyimpanan perangkat.'));
    }
  }
}
