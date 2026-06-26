import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../datasources/payment_remote_datasource.dart';
import '../datasources/qris_signalr_datasource.dart';
import '../../domain/entities/payment_status.dart';
import '../../domain/repositories/i_payment_repository.dart';

@LazySingleton(as: IPaymentRepository)
class PaymentRepositoryImpl implements IPaymentRepository {
  final IPaymentRemoteDataSource _remoteDataSource;
  final QrisSignalRDatasource _signalRDataSource;

  PaymentRepositoryImpl(this._remoteDataSource, this._signalRDataSource);

  @override
  Future<Either<Failure, PaymentStatus>> checkStatusManual(
    String kodeQris,
  ) async {
    try {
      final result = await _remoteDataSource.checkQrisCallback(
        kodeQris: kodeQris,
      );
      final statusStr = result['status']?.toString() ?? 'PENDING';
      return Right(PaymentStatus.fromString(statusStr));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<PaymentStatus> watchPaymentStatus(String kodeQris) {
    _signalRDataSource.connectAndJoin(kodeQris).catchError((e) {});

    return _signalRDataSource.qrisStatusStream.map((statusStr) {
      return PaymentStatus.fromString(statusStr);
    });
  }

  @override
  Future<void> stopMonitoring() async {
    await _signalRDataSource.disconnect();
  }
}
