import 'dart:io';
import 'package:injectable/injectable.dart';
import '../../../../core/storage/database_helper.dart';
import '../../../../core/services/image/i_image_service.dart';
import '../../../../core/utils/transaction_id_utils.dart';
import '../models/local_transaction_model.dart';
import 'i_parking_transaction_local_datasource.dart';

@LazySingleton(as: IParkingTransactionLocalDataSource)
class ParkingTransactionLocalDataSourceImpl
    implements IParkingTransactionLocalDataSource {
  final IImageService _imageService;

  ParkingTransactionLocalDataSourceImpl(this._imageService);

  @override
  @override
  Future<LocalTransactionModel> saveNewTransaction({
    String? platNomor,
    required String jenisTarif,
    required int nominal,
    required String metodePembayaran,
    String? noKartuKue, // 🚀 Masuk ke parameter
    String? rawImagePath,
    required bool isFree,
    required int modePlat,
    required String idJukir,
    required String namaJukir,
    String? latitude,
    String? longitude,
  }) async {
    String? finalImagePath;

    if (rawImagePath != null && rawImagePath.trim().isNotEmpty) {
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

    final String safePlat = (platNomor == null || platNomor.trim().isEmpty)
        ? '-'
        : platNomor.trim().toUpperCase();

    final transaction = LocalTransactionModel(
      idTransaksiLokal: TransactionIdUtils.generateOrderId(),
      kategoriKendaraan: jenisTarif,
      nominal: isFree ? 0 : nominal,
      metodePembayaran: metodePembayaran,
      noKartuKue: noKartuKue,
      platNomor: safePlat,
      waktuTransaksi: DateTime.now().toIso8601String(),
      status: isFree ? 'FREE_OFFLINE' : 'PENDING_PAYMENT',
      idJukir: idJukir,
      namaJukir: namaJukir,
      fotoKendaraan: finalImagePath,
      modePlat: modePlat,
      isSync: 0,
      latitude: latitude,
      longitude: longitude,
    );

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

  @override
  Future<void> updateSyncStatus({
    required String idTransaksiLokal,
    required int isSync,
  }) async {
    try {
      // 🚀 [PERBAIKAN RANJAU 1]: Gunakan DatabaseHelper.instance.database
      final db = await DatabaseHelper.instance.database;

      await db.update(
        'transactions', // Pastikan nama tabel ini sesuai dengan yang ada di DatabaseHelper Anda
        {'is_sync': isSync},
        where: 'id_transaksi_lokal = ?',
        whereArgs: [idTransaksiLokal],
      );
    } catch (e) {
      throw Exception('Gagal update status sync: $e');
    }
  }
}
