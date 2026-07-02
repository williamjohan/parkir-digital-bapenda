import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/errors/failure.dart';
import '../../data/repositories/absensi_repository_impl.dart';
import '../entities/absensi_entity.dart';

@lazySingleton
class AbsensiUsecase {
  final AbsensiRepositoryImpl _repository;

  AbsensiUsecase(this._repository);

  Future<Either<Failure, void>> postAbsensi(AbsensiEntity absensi) async {
    return await _repository.postAbsensi(absensi);
  }
}
