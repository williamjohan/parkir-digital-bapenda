import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/errors/failure.dart';
import '../../data/repositories/absensi_repository_impl.dart';
import '../entities/absensi_entity.dart';

@lazySingleton
class AbsensiUsecase {
  final AbsensiRepositoryImpl _repository;

  AbsensiUsecase(this._repository);

  Future<Either<Failure, AbsensiEntity>> getAbsensiHariIni() {
    return _repository.getAbsensiHariIni();
  }

  Future<Either<Failure, AbsensiEntity>> submitAbsensi(AbsensiEntity data) {
    return _repository.submitAbsensi(data);
  }
}
