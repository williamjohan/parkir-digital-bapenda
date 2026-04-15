import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/payment_status.dart';
import '../../domain/usecases/check_payment_status_usecase.dart';
import '../../domain/usecases/generate_qris_usecase.dart';
import '../../domain/usecases/stop_monitoring_payment_usecase.dart';
import '../../domain/usecases/watch_payment_status_usecase.dart';
import 'payment_state.dart';

@injectable
class PaymentCubit extends Cubit<PaymentState> {
  final GenerateQrisUseCase _generateQrisUseCase;
  final WatchPaymentStatusUseCase _watchPaymentStatusUseCase;
  final CheckPaymentStatusUseCase _checkPaymentStatusUseCase;
  final StopMonitoringPaymentUseCase _stopMonitoringPaymentUseCase;

  StreamSubscription<PaymentStatus>? _statusSubscription;

  PaymentCubit(
    this._generateQrisUseCase,
    this._watchPaymentStatusUseCase,
    this._checkPaymentStatusUseCase,
    this._stopMonitoringPaymentUseCase,
  ) : super(PaymentInitial());

  /// 1. Request QRIS ke API Bapenda
  Future<void> initiateQrisPayment(String nop, double amount) async {
    emit(PaymentLoading());

    final result = await _generateQrisUseCase.execute(nop: nop, amount: amount);

    if (isClosed) return;

    result.fold((failure) => emit(PaymentError(failure.message)), (qris) {
      emit(PaymentQrisReady(qris));
      // 🚀 Begitu QRIS sukses di-generate, langsung nyalakan radar SignalR!
      _startListeningToSignalR(qris.kodeQris);
    });
  }

  /// 2. Dengarkan Stream SignalR secara Real-Time
  void _startListeningToSignalR(String kodeQris) {
    // Pastikan subscription lama dibersihkan dulu
    _statusSubscription?.cancel();

    _statusSubscription = _watchPaymentStatusUseCase
        .execute(kodeQris)
        .listen(
          (status) {
            _handlePaymentStatus(status);
          },
          onError: (error) {
            emit(PaymentError("Koneksi Real-Time terputus: $error"));
          },
        );
  }

  /// 3. Cek Status Manual (Untuk Tombol Refresh)
  Future<void> checkStatusManual(String kodeQris) async {
    // Jangan ubah state jadi loading agar QR code tidak hilang berkedip di UI
    final result = await _checkPaymentStatusUseCase.execute(kodeQris);

    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (status) => _handlePaymentStatus(status),
    );
  }

  /// 4. Otak Penerjemah Status
  void _handlePaymentStatus(PaymentStatus status) {
    if (isClosed) return; // Cegah crash jika halaman sudah ditutup

    switch (status) {
      case PaymentStatus.lunas:
        emit(const PaymentSuccess("Pembayaran QRIS Berhasil!"));
        _cleanupConnection(); // 🚀 Lunas = Tutup koneksi agar hemat RAM!
        break;
      case PaymentStatus.timeout:
        emit(const PaymentTimeout("Waktu pembayaran QRIS habis."));
        _cleanupConnection();
        break;
      case PaymentStatus.error:
        emit(const PaymentError("Terjadi kesalahan pada sistem pembayaran."));
        break;
      case PaymentStatus.pending:
      case PaymentStatus.idle:
      case PaymentStatus.unknown:
        // Tetap di state QrisReady (diam saja menunggu pengendara bayar)
        break;
    }
  }

  /// 5. Pembersih Memori (Sanitation)
  void _cleanupConnection() {
    _statusSubscription?.cancel();
    _stopMonitoringPaymentUseCase.execute();
  }

  /// 🚀 DIPANGGIL OTOMATIS OLEH FLUTTER SAAT PINDAH HALAMAN
  @override
  Future<void> close() {
    _cleanupConnection();
    return super.close();
  }
}
