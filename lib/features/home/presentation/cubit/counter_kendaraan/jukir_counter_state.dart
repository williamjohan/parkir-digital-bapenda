import 'package:freezed_annotation/freezed_annotation.dart';

part 'jukir_counter_state.freezed.dart';

enum JukirCounterStatus { initial, loading, success, failure, submitting, submitSuccess }

@freezed
class JukirCounterState with _$JukirCounterState {
  const factory JukirCounterState({
    @Default(JukirCounterStatus.initial) JukirCounterStatus status,
    @Default(0) int mobilCount,
    @Default(0) int motorCount,
    String? errorMessage,
  }) = _JukirCounterState;
}