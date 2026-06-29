import 'package:freezed_annotation/freezed_annotation.dart';

part 'daftar_nop_entity.freezed.dart';

@freezed
class DaftarNopEntity with _$DaftarNopEntity {
  const factory DaftarNopEntity({
    required String nop,
    required String namaOp,
    required String alamatOp,
    required bool isDigital,
    required int pungutTarif,
    required int uptb,
    required int totalPendapatan,

    // Untuk SQLite
    @Default('') String kdCamat,
    @Default('') String nmCamat,
    @Default('') String kdLurah,
    @Default('') String nmLurah,
  }) = _DaftarNopEntity;
}
