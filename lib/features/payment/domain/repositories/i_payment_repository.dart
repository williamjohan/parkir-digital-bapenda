import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/qris_entity.dart';

abstract class IPaymentRepository {
  /// Meminta QRIS ke server, menyimpan status PENDING ke SQLite,
  /// dan mengembalikan Entity berisi Nominal, String QR, dan ID Transaksi.
  Future<Either<Failure, QrisEntity>> generateQrisAndSavePending({
    // [PERBAIKAN]: 'nominal' dihapus karena akan diambil dari Datasource!
    required String platNomor,
    required String kategoriKendaraan,
    required String fotoKendaraan, // Base64
  });

  /// Mengubah status transaksi dari PENDING menjadi PAID di SQLite
  Future<Either<Failure, Unit>> confirmPayment(String idTransaksi);
}
