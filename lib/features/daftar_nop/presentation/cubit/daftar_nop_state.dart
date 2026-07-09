import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/daftar_nop_entity.dart';

part 'daftar_nop_state.freezed.dart';

@freezed
class DaftarNopState with _$DaftarNopState {
  const factory DaftarNopState({
    @Default([]) List<DaftarNopEntity> daftarNop,

    @Default(false) bool isLoading,

    @Default(false) bool isSaving,

    @Default(false) bool isSuccess,

    @Default('') String errorMessage,

    /// 0.0 - 1.0
    @Default(0.0) double progress,
  }) = _DaftarNopState;

  factory DaftarNopState.initial() => const DaftarNopState();
}
