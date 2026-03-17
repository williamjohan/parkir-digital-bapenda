import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../domain/repositories/i_payment_repository.dart';
import '../../domain/entities/qris_entity.dart';
import '../datasources/payment_remote_datasource.dart';

@LazySingleton(as: IPaymentRepository)
class PaymentRepositoryImpl implements IPaymentRepository {
  final ISecureStorageManager _secureStorage;
  final IPaymentRemoteDataSource _remoteDataSource;

  PaymentRepositoryImpl(this._secureStorage, this._remoteDataSource);

  @override
  Future<Either<Failure, QrisEntity>> generateQris({
    required String idTransaksiLokal,
    required String kategoriKendaraan,
  }) async {
    try {
      // 1. Ambil Identitas Jukir dari Brankas (Bisa dipakai untuk payload API nanti)
      final jukirProfile = await _secureStorage.getJukirProfile();
      if (jukirProfile == null) {
        return const Left(
          CacheFailure('Data Jukir tidak ditemukan. Silakan login ulang.'),
        );
      }

      // 2. HIT API (Minta Tarif dan QR ke Backend via Datasource)
      final responseMap = await _remoteDataSource.requestQrisData(
        kategoriKendaraan,
      );

      final int nominalDariServer = responseMap['data']['nominal'];
      final String qrStringDariServer = responseMap['data']['qr_string'];

      // 3. Kembalikan Entity Murni
      // Kita langsung tempelkan idTransaksiLokal yang dilempar dari fitur parkir
      return Right(
        QrisEntity(
          idTransaksi: idTransaksiLokal,
          nominal: nominalDariServer,
          qrString: qrStringDariServer,
        ),
      );
    } catch (e) {
      return Left(ServerFailure('Gagal memproses QRIS: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> confirmPayment(String idTransaksi) async {
    try {
      // Logika di sini murni HANYA menembak API Bapenda untuk cek mutasi QRIS.
      // Tidak ada lagi intervensi ke SQLite (DatabaseHelper)!

      // Simulasi latency jaringan
      await Future.delayed(const Duration(seconds: 1));

      return const Right(unit);
    } catch (e) {
      return Left(
        ServerFailure('Gagal mengecek status pembayaran: ${e.toString()}'),
      );
    }
  }
}
