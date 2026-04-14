import 'package:injectable/injectable.dart';
import '../repositories/i_payment_repository.dart';

@lazySingleton
class StopMonitoringPaymentUseCase {
  final IPaymentRepository repository;

  StopMonitoringPaymentUseCase(this.repository);

  Future<void> execute() {
    return repository.stopMonitoring();
  }
}
