import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';

abstract class IPaymentRepository {
  Future<Either<Failure, Unit>> connectToPaymentStream(String kodeQris);
  Stream<String> getPaymentStatusStream();
  Future<Either<Failure, Unit>> disconnectPaymentStream();
}
