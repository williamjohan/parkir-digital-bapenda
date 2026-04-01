// lib/features/parking_transaction/data/datasources/parking_transaction_local_datasource_impl.dart

import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/core/utils/transaction_id_utils.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/storage/database_helper.dart';
import '../../../../core/services/image/i_image_service.dart';
import '../models/local_transaction_model.dart';
import 'i_parking_transaction_local_datasource.dart';

@LazySingleton(as: IParkingTransactionLocalDataSource)
class ParkingTransactionLocalDataSourceImpl
    implements IParkingTransactionLocalDataSource {
  final IImageService _imageService;

  ParkingTransactionLocalDataSourceImpl(this._imageService);

  @override
  Future<LocalTransactionModel> saveNewTransaction({
    String? platNomor,
    required String kategoriKendaraan,
    String? rawImagePath,
    required bool isFree,
    required int modePlat,
    required String idJukir,
    required String namaJukir,
    required String nop,
    String? latitude, // [TAMBAHAN BARU]
    String? longitude, // [TAMBAHAN BARU]
  }) async {
    String? finalImagePath;

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
      await _imageService.deleteImage(rawImagePath);
    }

    final String idTransaksi = TransactionIdUtils.generateOrderId(
      kategoriKendaraan: kategoriKendaraan,
      modePlat: modePlat,
    );
    final String waktuTransaksi = DateTime.now().toIso8601String();

    final String status = isFree ? 'FREE_OFFLINE' : 'PENDING_PAYMENT';

    final bool isMobil = kategoriKendaraan.toLowerCase() == 'mobil';
    final int nominal = isFree ? 0 : (isMobil ? 5000 : 2000);

    // [PERBAIKAN]: Cetak cetakan transaksi yang sudah dilengkapi GPS!
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
      fotoKendaraan: finalImagePath,
      modePlat: modePlat,
      isSync: 0,
      latitude: latitude,
      longitude: longitude,
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
    final List<Map<String, dynamic>> maps = await DatabaseHelper.instance
        .getUnsyncedTransactions();
    return maps.map((map) => LocalTransactionModel.fromJson(map)).toList();
  }
}
