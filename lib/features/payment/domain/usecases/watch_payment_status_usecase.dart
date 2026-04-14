import 'package:injectable/injectable.dart';
import '../entities/payment_status.dart';
import '../repositories/i_payment_repository.dart';

@lazySingleton
class WatchPaymentStatusUseCase {
  final IPaymentRepository repository;

  WatchPaymentStatusUseCase(this.repository);

  Stream<PaymentStatus> execute(String kodeQris) {
    return repository.watchPaymentStatus(kodeQris);
  }
}
