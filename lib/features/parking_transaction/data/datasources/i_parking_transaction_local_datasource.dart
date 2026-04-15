import '../models/local_transaction_model.dart';

abstract class IParkingTransactionLocalDataSource {
  Future<LocalTransactionModel> saveNewTransaction({
    String? platNomor,
    required String jenisTarif,
    required int nominal,
    required String metodePembayaran,
    String? noKartuKue, // 🚀 TAMBAHKAN INI
    String? rawImagePath,
    required bool isFree,
    required int modePlat,
    required String idJukir,
    required String namaJukir,
    String? latitude,
    String? longitude,
  });

  Future<void> updateTransactionStatus({
    required String idTransaksiLokal,
    required String newStatus,
  });

  Future<void> updateSyncStatus({
    required String idTransaksiLokal,
    required int isSync,
  });

  Future<List<LocalTransactionModel>> getUnsyncedTransactions();
}
