import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/payment_success_entity.dart';
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
      return Left(
        ServerFailure('Gagal terhubung ke server pembayaran: ${e.toString()}'),
      );
    }
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

  @override
  Stream<Either<Failure, PaymentSuccessEntity>>
  getPaymentStatusStream() async* {
    await for (final event in _signalRDatasource.qrisStatusStream) {
      if (event.status == "LUNAS") {
        try {
          final payload = event.payload ?? {};

          final entity = PaymentSuccessEntity(
            orderId: payload['orderId']?.toString() ?? '-',
            namaOp: payload['namaOp']?.toString() ?? '-', // Dari BE
            alamatOp: payload['alamatOp']?.toString() ?? '-', // Dari BE
            tanggalTransaksi:
                payload['tanggalTransaksi']?.toString() ??
                DateTime.now().toIso8601String(),
            jenisTarif: payload['jenisTarif']?.toString() ?? '-',
            credit: (double.tryParse(payload['amount']?.toString() ?? '0') ?? 0)
                .toInt(),
            encUrl: payload['neCurl']?.toString() ?? '',
          );

          yield Right(entity);
        } catch (e) {
          // FALLBACK TERAKHIR: Jika terjadi error parsing ekstrem (misal format JSON berubah),
          // TETAP pancarkan Right(Entity) dengan data kosong, agar flow LUNAS tidak putus!
          yield Right(
            PaymentSuccessEntity(
              orderId: '-',
              namaOp: '-',
              alamatOp: '-',
              tanggalTransaksi: DateTime.now().toIso8601String(),
              jenisTarif: '-',
              credit: 0,
              encUrl: '',
            ),
          );
        }
      } else if (event.status == "TIMEOUT") {
        yield const Left(ServerFailure('TIMEOUT'));
      } else if (event.status == "ERROR") {
        yield const Left(ServerFailure('ERROR'));
      }
    }
  }
}
