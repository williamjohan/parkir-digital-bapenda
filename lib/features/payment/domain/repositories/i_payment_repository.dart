import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/payment_success_entity.dart';

abstract class IPaymentRepository {
  Future<Either<Failure, Unit>> connectToPaymentStream(String kodeQris);
  Stream<Either<Failure, PaymentSuccessEntity>> getPaymentStatusStream();
  Future<Either<Failure, Unit>> disconnectPaymentStream();
}
