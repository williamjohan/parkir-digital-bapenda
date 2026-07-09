import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/i_payment_repository.dart';

@injectable
class PaymentUseCase {
  final IPaymentRepository _repository;

  PaymentUseCase(this._repository);

  Future<Either<Failure, Unit>> connect(String kodeQris) {
    return _repository.connectToPaymentStream(kodeQris);
  }

  Stream<String> get statusStream {
    return _repository.getPaymentStatusStream();
  }

  Future<Either<Failure, Unit>> disconnect() {
    return _repository.disconnectPaymentStream();
  }
}
