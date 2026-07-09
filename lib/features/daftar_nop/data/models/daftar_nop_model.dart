import 'package:freezed_annotation/freezed_annotation.dart';

part 'daftar_nop_model.freezed.dart';
part 'daftar_nop_model.g.dart';

@freezed
class DaftarNopModel with _$DaftarNopModel {
  const factory DaftarNopModel({
    @Default('') String nop,
    @Default('') String namaOp,
    @Default('') String alamatOp,
    @Default(false) bool isDigital,
    @Default(0) int pungutTarif,
    @Default(0) int uptb,
    @Default(0) int totalPendapatan,
    @Default('') String kdCamat,
    @Default('') String nmCamat,
    @Default('') String kdLurah,
    @Default('') String nmLurah,
  }) = _DaftarNopModel;

  factory DaftarNopModel.fromJson(Map<String, dynamic> json) =>
      _$DaftarNopModelFromJson(json);
}
