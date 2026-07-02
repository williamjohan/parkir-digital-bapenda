import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/errors/failure.dart';
import '../entities/absensi_entity.dart';
import '../repositories/i_absensi_repository.dart';

@lazySingleton
class AbsensiUsecase {
  final IAbsensiRepository _repository;

  AbsensiUsecase(this._repository);

  Future<Either<Failure, void>> postAbsensi(AbsensiEntity absensi) async {
    return await _repository.postAbsensi(absensi);
  }
}
