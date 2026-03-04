// lib/features/init/domain/usecases/check_device_readiness_usecase.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/i_device_check_repository.dart';

class CheckDeviceReadinessUseCase {
  final IDeviceCheckRepository repository;

  // Dependency Injection melalui constructor
  CheckDeviceReadinessUseCase(this.repository);

  /// Mengeksekusi pengecekan kesiapan perangkat
  Future<Either<Failure, bool>> execute() async {
    // 1. Cek ketersediaan Google Play Services
    final playServicesResult = await repository.checkPlayServicesAvailability();

    return playServicesResult.fold(
      (failure) => Left(failure), // Jika terjadi error sistem saat mengecek
      (isAvailable) async {
        if (!isAvailable) {
          // Aturan Bisnis: Jika Play Services tidak ada, kembalikan Failure spesifik
          return const Left(
            ServerFailure(
              'Google Play Services tidak tersedia. Aplikasi membutuhkan layanan ini untuk fitur pemindai plat nomor.',
            ),
          );
        }

        // 2. Cek ketersediaan Storage (Bisa ditambahkan jika model ML belum terdownload)
        final storageResult = await repository.checkStorageSufficient();

        return storageResult.fold((failure) => Left(failure), (isSufficient) {
          if (!isSufficient) {
            return const Left(
              CacheFailure(
                'Penyimpanan penuh. Kosongkan sedikit ruang agar fitur kamera dapat bekerja maksimal.',
              ),
            );
          }

          // Jika semua lolos, kembalikan true (Perangkat Siap)
          return const Right(true);
        });
      },
    );
  }
}
