import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/qris_entity.dart';

abstract class IPaymentRepository {
  Future<Either<Failure, QrisEntity>> generateQris({
    required String idTransaksiLokal,
    required String nop,
    required int nominal,
  });

  Future<Either<Failure, Unit>> confirmPayment(String idTransaksi);
}
