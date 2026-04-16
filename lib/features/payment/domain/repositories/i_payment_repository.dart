import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/qris_entity.dart';
import '../entities/payment_status.dart';

abstract class IPaymentRepository {
  /// REST: Minta data QRIS baru
  Future<Either<Failure, QrisEntity>> generateQris({required double amount});

  /// REST: Cek status manual (Callback Button)
  Future<Either<Failure, PaymentStatus>> checkStatusManual(String kodeQris);

  /// WebSocket: Dengar status real-time dari SignalR
  Stream<PaymentStatus> watchPaymentStatus(String kodeQris);

  /// Tutup koneksi SignalR
  Future<void> stopMonitoring();
}
