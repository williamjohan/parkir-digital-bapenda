// lib/features/parking_transaction/data/datasources/i_parking_transaction_local_datasource.dart

import '../models/local_transaction_model.dart';

abstract class IParkingTransactionLocalDataSource {
  /// Memproses kompresi foto 3MB -> 10KB (jika modePlat == 1),
  /// menyertakan koordinat GPS, lalu menyimpan data ke SQLite.
  /// Mengembalikan model yang sudah matang untuk dilempar ke UI/Kasir.
  Future<LocalTransactionModel> saveNewTransaction({
    String? platNomor,
    required String kategoriKendaraan,
    String? rawImagePath,
    required bool isFree,
    required int modePlat,
    required String idJukir,
    required String namaJukir,
    required String nop,
    String? latitude,
    String? longitude,
    String? noKartuKue,
  });

  Future<void> updateTransactionStatus({
    required String idTransaksiLokal,
    required String newStatus,
  });

  Future<List<LocalTransactionModel>> getUnsyncedTransactions();
}
