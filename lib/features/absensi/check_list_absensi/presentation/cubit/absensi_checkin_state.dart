import 'package:freezed_annotation/freezed_annotation.dart';

part 'absensi_checkin_state.freezed.dart';

@freezed
class AbsensiCheckInState with _$AbsensiCheckInState {
  const factory AbsensiCheckInState({
    @Default(false) bool isCheckInLoading,
    @Default(false) bool isCheckInSuccess,
    String? checkInErrorMessage,
    @Default(false) bool isCheckOutLoading,
    @Default(false) bool isCheckOutSuccess,
    String? checkOutErrorMessage,
  }) = _AbsensiCheckInState;
}
