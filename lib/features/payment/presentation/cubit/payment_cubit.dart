import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../parking_transaction/domain/usecases/save_parking_transaction_usecase.dart';
import '../../domain/entities/payment_status.dart';
import '../../domain/usecases/check_payment_status_usecase.dart';
import '../../domain/usecases/generate_qris_usecase.dart';
import '../../domain/usecases/stop_monitoring_payment_usecase.dart';
import '../../domain/usecases/watch_payment_status_usecase.dart';
import '../pages/payment_page.dart';
import 'payment_state.dart';

@injectable
class PaymentCubit extends Cubit<PaymentState> {
  final GenerateQrisUseCase _generateQrisUseCase;
  final WatchPaymentStatusUseCase _watchPaymentStatusUseCase;
  final CheckPaymentStatusUseCase _checkPaymentStatusUseCase;
  final StopMonitoringPaymentUseCase _stopMonitoringPaymentUseCase;
  final SaveParkingTransactionUseCase _saveTransactionUseCase;

  StreamSubscription<PaymentStatus>? _statusSubscription;
  PaymentPageArgs? _pendingArgs;
  String? _activeKodeQris;

  PaymentCubit(
    this._generateQrisUseCase,
    this._watchPaymentStatusUseCase,
    this._checkPaymentStatusUseCase,
    this._stopMonitoringPaymentUseCase,
    this._saveTransactionUseCase,
  ) : super(PaymentInitial());

  /// 1. Request QRIS ke API Bapenda (Transaksi Berbayar)
  Future<void> initiateQrisPayment(PaymentPageArgs args) async {
    _pendingArgs = args;
    emit(PaymentLoading());

    final result = await _generateQrisUseCase.execute(
      amount: args.nominal.toDouble(),
    );

    if (isClosed) return;

    result.fold((failure) => emit(PaymentError(failure.message)), (qris) {
      final bytes = base64Decode(qris.qrisBase64);

      _activeKodeQris = qris.kodeQris;
      emit(PaymentQrisReady(qris, bytes));

      _startListeningToSignalR(qris.kodeQris);
    });
  }

  Future<void> processFreePayment(PaymentPageArgs args) async {
    _pendingArgs = args; // 🚀 FIX: Simpan args

    // Langsung lompat ke fase Finalisasi tanpa perlu generate QRIS!
    emit(PaymentSyncing());
    await _finalizeTransaction();
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
              // Abaikan error background agar layar tidak kedip
            }
          },
        );
  }

  /// 3. Cek Status Manual (Tombol Refresh)
  Future<void> checkStatusManual(String kodeQris) async {
    final currentState = state;
    if (currentState is! PaymentQrisReady) return;

    // 🚀 1. Tembakkan sinyal Loading ke UI
    emit(PaymentCheckLoading());

    final result = await _checkPaymentStatusUseCase.execute(kodeQris);

    if (isClosed) return;

    result.fold(
      (failure) {
        emit(PaymentError(failure.message));
        emit(currentState); // 🚀 Bounce: Kembalikan QRIS ke layar
      },
      (status) {
        if (status == PaymentStatus.pending ||
            status == PaymentStatus.idle ||
            status == PaymentStatus.unknown) {
          // 🚀 2. Jika masih PENDING, Tembakkan sinyal Snackbar
          emit(
            const PaymentPendingInfo(
              "Pembayaran belum diselesaikan oleh Customer.",
            ),
          );
          emit(
            currentState,
          ); // 🚀 Bounce: Kembalikan QRIS ke layar agar Timer tidak mati
        } else {
          // 🚀 3. Jika LUNAS/TIMEOUT, amankan QRIS dulu lalu lempar ke handler utama
          emit(currentState);
          _handlePaymentStatus(status);
        }
      },
    );
  }

  /// 4. Handler status
  void _handlePaymentStatus(PaymentStatus status) async {
    if (isClosed || state is PaymentSuccess || state is PaymentTimeout) return;

    switch (status) {
      case PaymentStatus.lunas:
        emit(
          PaymentSyncing(),
        ); // 🚀 1. Ubah UI menjadi Loading "Memproses Transaksi..."
        await _finalizeTransaction();
        break;

      case PaymentStatus.timeout:
        emit(const PaymentTimeout("Waktu pembayaran QRIS habis."));
        _cleanupConnection();
        break;

      case PaymentStatus.error:
        // Filter agar layar tidak hilang
        break;

      case PaymentStatus.pending:
      case PaymentStatus.idle:
      case PaymentStatus.unknown:
        break;
    }
  }

  ///  5. FUNGSI FINALISASI TRANSAKSI (API & SQLite)
  Future<void> _finalizeTransaction() async {
    if (_pendingArgs == null) {
      emit(const PaymentError("Data argumen transaksi hilang."));
      return;
    }

    final isPlatEmpty =
        _pendingArgs!.platNomor.isEmpty || _pendingArgs!.platNomor == '-';
    final modePlat = isPlatEmpty ? 0 : 1;

    // Tentukan metode pembayaran: Jika Rp0 berarti Cash(Gratis), jika bayar berarti QRIS
    final metodeBayar = _pendingArgs!.nominal == 0 ? 'CASH' : 'QRIS';

    // GPS, Profil Jukir, dan IsFree akan otomatis ter-handle di dalam Repository!
    final result = await _saveTransactionUseCase.execute(
      platNomor: _pendingArgs!.platNomor,
      jenisTarif: _pendingArgs!.kategoriKendaraan,
      nominal: _pendingArgs!.nominal,
      metodePembayaran: metodeBayar,
      modePlat: modePlat,
      rawImagePath: null,
      latitude: _pendingArgs!.latitude,
      longitude: _pendingArgs!.longitude,
      noKartueKue: _activeKodeQris,
    );

    if (isClosed) return;

    result.fold(
      (failure) {
        emit(PaymentError("Gagal menyimpan transaksi: ${failure.message}"));
      },
      (savedTransaction) {
        // Emit Sukses beserta object hasil dari Repository agar bisa di-print UI
        emit(PaymentSuccess("Pembayaran Berhasil!", savedTransaction));
        _cleanupConnection();
      },
    );
  }

  /// 6. Cleanup koneksi SignalR
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
