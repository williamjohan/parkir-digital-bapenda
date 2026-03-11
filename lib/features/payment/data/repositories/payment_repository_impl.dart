// lib/features/payment/data/repositories/payment_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/storage/database_helper.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../domain/repositories/i_payment_repository.dart';
import '../models/local_transaction_model.dart';

@LazySingleton(as: IPaymentRepository)
class PaymentRepositoryImpl implements IPaymentRepository {
  final ISecureStorageManager _secureStorage;
  // DatabaseHelper kita panggil via Singleton instance yang sudah Anda buat

  PaymentRepositoryImpl(this._secureStorage);

  @override
  Future<Either<Failure, Map<String, dynamic>>> generateQrisAndSavePending({
    required int nominal,
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

      // 2. Buat ID Unik dan Waktu Saat Ini
      final String idTransaksi = const Uuid().v4();
      final String waktuTransaksi = DateTime.now().toIso8601String();

      // 3. Rakit Entitas Transaksi
      final transaction = LocalTransactionModel(
        idTransaksiLokal: idTransaksi,
        nominal: nominal,
        platNomor: platNomor,
        kategoriKendaraan: kategoriKendaraan,
        waktuTransaksi: waktuTransaksi,
        status: 'PENDING', // Sandiwara dimulai: Uang belum masuk!
        idJukir: jukirProfile['id_jukir'] ?? '',
        namaJukir: jukirProfile['nama'] ?? '',
        nop: jukirProfile['nop'] ?? '',
        fotoKendaraan: fotoKendaraan,
      );

      // 4. Simpan ke Pabrik Data (SQLite)
      await DatabaseHelper.instance.insertTransaction(transaction.toJson());

      // 5. Kembalikan data untuk dirender oleh UI (Layar QRIS)
      // Di dunia nyata, Anda akan fetch API Backend di sini untuk dapat QRIS Dinamis Asli
      return Right({
        'id_transaksi': idTransaksi,
        'qris_data':
            '00020101021126670016COM.NOBUBANK.WWW01189360050300000879140214...DUMMY_QRIS_STRING_BAPENDA',
      });
    } catch (e) {
      return Left(
        ServerFailure('Gagal menyimpan transaksi lokal: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> confirmPayment(String idTransaksi) async {
    try {
      // Jukir klik tombol "OK/Selesai" di layar, transaksi disahkan!
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
