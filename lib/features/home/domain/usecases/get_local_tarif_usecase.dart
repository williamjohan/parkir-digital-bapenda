// lib/features/home/domain/usecases/get_local_tarif_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../../data/models/tarif_model.dart'; // Sesuaikan path model Anda
import '../repositories/i_home_repository.dart';

@lazySingleton
class GetLocalTarifUseCase {
  final IHomeRepository repository;

  GetLocalTarifUseCase(this.repository);

  Future<Either<Failure, List<TarifModel>>> execute() {
    // Meminta daftar tarif dari penyimpanan lokal (SQLite)
    return repository.getLocalTarifs();
  }
}
