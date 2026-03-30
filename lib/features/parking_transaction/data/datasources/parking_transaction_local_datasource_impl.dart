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
    String? platNomor, // [PERBAIKAN]
    required String kategoriKendaraan,
    String? rawImagePath, // [PERBAIKAN]
    required bool isFree,
    required int modePlat, // [TAMBAHAN]
    required String idJukir,
    required String namaJukir,
    required String nop,
  }) async {
    String? finalImagePath;

    // [PERBAIKAN LOGIKA]: Hanya kompres foto jika Pakai Plat (modePlat == 1)
    if (modePlat == 1 && rawImagePath != null && rawImagePath.isNotEmpty) {
      final String fileName = 'parkir_${DateTime.now().millisecondsSinceEpoch}';
      finalImagePath = await _imageService.compressAndSaveImage(
        originalFile: File(rawImagePath),
        fileName: fileName,
      );

      if (finalImagePath == null) {
        throw Exception(
          'Gagal mengompresi foto kendaraan. Memori mungkin penuh.',
        );
      }
      // EKSEKUSI MATI FOTO MENTAH
      await _imageService.deleteImage(rawImagePath);
    }

    final String idTransaksi = const Uuid().v4();
    final String waktuTransaksi = DateTime.now().toIso8601String();

    // Sesuai The Free Parking Rule
    final String status = isFree ? 'FREE_OFFLINE' : 'PENDING_PAYMENT';

    final bool isMobil = kategoriKendaraan.toLowerCase() == 'mobil';
    final int nominal = isFree ? 0 : (isMobil ? 5000 : 2000);

    // RAKIT MODEL TRANSAKSI LOKAL
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
      fotoKendaraan: finalImagePath, // Bisa berupa string path atau null
      modePlat: modePlat, // Masukkan dari parameter
      isSync: 0, // [DEFAULT]: 0 karena baru dibuat dan belum di-upload
    );

    // SIMPAN KE SQLite
    await DatabaseHelper.instance.insertTransaction(transaction.toJson());

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
