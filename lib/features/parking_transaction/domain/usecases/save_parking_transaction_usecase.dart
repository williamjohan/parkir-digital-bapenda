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
    String? platNomor, // [PERBAIKAN]: Opsional
    required String kategoriKendaraan,
    String? rawImagePath, // [PERBAIKAN]: Opsional
    required int modePlat, // [TAMBAHAN]: 0 = Tanpa Plat, 1 = Pakai Plat
  }) {
    return repository.saveNewTransaction(
      platNomor: platNomor,
      kategoriKendaraan: kategoriKendaraan,
      rawImagePath: rawImagePath,
      modePlat: modePlat,
    );
  }
}
