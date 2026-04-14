import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../entities/payment_status.dart';
import '../repositories/i_payment_repository.dart';

@lazySingleton
class CheckPaymentStatusUseCase {
  final IPaymentRepository repository;

  CheckPaymentStatusUseCase(this.repository);

  Future<Either<Failure, PaymentStatus>> execute(String kodeQris) {
    return repository.checkStatusManual(kodeQris);
  }
}
