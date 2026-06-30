import 'package:freezed_annotation/freezed_annotation.dart';

part 'detail_realisasi_op_model.freezed.dart';
part 'detail_realisasi_op_model.g.dart';

@freezed
class DetailRealisasiOpResponse with _$DetailRealisasiOpResponse {
  const factory DetailRealisasiOpResponse({
    bool? isSuccess,
    int? statusCode,
    String? message,
    DetailRealisasiOpModel? data,
  }) = _DetailRealisasiOpResponse;

  factory DetailRealisasiOpResponse.fromJson(Map<String, dynamic> json) =>
      _$DetailRealisasiOpResponseFromJson(json);
}

@freezed
class DetailRealisasiOpModel with _$DetailRealisasiOpModel {
  const factory DetailRealisasiOpModel({
    String? nop,
    String? namaOp,
    int? uptbId,
    int? tahun,
    bool? isDigital,
    String? tglDigitalisasi,
    double? nominalNonDigital,
    double? nominalDigital,
    double? totalNominal,

    List<RealisasiPerBulanModel>? realisasiPerBulan,
  }) = _DetailRealisasiOpModel;

  factory DetailRealisasiOpModel.fromJson(Map<String, dynamic> json) =>
      _$DetailRealisasiOpModelFromJson(json);
}

@freezed
class RealisasiPerBulanModel with _$RealisasiPerBulanModel {
  const factory RealisasiPerBulanModel({
    int? bulan,
    String? bulanNama,
    String? tglSspd,
    double? nominalNonDigital,
    double? nominalDigital,
    double? totalNominal,
  }) = _RealisasiPerBulanModel;

  factory RealisasiPerBulanModel.fromJson(Map<String, dynamic> json) =>
      _$RealisasiPerBulanModelFromJson(json);
}
