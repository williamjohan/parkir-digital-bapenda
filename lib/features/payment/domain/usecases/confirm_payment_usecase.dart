// lib/features/payment/domain/usecases/confirm_payment_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/i_payment_repository.dart';

@lazySingleton
class ConfirmPaymentUseCase {
  final IPaymentRepository repository;

  ConfirmPaymentUseCase(this.repository);

  Future<Either<Failure, Unit>> execute(String idTransaksi) {
    return repository.confirmPayment(idTransaksi);
  }
}
