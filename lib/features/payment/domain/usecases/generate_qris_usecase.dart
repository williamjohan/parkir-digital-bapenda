import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../entities/qris_entity.dart';
import '../repositories/i_payment_repository.dart';

@lazySingleton
class GenerateQrisUseCase {
  final IPaymentRepository repository;

  GenerateQrisUseCase(this.repository);

  // [PERBAIKAN]: Sesuaikan parameter execute dengan kebutuhan Repository yang baru
  Future<Either<Failure, QrisEntity>> execute({
    required String idTransaksiLokal, // Menerima lemparan ID dari fitur parkir
    required String kategoriKendaraan,
  }) {
    // Teruskan data ke lapisan Repository
    return repository.generateQris(
      idTransaksiLokal: idTransaksiLokal,
      kategoriKendaraan: kategoriKendaraan,
    );
  }
}
