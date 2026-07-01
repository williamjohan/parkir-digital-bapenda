//usecase akses repository implement
// stlye usecase fascade , pakai

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../entities/jadwal_entity.dart';
import '../repositories/i_jadwal_repositories.dart';

@lazySingleton
class JadwalUseCase {
  final IJadwalRepository _repository;

  JadwalUseCase(this._repository);

  Future<Either<Failure, List<JadwalEntity>>> getJadwal({
    bool forceRefresh = false,
  }) async {
    return await _repository.getJadwalInfo(forceRefresh: forceRefresh);
  }
}
