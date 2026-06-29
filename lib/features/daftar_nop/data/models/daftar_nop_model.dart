import 'package:freezed_annotation/freezed_annotation.dart';

part 'daftar_nop_model.freezed.dart';
part 'daftar_nop_model.g.dart';

@freezed
class DaftarNopModel with _$DaftarNopModel {
  const factory DaftarNopModel({
    required String nop,

    @JsonKey(name: 'namaOp') required String namaOp,

    @JsonKey(name: 'alamatOp') required String alamatOp,

    @JsonKey(name: 'isDigital') required bool isDigital,

    @JsonKey(name: 'pungutTarif') required int pungutTarif,

    @JsonKey(name: 'uptb') required int uptb,

    @JsonKey(name: 'totalPendapatan') required int totalPendapatan,

    @Default('') String kdCamat,

    @Default('') String nmCamat,

    @Default('') String kdLurah,

    @Default('') String nmLurah,
  }) = _DaftarNopModel;

  factory DaftarNopModel.fromJson(Map<String, dynamic> json) =>
      _$DaftarNopModelFromJson(json);
}
