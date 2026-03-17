// lib/features/payment/domain/repositories/i_payment_repository.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/qris_entity.dart';

abstract class IPaymentRepository {
  /// Meminta QRIS ke server dan mengembalikan Entity berisi Nominal, String QR, dan ID Transaksi.
  /// Tidak lagi mengurus penyimpanan SQLite!
  Future<Either<Failure, QrisEntity>> generateQris({
    required String idTransaksiLokal, // Menerima lemparan ID dari fitur parkir
    required String kategoriKendaraan,
  });

  /// Mengecek status pembayaran ke Backend (Bank/Bapenda).
  /// Tidak lagi melakukan update status SQLite secara langsung.
  Future<Either<Failure, Unit>> confirmPayment(String idTransaksi);
}
