import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/storage/database_helper.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../domain/repositories/i_payment_repository.dart';
import '../../domain/entities/qris_entity.dart';
import '../models/local_transaction_model.dart';
import '../datasources/payment_remote_datasource.dart'; // Import Datasource Anda

@LazySingleton(as: IPaymentRepository)
class PaymentRepositoryImpl implements IPaymentRepository {
  final ISecureStorageManager _secureStorage;
  // [PERBAIKAN]: Inject Datasource ke dalam Repository
  final IPaymentRemoteDataSource _remoteDataSource;

  PaymentRepositoryImpl(this._secureStorage, this._remoteDataSource);

  @override
  Future<Either<Failure, QrisEntity>> generateQrisAndSavePending({
    required String platNomor,
    required String kategoriKendaraan,
    required String fotoKendaraan,
  }) async {
    try {
      // 1. Ambil Identitas Jukir dari Brankas
      final jukirProfile = await _secureStorage.getJukirProfile();
      if (jukirProfile == null) {
        return const Left(
          CacheFailure('Data Jukir tidak ditemukan. Silakan login ulang.'),
        );
      }

      // 2. HIT API (Minta Tarif dan QR ke Backend via Datasource)
      // Jika Backend error, proses akan terlempar ke blok catch
      final responseMap = await _remoteDataSource.requestQrisData(
        kategoriKendaraan,
      );

      final int nominalDariServer = responseMap['data']['nominal'];
      final String qrStringDariServer = responseMap['data']['qr_string'];

      // 3. Buat ID Unik dan Waktu Saat Ini
      final String idTransaksi = const Uuid().v4();
      final String waktuTransaksi = DateTime.now().toIso8601String();

      // 4. Rakit Entitas Transaksi untuk SQLite
      final transaction = LocalTransactionModel(
        idTransaksiLokal: idTransaksi,
        nominal: nominalDariServer, // Gunakan nominal dari server!
        platNomor: platNomor,
        kategoriKendaraan: kategoriKendaraan,
        waktuTransaksi: waktuTransaksi,
        status: 'PENDING',
        idJukir: jukirProfile['id_jukir'] ?? '',
        namaJukir: jukirProfile['nama'] ?? '',
        nop: jukirProfile['nop'] ?? '',
        fotoKendaraan: fotoKendaraan,
      );

      // 5. Simpan ke Pabrik Data (SQLite)
      await DatabaseHelper.instance.insertTransaction(transaction.toJson());

      // 6. Kembalikan Entity Murni ke UseCase/Cubit
      return Right(
        QrisEntity(
          idTransaksi: idTransaksi,
          nominal: nominalDariServer,
          qrString: qrStringDariServer,
        ),
      );
    } catch (e) {
      return Left(ServerFailure('Gagal memproses transaksi: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> confirmPayment(String idTransaksi) async {
    try {
      await DatabaseHelper.instance.updateTransactionStatus(
        idTransaksi,
        'PAID',
      );
      return const Right(unit);
    } catch (e) {
      return Left(
        ServerFailure('Gagal memperbarui status transaksi: ${e.toString()}'),
      );
    }
  }
}
