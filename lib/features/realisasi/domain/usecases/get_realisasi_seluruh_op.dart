import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../entities/realisasi_entity.dart';
import '../repositories/realisasi_repository.dart';

@injectable
class GetRealisasiSeluruhOpUseCase {
  final RealisasiRepository repository;

  GetRealisasiSeluruhOpUseCase(this.repository);

  Future<Either<String, List<RealisasiEntity>>> execute(int tahun) {
    return repository.getRealisasiSeluruhOp(tahun: tahun);
  }
}
