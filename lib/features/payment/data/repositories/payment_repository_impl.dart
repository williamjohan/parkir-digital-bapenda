import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/repositories/i_payment_repository.dart';
import '../datasources/qris_signalr_datasource.dart';

@LazySingleton(as: IPaymentRepository)
class PaymentRepositoryImpl implements IPaymentRepository {
  final QrisSignalRDatasource _signalRDatasource;

  PaymentRepositoryImpl(this._signalRDatasource);

  @override
  Future<Either<Failure, Unit>> connectToPaymentStream(String kodeQris) async {
    try {
      await _signalRDatasource.connectAndJoin(kodeQris);
      return const Right(unit);
    } catch (e) {
      // Tangkap kegagalan koneksi awal (misal server down)
      return Left(
        ServerFailure('Gagal terhubung ke server pembayaran: ${e.toString()}'),
      );
    }
  }

  @override
  Stream<String> getPaymentStatusStream() {
    return _signalRDatasource.qrisStatusStream;
  }

  @override
  Future<Either<Failure, Unit>> disconnectPaymentStream() async {
    try {
      await _signalRDatasource.disconnect();
      return const Right(unit);
    } catch (e) {
      return const Left(ServerFailure('Gagal memutus koneksi dengan aman.'));
    }
  }
}
