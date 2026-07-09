import 'package:dartz/dartz.dart';
import '../entities/detail_realisasi_op_entity.dart';

abstract class DetailRealisasiOpRepository {
  Future<Either<String, DetailRealisasiOpEntity>> getSummaryRealisasi({
    required String nop,
    required int tahun,
  });
}
