// lib/features/parking_transaction/data/datasources/parking_transaction_local_datasource_impl.dart

import 'dart:io';
import 'package:injectable/injectable.dart';
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
    required String jenisTarif, // 🚀 Sesuai Swagger
    required int nominal, // 🚀 Sesuai Swagger
    required String metodePembayaran, // 🚀 Sesuai Swagger
    String? rawImagePath,
    required bool isFree,
    required String idJukir,
    required String namaJukir,
    required String nop,
    required int modePlat,
    String? latitude,
    String? longitude,
  }) async {
    String? finalImagePath;

    // 🚀 [PERBAIKAN LOGIKA]: Kalau ada foto, langsung kompres
    if (rawImagePath != null && rawImagePath.isNotEmpty) {
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
    }

    // 🚀 [PERBAIKAN UTILS]: Generate manual sementara atau sesuaikan utils Anda nanti
    final String idTransaksi = 'TRX-${DateTime.now().millisecondsSinceEpoch}';
    final String waktuTransaksi = DateTime.now().toIso8601String();
    final String status = isFree
        ? 'FREE_OFFLINE'
        : (metodePembayaran == 'qris' ? 'PENDING_QRIS' : 'PENDING_CARD');

    final transaction = LocalTransactionModel(
      idTransaksiLokal: idTransaksi,
      kategoriKendaraan:
          jenisTarif, // 🚀 [TRIK AMAN]: Map jenisTarif ke kolom kategoriKendaraan lama!
      nominal: isFree ? 0 : nominal, // Harga dinamis dari API
      metodePembayaran:
          metodePembayaran, // 🚀 [SATU-SATUNYA YANG BARU]: Harus ditambahkan ke Model nanti
      platNomor: platNomor ?? 'TANPA PLAT',
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
