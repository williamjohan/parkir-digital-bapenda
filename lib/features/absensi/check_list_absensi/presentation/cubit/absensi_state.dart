import 'package:freezed_annotation/freezed_annotation.dart';

part 'absensi_state.freezed.dart';

enum AbsensiStatus { initial, loading, success, failure }

@freezed
class AbsensiState with _$AbsensiState {
  const factory AbsensiState({
    @Default(AbsensiStatus.initial) AbsensiStatus status,
    @Default(false) bool isLoading,
    @Default('') String errorMessage,
  }) = _AbsensiState;
}
