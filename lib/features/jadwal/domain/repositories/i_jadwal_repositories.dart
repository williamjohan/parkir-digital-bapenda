import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/jadwal_entity.dart';

abstract class IJadwalRepository {
  Future<Either<Failure, List<JadwalEntity>>> getJadwalInfo({
    bool forceRefresh = false,
  });
}
