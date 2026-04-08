import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/usecases/confirm_payment_usecase.dart';
import '../../domain/usecases/generate_qris_usecase.dart';
import 'payment_state.dart';

@injectable
class PaymentCubit extends Cubit<PaymentState> {
  final GenerateQrisUseCase _generateQrisUseCase;
  final ConfirmPaymentUseCase _confirmPaymentUseCase;
  final _secureStorage = locator<ISecureStorageManager>();

  Map<String, dynamic>? _cachedProfile;

  PaymentCubit(this._generateQrisUseCase, this._confirmPaymentUseCase)
    : super(PaymentInitial());

  // PaymentCubit(this._generateQrisUseCase, this._confirmPaymentUseCase)
  //   : super(PaymentInitial()) {
  //   getProfile();
  // }

  Future<void> generateQris({
    required String idTransaksiLokal,
    required int nominal,
  }) async {
    emit(PaymentInitial()); // 🔥 reset state lama
    emit(PaymentLoading());

    _cachedProfile ??= await _secureStorage.getJukirProfile();

    if (_cachedProfile == null) {
      if (!isClosed) {
        emit(const PaymentFailure('Profile tidak ditemukan'));
      }
      return;
    }

    final result = await _generateQrisUseCase.execute(
      idTransaksiLokal: idTransaksiLokal,
      nop: _cachedProfile!['nop'],
      nominal: nominal,
    );

    result.fold(
      (failure) {
        if (!isClosed) emit(PaymentFailure(failure.message));
      },
      (qrisEntity) {
        if (!isClosed) {
          emit(
            PaymentQrisGenerated(
              idTransaksi: qrisEntity.idTransaksi,
              qrBase64: qrisEntity.qrBase64,
              qrisBase64: qrisEntity.qrisBase64,
              nominal: qrisEntity.nominal,
              expTimeMenit: qrisEntity.expTimeMenit,
              profile: _cachedProfile,
            ),
          );
        }
      },
    );
  }

  Future<void> generateQris2({
    required String idTransaksiLokal,
    required String jenisKendaraan,
  }) async {
    emit(PaymentInitial());
    emit(PaymentLoading());

    _cachedProfile ??= await _secureStorage.getJukirProfile();

    if (_cachedProfile == null) {
      if (!isClosed) {
        emit(const PaymentFailure('Profile tidak ditemukan'));
      }
      return;
    }

    int finalNominal = 0;

    try {
      // 🔥 PERBAIKAN: Pastikan tarifParkirs di-parse dengan benar
      dynamic tarifListRaw = _cachedProfile!['tarifParkirs'];
      List tarifList = [];

      if (tarifListRaw is List) {
        tarifList = tarifListRaw;
      } else if (tarifListRaw is String) {
        // Jika masih string, coba parse JSON
        tarifList = jsonDecode(tarifListRaw);
      }

      AppLogger.debug('Tarif list: $tarifList');
      AppLogger.debug('Mencari jenis kendaraan: $jenisKendaraan');

      // 🔥 PERBAIKAN: Case-insensitive comparison dengan trim
      final tarif = tarifList.firstWhere(
        (e) {
          final jenis = (e['jenisTarif']?.toString() ?? '')
              .toLowerCase()
              .trim();
          final input = jenisKendaraan.toLowerCase().trim();
          return jenis == input;
        },
        orElse: () => null, // Jangan throw exception
      );

      if (tarif == null) {
        AppLogger.error('Tarif tidak ditemukan untuk: $jenisKendaraan');
        if (!isClosed) {
          emit(PaymentFailure('Tarif untuk $jenisKendaraan tidak ditemukan'));
        }
        return;
      }

      finalNominal = tarif['tarif'] ?? 0;

      if (finalNominal == 0) {
        AppLogger.error('Nominal tarif 0 untuk: $jenisKendaraan');
      }
    } catch (e) {
      AppLogger.error('Error parsing tarif: $e');
      if (!isClosed) {
        emit(PaymentFailure('Gagal membaca tarif: ${e.toString()}'));
      }
      return;
    }

    // Lanjut generate QRIS...
  }

  Future<void> confirmPayment(String idTransaksi) async {
    emit(PaymentLoading());

    final result = await _confirmPaymentUseCase.execute(idTransaksi);

    result.fold(
      (failure) {
        if (!isClosed) emit(PaymentFailure(failure.message));
      },
      (_) {
        if (!isClosed) emit(PaymentConfirmed());
      },
    );
  }
}
