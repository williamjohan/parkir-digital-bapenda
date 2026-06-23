import 'package:freezed_annotation/freezed_annotation.dart';

part 'detail_realisasi_op_model.freezed.dart';
part 'detail_realisasi_op_model.g.dart';

@freezed
class DetailRealisasiOpResponse with _$DetailRealisasiOpResponse {
  const factory DetailRealisasiOpResponse({
    @JsonKey(name: 'isSuccess') bool? isSuccess,
    @JsonKey(name: 'statusCode') int? statusCode,
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'data') DetailRealisasiOpModel? data,
  }) = _DetailRealisasiOpResponse;

  factory DetailRealisasiOpResponse.fromJson(Map<String, dynamic> json) =>
      _$DetailRealisasiOpResponseFromJson(json);
}

@freezed
class DetailRealisasiOpModel with _$DetailRealisasiOpModel {
  const factory DetailRealisasiOpModel({
    @JsonKey(name: 'nop') String? nop,
    @JsonKey(name: 'namaOp') String? namaOp,
    @JsonKey(name: 'uptbId') int? uptbId,
    @JsonKey(name: 'tahun') int? tahun,
    @JsonKey(name: 'isDigital') bool? isDigital,
    @JsonKey(name: 'tglDigitalisasi') String? tglDigitalisasi,
    @JsonKey(name: 'nominalNonDigital') double? nominalNonDigital,
    @JsonKey(name: 'nominalDigital') double? nominalDigital,
    @JsonKey(name: 'totalNominal') double? totalNominal,
    @JsonKey(name: 'realisasiPerBulan')
    List<RealisasiPerBulanModel>? realisasiPerBulan,
  }) = _DetailRealisasiOpModel;

  factory DetailRealisasiOpModel.fromJson(Map<String, dynamic> json) =>
      _$DetailRealisasiOpModelFromJson(json);
}

@freezed
class RealisasiPerBulanModel with _$RealisasiPerBulanModel {
  const factory RealisasiPerBulanModel({
    @JsonKey(name: 'bulan') int? bulan,
    @JsonKey(name: 'bulanNama') String? bulanNama,
    @JsonKey(name: 'tglSspd') String? tglSspd,
    @JsonKey(name: 'nominalNonDigital') double? nominalNonDigital,
    @JsonKey(name: 'nominalDigital') double? nominalDigital,
    @JsonKey(name: 'totalNominal') double? totalNominal,
  }) = _RealisasiPerBulanModel;

  factory RealisasiPerBulanModel.fromJson(Map<String, dynamic> json) =>
      _$RealisasiPerBulanModelFromJson(json);
}
