import 'package:dartz/dartz.dart';
import '../entities/realisasi_entity.dart';

abstract class RealisasiRepository {
  Future<Either<String, List<RealisasiEntity>>> getRealisasiSeluruhOp({
    required int tahun,
  });
}
