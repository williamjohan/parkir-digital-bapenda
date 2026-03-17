// lib/features/parking_transaction/data/datasources/parking_transaction_local_datasource_impl.dart

import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/storage/database_helper.dart';
import '../../../../core/services/image/i_image_service.dart';
import '../models/local_transaction_model.dart';
import 'i_parking_transaction_local_datasource.dart';

@LazySingleton(as: IParkingTransactionLocalDataSource)
class ParkingTransactionLocalDataSourceImpl
    implements IParkingTransactionLocalDataSource {
  final IImageService _imageService;

  // [INJEKSI]: Kita memasukkan layanan gambar ke jantung Data Source
  ParkingTransactionLocalDataSourceImpl(this._imageService);

  @override
  Future<LocalTransactionModel> saveNewTransaction({
    required String platNomor,
    required String kategoriKendaraan,
    required String rawImagePath,
    required bool isFree,
    required String idJukir,
    required String namaJukir,
    required String nop,
  }) async {
    // 1. KOMPRESI FOTO (Mesin Pres 3MB -> 10KB)
    final String fileName = 'parkir_${DateTime.now().millisecondsSinceEpoch}';
    final String? compressedImagePath = await _imageService
        .compressAndSaveImage(
          originalFile: File(rawImagePath),
          fileName: fileName,
        );

    if (compressedImagePath == null) {
      throw Exception(
        'Gagal mengompresi foto kendaraan. Memori mungkin penuh.',
      );
    }

    // 2. EKSEKUSI MATI FOTO MENTAH (Mencegah Memory Leak HP Jukir!)
    await _imageService.deleteImage(rawImagePath);

    // 3. GENERATE IDENTITAS TRANSAKSI
    final String idTransaksi = const Uuid().v4();
    final String waktuTransaksi = DateTime.now().toIso8601String();

    // [KESEPAKATAN ARSITEKTUR]: Penentuan Status Awal
    final String status = isFree ? 'FREE_PAYMENT' : 'PENDING_PAYMENT';

    // Penentuan Nominal Lokal (Sebagai cadangan jika API lama)
    final bool isMobil = kategoriKendaraan.toLowerCase() == 'mobil';
    final int nominal = isFree ? 0 : (isMobil ? 5000 : 2000);

    // 4. RAKIT MODEL TRANSAKSI
    final transaction = LocalTransactionModel(
      idTransaksiLokal: idTransaksi,
      nominal: nominal,
      platNomor: platNomor,
      kategoriKendaraan: kategoriKendaraan,
      waktuTransaksi: waktuTransaksi,
      status: status,
      idJukir: idJukir,
      namaJukir: namaJukir,
      nop: nop,
      fotoKendaraan: compressedImagePath, // Gunakan path 10KB!
    );

    // 5. SIMPAN KE BUKU KAS (SQLite)
    await DatabaseHelper.instance.insertTransaction(transaction.toJson());

    // 6. KEMBALIKAN DATA MATANG KE REPOSITORY
    return transaction;
  }

  @override
  Future<void> updateTransactionStatus({
    required String idTransaksiLokal,
    required String newStatus,
  }) async {
    await DatabaseHelper.instance.updateTransactionStatus(
      idTransaksiLokal,
      newStatus,
    );
  }

  @override
  Future<List<LocalTransactionModel>> getUnsyncedTransactions() async {
    // [PERBAIKAN]: Memanggil method getUnsyncedTransactions() yang ada di DatabaseHelper
    final List<Map<String, dynamic>> maps = await DatabaseHelper.instance
        .getUnsyncedTransactions();

    return maps.map((map) => LocalTransactionModel.fromJson(map)).toList();
  }
}
