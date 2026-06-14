import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../transaction/domain/usecases/get_local_qris_usecase.dart';

// ── LEGACY IMPORTS — uncomment saat flow lama diaktifkan kembali ─────────────
// import '../../domain/entities/payment_status.dart';
// import '../../domain/usecases/check_payment_status_usecase.dart';
// import '../../domain/usecases/generate_qris_usecase.dart';
// import '../../domain/usecases/stop_monitoring_payment_usecase.dart';
// import '../../domain/usecases/watch_payment_status_usecase.dart';
// import '../../../parking_transaction/domain/usecases/save_parking_transaction_usecase.dart';
// import '../pages/payment_page.dart';

import 'payment_state.dart';

// @injectable = factory → setiap BlocProvider(create:) menghasilkan instance baru.
// Dispose terjadi otomatis saat route di-pop karena BlocProvider ada di router.
@injectable
class PaymentCubit extends Cubit<PaymentState> {
  final GetLocalQrisUseCase _getLocalQrisUseCase;

  // ── LEGACY FIELDS — uncomment saat dibutuhkan ────────────────────────────
  // final GenerateQrisUseCase _generateQrisUseCase;
  // final WatchPaymentStatusUseCase _watchPaymentStatusUseCase;
  // final CheckPaymentStatusUseCase _checkPaymentStatusUseCase;
  // final StopMonitoringPaymentUseCase _stopMonitoringPaymentUseCase;
  // final SaveParkingTransactionUseCase _saveTransactionUseCase;
  // StreamSubscription<PaymentStatus>? _statusSubscription;
  // String? _activeKodeQris;

  PaymentCubit(this._getLocalQrisUseCase) : super(PaymentInitial());

  // ─── LOAD QRIS LOKAL ─────────────────────────────────────────────────────

  Future<void> loadLocalQris(int jenisKendaraanId) async {
    // Guard: jangan emit jika cubit sudah di-dispose
    // (bisa terjadi jika user back sangat cepat sebelum Future selesai)
    if (isClosed) return;

    emit(PaymentLocalQrisLoading());

    final result = await _getLocalQrisUseCase.execute();

    // Guard setelah await — wajib karena cubit bisa saja sudah closed
    // saat user back di tengah operasi async
    if (isClosed) return;

    result.fold(
      (_) => emit(
        const PaymentLocalQrisError(
          'Data QRIS belum tersedia. Pastikan perangkat sudah tersinkronisasi.',
        ),
      ),
      (qrisMap) {
        if (isClosed) return;

        final imagePath = qrisMap[jenisKendaraanId.toString()];

        if (imagePath == null || imagePath.isEmpty) {
          emit(
            const PaymentLocalQrisError(
              'QRIS untuk jenis kendaraan ini tidak ditemukan.',
            ),
          );
          return;
        }

        if (!File(imagePath).existsSync()) {
          emit(
            const PaymentLocalQrisError(
              'File QRIS tidak ditemukan. Coba sinkronisasi ulang.',
            ),
          );
          return;
        }

        emit(PaymentLocalQrisReady(imagePath));

        // TODO: aktifkan SignalR setelah QRIS berhasil ditampilkan
        // _startSignalR(_activeKodeQris!);
      },
    );
  }

  // ─── TODO: SignalR — aktifkan saat backend siap ──────────────────────────

  // void _startSignalR(String kodeQris) {
  //   _statusSubscription?.cancel();
  //   _statusSubscription = _watchPaymentStatusUseCase
  //       .execute(kodeQris)
  //       .listen(
  //         _handlePaymentStatus,
  //         onError: (_) {}, // abaikan error background
  //       );
  // }
  //
  // void _handlePaymentStatus(PaymentStatus status) {
  //   if (isClosed) return;
  //   switch (status) {
  //     case PaymentStatus.lunas:
  //       _stopSignalR();
  //       emit(PaymentSuccess(...));
  //       break;
  //     case PaymentStatus.timeout:
  //       _stopSignalR();
  //       emit(PaymentTimeout(...));
  //       break;
  //     default:
  //       break;
  //   }
  // }
  //
  // void _stopSignalR() {
  //   _statusSubscription?.cancel();
  //   _statusSubscription = null;
  //   _stopMonitoringPaymentUseCase.execute();
  // }

  // ─── DISPOSE ─────────────────────────────────────────────────────────────

  @override
  Future<void> close() {
    // _stopSignalR(); // uncomment saat SignalR aktif
    return super.close();
  }
}
