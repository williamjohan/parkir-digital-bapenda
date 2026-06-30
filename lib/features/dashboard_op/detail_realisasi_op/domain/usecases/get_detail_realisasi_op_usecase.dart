import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../entities/detail_realisasi_op_entity.dart';
import '../repositories/detail_realisasi_op_repository.dart';

@lazySingleton
class GetDetailRealisasiOpUseCase {
  final DetailRealisasiOpRepository _repository;

  GetDetailRealisasiOpUseCase(this._repository);
  Future<Either<String, DetailRealisasiOpEntity>> call({
    required String nop,
    required int tahun,
  }) {
    return _repository.getSummaryRealisasi(nop: nop, tahun: tahun);
  }
}
