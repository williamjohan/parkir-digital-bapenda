import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/i_device_check_repository.dart';

@lazySingleton
class CheckDeviceReadinessUseCase {
  final IDeviceCheckRepository repository;
  CheckDeviceReadinessUseCase(this.repository);

  /// Mengeksekusi pengecekan kesiapan perangkat
  Future<Either<Failure, bool>> execute() async {
    final playServicesResult = await repository.checkPlayServicesAvailability();

    return playServicesResult.fold(
      (failure) => Left(failure), // Jika terjadi error sistem saat mengecek
      (isAvailable) async {
        if (!isAvailable) {
          return const Left(
            ServerFailure(
              'Google Play Services tidak tersedia. Aplikasi membutuhkan layanan ini untuk fitur pemindai plat nomor.',
            ),
          );
        }
        final storageResult = await repository.checkStorageSufficient();

        return storageResult.fold((failure) => Left(failure), (isSufficient) {
          if (!isSufficient) {
            return const Left(
              CacheFailure(
                'Penyimpanan penuh. Kosongkan sedikit ruang agar fitur kamera dapat bekerja maksimal.',
              ),
            );
          }
          return const Right(true);
        });
      },
    );
  }
}
