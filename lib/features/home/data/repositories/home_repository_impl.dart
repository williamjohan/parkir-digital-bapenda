import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/storage/database_helper.dart';
import '../../domain/repositories/i_home_repository.dart';

@LazySingleton(as: IHomeRepository)
class HomeRepositoryImpl implements IHomeRepository {
  // Tidak perlu inject DatabaseHelper karena Anda menggunakan Singleton instance-nya,
  // tapi dalam arsitektur yang sangat ketat, DatabaseHelper sebaiknya di-inject juga.

  @override
  Future<Either<Failure, Map<String, int>>> getDailyVehicleCount() async {
    try {
      final counts = await DatabaseHelper.instance.getDailyVehicleCount();
      return Right(counts);
    } catch (e) {
      return Left(CacheFailure('Gagal memuat data dashboard: ${e.toString()}'));
    }
  }
}
