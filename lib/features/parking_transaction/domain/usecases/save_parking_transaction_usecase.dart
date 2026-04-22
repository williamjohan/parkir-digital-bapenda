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
    String? platNomor,
    required String jenisTarif,
    required int nominal,
    required int modePlat,
    required String metodePembayaran,
    String? rawImagePath,
    String? latitude,
    String? longitude,
    String? noKartueKue,
  }) async {
    try {
      return await repository.saveNewTransaction(
        platNomor: platNomor,
        jenisTarif: jenisTarif,
        nominal: nominal,
        modePlat: modePlat,
        metodePembayaran: metodePembayaran,
        rawImagePath: rawImagePath,
        latitude: latitude ?? '0',
        longitude: longitude ?? '0',
        noKartuKue: noKartueKue,
      );
    } catch (e) {
      final cleanMessage = e.toString().replaceAll('Exception: ', '');
      return Left(DatabaseFailure(cleanMessage));
    }
  }
}
