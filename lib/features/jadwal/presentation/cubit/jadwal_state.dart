import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/jadwal_entity.dart';

part 'jadwal_state.freezed.dart';

enum JadwalStatus { initial, loading, success, failure }

@freezed
class JadwalState with _$JadwalState {
  const factory JadwalState({
    @Default(JadwalStatus.initial) JadwalStatus status,
    List<JadwalEntity>? jadwal,
    @Default('') String message,
  }) = _JadwalState;
}
