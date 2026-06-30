import 'package:freezed_annotation/freezed_annotation.dart';

part 'data_jukir_entity.freezed.dart';

@freezed
class DataJukirEntity with _$DataJukirEntity {
  const factory DataJukirEntity({
    required String nop,
    required String username,
    required String deviceId,
    required String namaPetugas,
    required String shift,
  }) = _DataJukirEntity;
}
