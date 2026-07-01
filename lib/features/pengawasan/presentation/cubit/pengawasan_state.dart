import 'package:freezed_annotation/freezed_annotation.dart';

part 'pengawasan_state.freezed.dart';

@freezed
class PengawasanState with _$PengawasanState {
  const factory PengawasanState({
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    String? errorMessage,
  }) = _PengawasanState;
}
