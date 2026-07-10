import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/features/transaction/domain/usecases/qris_usecase.dart';
import '../../domain/constant/qris_contants.dart';
import '../../domain/usecases/payment_usecase.dart';
import 'payment_state.dart';

@injectable
class PaymentCubit extends Cubit<PaymentState> {
  final QrisUsecase _qrisUsecase;
  final PaymentUseCase _paymentUsecase;

  //  PERBAIKAN: Gunakan var atau spesifikkan tipenya (bukan String lagi)
  StreamSubscription? _signalRSubscription;

  PaymentCubit(this._qrisUsecase, this._paymentUsecase)
    : super(const PaymentState.initial());

  Future<void> loadQris({
    required int jenisKendaraanId,
    required bool isDemoMode,
  }) async {
    if (isClosed) return;

    emit(const PaymentState.loading());

    if (isDemoMode) {
      final qrisString = QrisDemoConstants.getQrisByVehicleType(
        jenisKendaraanId,
      );
      if (!isClosed) {
        emit(PaymentState.demoQrisReady(rawQrisString: qrisString));
      }
      return;
    }

    final result = await _qrisUsecase.getLocalQris();
    if (isClosed) return;

    result.fold(
      (_) => emit(
        const PaymentState.error(message: 'Data QRIS lokal belum tersedia.'),
      ),
      (qrisMap) async {
        if (isClosed) return;

        final qrisEntity = qrisMap[jenisKendaraanId.toString()];

        if (qrisEntity == null ||
            qrisEntity.path.isEmpty ||
            !File(qrisEntity.path).existsSync()) {
          emit(
            const PaymentState.error(message: 'QRIS / File tidak ditemukan.'),
          );
          return;
        }

        String simulatedKodeQris = qrisEntity.kodeQris;

        // 1. Tampilkan UI
        emit(
          PaymentState.localQrisReady(
            qrisImagePath: qrisEntity.path,
            kodeQris: simulatedKodeQris,
          ),
        );

        // 2. LAYER PERTAHANAN: Evaluasi kelayakan SignalR
        if (simulatedKodeQris.trim().isNotEmpty) {
          await _setupSignalR(qrisEntity.kodeQris);
        } else {
          // Log opsional jika kodeQris kosong
        }
      },
    );
  }

  Future<void> _setupSignalR(String kodeQris) async {
    await _signalRSubscription?.cancel();

    //  PERBAIKAN: Dengarkan stream yang me-return Either
    _signalRSubscription = _paymentUsecase.statusStream.listen((result) {
      if (isClosed) return;

      // Extract isi dari Either
      result.fold(
        (failure) {
          if (failure.message == "TIMEOUT") {
            emit(
              const PaymentState.error(
                message: 'Waktu pembayaran habis (Silahkan Ulangi).',
              ),
            );
          } else {
            emit(PaymentState.error(message: failure.message));
          }
        },
        (ticketData) {
          // 🚀 SUKSES: Lemparkan entity ke UI
          emit(PaymentState.paymentSuccess(ticketData: ticketData));
        },
      );
    });

    // 3. EKSEKUSI CONNECT DENGAN EITHER
    final connectResult = await _paymentUsecase.connect(kodeQris);

    if (isClosed) return;

    connectResult.fold(
      (failure) {
        // Gagal terhubung di awal
        emit(PaymentState.error(message: failure.message));
      },
      (_) {
        // Sukses terhubung, biarkan listener Stream yang bekerja
      },
    );
  }

  @override
  Future<void> close() async {
    await _signalRSubscription?.cancel();
    await _paymentUsecase.disconnect();
    return super.close();
  }
}
