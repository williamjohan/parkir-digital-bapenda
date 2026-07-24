import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parkir_digital_bapenda/features/jadwal/domain/entities/riwayat_abensi_entity.dart';

part 'riwayat_absensi_state.freezed.dart';

enum JadwalStatus { initial, loading, success, failure }

@freezed
class RiwayatAbsensiState with _$RiwayatAbsensiState {
  const factory RiwayatAbsensiState({
    @Default(JadwalStatus.initial) JadwalStatus status,
    List<RiwayatAbsensiEntity>? jadwal,
    List<RiwayatAbsensiEntity>? jadwalFake,
    @Default('') String message,
  }) = _RiwayatAbsensiState;
}
