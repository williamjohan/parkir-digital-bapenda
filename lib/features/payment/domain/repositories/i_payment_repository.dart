// lib/features/payment/domain/repositories/i_payment_repository.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';

abstract class IPaymentRepository {
  /// Memproses data dari layar Capture, menyimpan status PENDING ke SQLite,
  /// dan mengembalikan ID Transaksi beserta data QRIS (Dummy).
  Future<Either<Failure, Map<String, dynamic>>> generateQrisAndSavePending({
    required int nominal,
    required String platNomor,
    required String kategoriKendaraan,
    required String fotoKendaraan, // Base64
  });

  /// Mengubah status transaksi dari PENDING menjadi PAID di SQLite
  Future<Either<Failure, Unit>> confirmPayment(String idTransaksi);
}
