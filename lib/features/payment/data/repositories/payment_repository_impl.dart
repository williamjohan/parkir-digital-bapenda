import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../domain/entities/qris_entity.dart';
import '../../domain/repositories/i_payment_repository.dart';
import '../datasources/payment_remote_datasource.dart';

@LazySingleton(as: IPaymentRepository)
class PaymentRepositoryImpl implements IPaymentRepository {
  final ISecureStorageManager _secureStorage;
  final IPaymentRemoteDataSource _remoteDataSource;

  PaymentRepositoryImpl(this._secureStorage, this._remoteDataSource);

  @override
  Future<Either<Failure, QrisEntity>> generateQris({
    required String idTransaksiLokal,
    required String nop,
    required int nominal,
  }) async {
    try {
      // 1. Ambil data jukir (optional, tergantung kebutuhan BE)
      final jukirProfile = await _secureStorage.getJukirProfile();
      if (jukirProfile == null) {
        return const Left(
          CacheFailure('Data Jukir tidak ditemukan. Silakan login ulang.'),
        );
      }

      // 2. HIT API (pakai nop + nominal)
      final responseMap = await _remoteDataSource.requestQrisData(
        nop: nop,
        nominal: nominal,
      );

      // 3. Parsing response (TANPA ['data'] lagi)
      final int nominalDariServer = responseMap['nominal'] ?? 0;
      final String qrisBase64Server = responseMap['qrisBase64'] ?? '';
      final String qrBase64Server = responseMap['qrBase64'] ?? '';
      final int expTimeMenitServer = responseMap['expTimeMenit'] ?? 0;

      // 4. Return Entity
      return Right(
        QrisEntity(
          idTransaksi: idTransaksiLokal,
          nominal: nominalDariServer,
          qrisBase64: qrisBase64Server,
          qrBase64: qrBase64Server,
          expTimeMenit: expTimeMenitServer,
        ),
      );
    } catch (e) {
      return Left(ServerFailure('Gagal memproses QRIS: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> confirmPayment(String idTransaksi) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return const Right(unit);
    } catch (e) {
      return Left(
        ServerFailure('Gagal mengecek status pembayaran: ${e.toString()}'),
      );
    }
  }
}
