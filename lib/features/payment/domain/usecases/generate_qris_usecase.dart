// lib/features/payment/domain/usecases/generate_qris_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/i_payment_repository.dart';

@lazySingleton
class GenerateQrisUseCase {
  final IPaymentRepository repository;

  GenerateQrisUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> execute({
    required int nominal,
    required String platNomor,
    required String kategoriKendaraan,
    required String fotoKendaraan,
  }) {
    return repository.generateQrisAndSavePending(
      nominal: nominal,
      platNomor: platNomor,
      kategoriKendaraan: kategoriKendaraan,
      fotoKendaraan: fotoKendaraan,
    );
  }
}
