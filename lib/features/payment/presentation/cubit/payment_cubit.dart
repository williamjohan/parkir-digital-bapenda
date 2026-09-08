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
    bool isRetryFetch =
        false, // 🚀 TAMBAHAN: Flag untuk mencegah infinite loop auto-sync
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

    await result.fold(
      (failure) async {
        // 🚀 SELF-HEALING 1: Jika data lokal tidak ada, paksa sync dari API!
        if (!isRetryFetch) {
          await _forceSyncAndReload(jenisKendaraanId, isDemoMode);
        } else {
          emit(
            const PaymentState.error(
              message: 'Gagal mengunduh data QRIS. Pastikan internet stabil.',
            ),
          );
        }
      },
      (qrisMap) async {
        if (isClosed) return;

        final qrisEntity = qrisMap[jenisKendaraanId.toString()];

        // 🚀 SELF-HEALING 2: Jika data ada di Storage, tapi file gambar fisik terhapus oleh OS HP
        if (qrisEntity == null ||
            qrisEntity.path.isEmpty ||
            !File(qrisEntity.path).existsSync()) {
          if (!isRetryFetch) {
            await _forceSyncAndReload(jenisKendaraanId, isDemoMode);
            return;
          }
          emit(
            const PaymentState.error(
              message: 'File gambar QRIS rusak atau hilang.',
            ),
          );
          return;
        }

        String simulatedKodeQris = qrisEntity.kodeQris;

        emit(
          PaymentState.localQrisReady(
            qrisImagePath: qrisEntity.path,
            kodeQris: simulatedKodeQris,
          ),
        );

        if (simulatedKodeQris.trim().isNotEmpty) {
          await _setupSignalR(qrisEntity.kodeQris);
        }
      },
    );
  }

  // 🚀 FUNGSI BANTUAN UNTUK AUTO-SYNC
  Future<void> _forceSyncAndReload(
    int jenisKendaraanId,
    bool isDemoMode,
  ) async {
    final syncResult = await _qrisUsecase.syncQris();

    if (isClosed) return;

    syncResult.fold(
      (failure) {
        emit(PaymentState.error(message: 'Koneksi gagal: ${failure.message}'));
      },
      (_) async {
        // Jika sync berhasil, panggil loadQris lagi (baca dari lokal) dengan flag true
        await loadQris(
          jenisKendaraanId: jenisKendaraanId,
          isDemoMode: isDemoMode,
          isRetryFetch: true,
        );
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
