import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../entities/qris_entity.dart';
import '../repositories/i_payment_repository.dart';

@lazySingleton
class GenerateQrisUseCase {
  final IPaymentRepository repository;

  GenerateQrisUseCase(this.repository);

  Future<Either<Failure, QrisEntity>> execute({
    required String idTransaksiLokal,
    required String nop,
    required int nominal,
  }) {
    return repository.generateQris(
      idTransaksiLokal: idTransaksiLokal,
      nop: nop,
      nominal: nominal,
    );
  }
}
