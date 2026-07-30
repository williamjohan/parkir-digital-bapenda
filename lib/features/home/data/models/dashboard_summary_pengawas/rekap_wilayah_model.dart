import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/rekap_wilayah_entity.dart';

part 'rekap_wilayah_model.g.dart';

// -----------------------------------------------------------------------------
// 1. DTO CLASSES (Murni hanya untuk urusan JSON Serialization)
// -----------------------------------------------------------------------------

@JsonSerializable()
class RekapWilayahResponseModel {
  @JsonKey(name: 'isSuccess')
  final bool? isSuccess;

  @JsonKey(name: 'statusCode')
  final int? statusCode;

  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'data')
  final RekapWilayahDataModel? data;

  RekapWilayahResponseModel({
    this.isSuccess,
    this.statusCode,
    this.message,
    this.data,
  });

  factory RekapWilayahResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RekapWilayahResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$RekapWilayahResponseModelToJson(this);
}

@JsonSerializable()
class RekapWilayahDataModel {
  @JsonKey(name: 'kodeOpd')
  final String? kodeOpd;

  @JsonKey(name: 'namaOpd')
  final String? namaOpd;

  @JsonKey(name: 'detailList')
  final List<DetailRekapWilayahModel>? detailList;

  RekapWilayahDataModel({this.kodeOpd, this.namaOpd, this.detailList});

  factory RekapWilayahDataModel.fromJson(Map<String, dynamic> json) =>
      _$RekapWilayahDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$RekapWilayahDataModelToJson(this);
}

@JsonSerializable()
class DetailRekapWilayahModel {
  @JsonKey(name: 'kdCamat')
  final String? kdCamat;

  @JsonKey(name: 'nmCamat')
  final String? nmCamat;

  @JsonKey(name: 'jmlObjekPajak')
  final int? jmlObjekPajak;

  @JsonKey(name: 'jmlTju')
  final int? jmlTju;

  DetailRekapWilayahModel({
    this.kdCamat,
    this.nmCamat,
    this.jmlObjekPajak,
    this.jmlTju,
  });

  factory DetailRekapWilayahModel.fromJson(Map<String, dynamic> json) =>
      _$DetailRekapWilayahModelFromJson(json);

  Map<String, dynamic> toJson() => _$DetailRekapWilayahModelToJson(this);
}

// -----------------------------------------------------------------------------
// 2. EXTENSIONS (Khusus untuk mapping ke Domain Entity)
// -----------------------------------------------------------------------------

extension RekapWilayahDataModelX on RekapWilayahDataModel {
  RekapWilayahEntity toEntity() {
    return RekapWilayahEntity(
      kodeOpd: kodeOpd ?? '',
      namaOpd: namaOpd ?? '',
      detailList: detailList?.map((e) => e.toEntity()).toList() ?? [],
    );
  }
}

extension DetailRekapWilayahModelX on DetailRekapWilayahModel {
  DetailRekapWilayahEntity toEntity() {
    return DetailRekapWilayahEntity(
      kdCamat: kdCamat ?? '',
      nmCamat: nmCamat ?? '',
      jmlObjekPajak: jmlObjekPajak ?? 0,
      jmlTju: jmlTju ?? 0,
    );
  }
}
