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
  Future<void> initiateQrisPayment(double amount) async {
    emit(PaymentLoading());

    final result = await _generateQrisUseCase.execute(amount: amount);

    if (isClosed) return;

    result.fold((failure) => emit(PaymentError(failure.message)), (qris) {
      emit(PaymentQrisReady(qris));
      _startListeningToSignalR(qris.kodeQris);
    });
  }

  /// 2. Dengarkan Stream SignalR secara Real-Time
  void _startListeningToSignalR(String kodeQris) {
    _statusSubscription?.cancel();

    _statusSubscription = _watchPaymentStatusUseCase
        .execute(kodeQris)
        .listen(
          (status) => _handlePaymentStatus(status),
          onError: (error) {
            if (!isClosed) {
              emit(PaymentError("Koneksi Real-Time terputus: $error"));
            }
          },
        );
  }

  /// 3. Cek Status Manual (Tombol Refresh)
  Future<void> checkStatusManual(String kodeQris) async {
    final result = await _checkPaymentStatusUseCase.execute(kodeQris);

    result.fold((failure) {
      if (!isClosed) emit(PaymentError(failure.message));
    }, (status) => _handlePaymentStatus(status));
  }

  /// 4. Handler status — dengan guard cegah double emit
  void _handlePaymentStatus(PaymentStatus status) {
    if (isClosed) return;

    // FIX: Jangan proses status baru jika sudah final (LUNAS/TIMEOUT)
    // Ini mencegah race condition antara SignalR event terakhir dan cleanup
    if (state is PaymentSuccess || state is PaymentTimeout) return;

    switch (status) {
      case PaymentStatus.lunas:
        emit(const PaymentSuccess("Pembayaran QRIS Berhasil!"));
        _cleanupConnection();
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
        // Tetap menunggu — tidak ubah state
        break;
    }
  }

  /// 5. Cleanup koneksi SignalR dan subscription
  void _cleanupConnection() {
    _statusSubscription?.cancel();
    _statusSubscription = null;
    _stopMonitoringPaymentUseCase.execute();
  }

  @override
  Future<void> close() {
    _cleanupConnection();
    return super.close();
  }
}
