// lib/features/parking_transaction/domain/usecases/save_parking_transaction_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../../data/models/local_transaction_model.dart';
import '../repositories/i_parking_transaction_repository.dart';

@lazySingleton
class SaveParkingTransactionUseCase {
  final IParkingTransactionRepository repository;

  SaveParkingTransactionUseCase(this.repository);

  Future<Either<Failure, LocalTransactionModel>> execute({
    required String platNomor,
    required String kategoriKendaraan,
    required String rawImagePath,
    required bool isFree,
  }) {
    return repository.saveNewTransaction(
      platNomor: platNomor,
      kategoriKendaraan: kategoriKendaraan,
      rawImagePath: rawImagePath,
      isFree: isFree,
    );
  }
}
