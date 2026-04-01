// lib/features/parking_transaction/data/datasources/i_parking_transaction_remote_datasource.dart

import '../models/local_transaction_model.dart';

abstract class IParkingTransactionRemoteDataSource {
  /// Mengirim satu transaksi tunggal ke server Bapenda.
  /// Membutuhkan data profil Jukir untuk melengkapi payload (shift, deviceId, gate, dll).
  Future<void> insertTransaction({
    required LocalTransactionModel transaction,
    required Map<String, dynamic> jukirProfile,
  });
}
