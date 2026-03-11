// lib/features/payment/domain/usecases/generate_qris_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../entities/qris_entity.dart';
import '../repositories/i_payment_repository.dart';

@lazySingleton
class GenerateQrisUseCase {
  final IPaymentRepository repository;

  GenerateQrisUseCase(this.repository);

  // [PERBAIKAN]: Sesuaikan parameter execute dengan kebutuhan Repository
  Future<Either<Failure, QrisEntity>> execute({
    required String platNomor,
    required String kategoriKendaraan,
    required String fotoKendaraan,
  }) {
    // Teruskan semua data ke lapisan Repository
    return repository.generateQrisAndSavePending(
      platNomor: platNomor,
      kategoriKendaraan: kategoriKendaraan,
      fotoKendaraan: fotoKendaraan,
    );
  }
}
