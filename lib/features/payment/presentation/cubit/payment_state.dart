import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_state.freezed.dart';

@freezed
class PaymentState with _$PaymentState {
  const factory PaymentState.initial() = _Initial;

  const factory PaymentState.loading() = _Loading;

  ///  STATE 1: Khusus Jukir (Membawa path file SQLite dan kodeQris)
  const factory PaymentState.localQrisReady({
    required String qrisImagePath,
    required String kodeQris,
  }) = _LocalQrisReady;

  ///  STATE 2: Khusus Bapenda Demo (Membawa string mentah QRIS)
  const factory PaymentState.demoQrisReady({required String rawQrisString}) =
      _DemoQrisReady;

  const factory PaymentState.error({required String message}) = _Error;
  const factory PaymentState.paymentSuccess() = _PaymentSuccess;
}
