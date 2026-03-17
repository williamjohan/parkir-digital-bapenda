// lib/features/parking_transaction/data/datasources/i_parking_transaction_local_datasource.dart

import '../models/local_transaction_model.dart';

abstract class IParkingTransactionLocalDataSource {
  /// Memproses kompresi foto 3MB -> 10KB, membuat UUID,
  /// lalu menyimpan data ke SQLite.
  /// Mengembalikan model yang sudah matang untuk dilempar ke UI/Kasir.
  Future<LocalTransactionModel> saveNewTransaction({
    required String platNomor,
    required String kategoriKendaraan,
    required String rawImagePath, // Path foto mentah dari kamera
    required bool
    isFree, // Untuk menentukan status awal (PENDING_PAYMENT atau FREE_PAYMENT)
    required String idJukir,
    required String namaJukir,
    required String nop,
  });

  /// Mengubah status transaksi (misal: dipanggil saat QRIS sukses dibayar)
  /// Status bisa berupa: 'PAID_OFFLINE', 'FREE_OFFLINE', dll.
  Future<void> updateTransactionStatus({
    required String idTransaksiLokal,
    required String newStatus,
  });

  /// Mengambil semua data transaksi yang nyangkut / belum terkirim ke server Bapenda.
  /// Sangat berguna untuk fitur Background Sync / Worker nanti.
  Future<List<LocalTransactionModel>> getUnsyncedTransactions();
}
