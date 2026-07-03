import 'package:freezed_annotation/freezed_annotation.dart';

part 'absensi_state.freezed.dart';

enum AbsensiStatus { initial, loading, success, failure }

@freezed
class AbsensiState with _$AbsensiState {
  const AbsensiState._(); // 🔥 wajib ditambah biar bisa punya getter custom

  const factory AbsensiState({
    @Default(AbsensiStatus.initial) AbsensiStatus status,
    @Default('') String errorMessage,
  }) = _AbsensiState;

  bool get isLoading => status == AbsensiStatus.loading; // 🔥 getter, bukan field
}