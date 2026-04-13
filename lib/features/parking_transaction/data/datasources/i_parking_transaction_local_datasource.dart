// lib/features/parking_transaction/data/datasources/i_parking_transaction_local_datasource.dart

import '../models/local_transaction_model.dart';

abstract class IParkingTransactionLocalDataSource {
  Future<LocalTransactionModel> saveNewTransaction({
    String? platNomor,
    required String
    jenisTarif, // 🚀 [SINKRONISASI SWAGGER]: String ("Motor"/"Mobil")
    required int nominal, // 🚀 [SINKRONISASI SWAGGER]: Harga
    required String
    metodePembayaran, // 🚀 [SINKRONISASI SWAGGER]: sof (qris/card)
    String? rawImagePath,
    required bool isFree,
    required int modePlat,
    required String idJukir,
    required String namaJukir,
    required String nop,
    String? latitude,
    String? longitude,
  });

  Future<void> updateTransactionStatus({
    required String idTransaksiLokal,
    required String newStatus,
  });

  Future<List<LocalTransactionModel>> getUnsyncedTransactions();
}
