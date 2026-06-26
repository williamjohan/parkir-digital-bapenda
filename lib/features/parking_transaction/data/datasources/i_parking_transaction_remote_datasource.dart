import '../models/local_transaction_model.dart';

abstract class IParkingTransactionRemoteDataSource {
  Future<void> insertTransaction({
    required LocalTransactionModel transaction,
    required Map<String, dynamic> jukirProfile,
  });
}
