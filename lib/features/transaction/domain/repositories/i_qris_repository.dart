import 'package:dartz/dartz.dart';
import 'package:parkir_digital_bapenda/features/transaction/domain/entities/qris_entity.dart';
import '../../../../core/errors/failure.dart';

abstract class IQrisRepository {
  /// Dipanggil saat App Load / Dashboard untuk menyinkronkan data API ke Storage
  Future<Either<Failure, Unit>> syncQrisToLocal();

  /// Dipanggil di halaman Transaksi untuk membaca path gambar secara instan
  Future<Either<Failure, Map<String, QrisLocalEntity>>> getLocalQrisMetaDatas();
}
