import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/i_parking_transaction_repository.dart';

@lazySingleton
class UpdateParkingStatusUseCase {
  final IParkingTransactionRepository repository;

  UpdateParkingStatusUseCase(this.repository);

  Future<Either<Failure, Unit>> execute(String idTransaksi, String status) {
    return repository.updateTransactionStatus(
      idTransaksiLokal: idTransaksi,
      newStatus: status,
    );
  }
}
