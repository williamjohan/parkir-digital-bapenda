import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parkir_digital_bapenda/features/objek_pajak/domain/entities/nop_enitity.dart';

part 'nop_model.freezed.dart';
part 'nop_model.g.dart';

/// 1. CLASS UTAMA (ROOT RESPONSE)
@freezed
class NopModel with _$NopModel {
  const factory NopModel({
    @Default(false) bool isSuccess,
    @Default(0) int statusCode,
    @Default('') String message,
    @Default(NopDataModel()) NopDataModel data,
  }) = _NopModel;

  factory NopModel.fromJson(Map<String, dynamic> json) =>
      _$NopModelFromJson(json);
}

/// 2. CLASS DATA UTAMA
@freezed
class NopDataModel with _$NopDataModel {
  const factory NopDataModel({
    @Default('') String nop,
    @Default('') String namaOp,
    @Default('') String alamatOp,
    @Default(false) bool isDigital,
    @Default(0) int pungutTarif,
    @Default(0) int uptb,
    @Default('') String statusDigitalisasi,
    @Default(0) int totalPendapatan,
  }) = _NopDataModel;

  factory NopDataModel.fromJson(Map<String, dynamic> json) =>
      _$NopDataModelFromJson(json);
}

extension NopModelExt on NopModel {
  NopEntity toEntity() {
    return NopEntity(
      isSuccess: isSuccess,
      statusCode: statusCode,
      message: message,
      data: data.toEntity(),
    );
  }
}

extension NopDataModelExt on NopDataModel {
  NopDataEntity toEntity() {
    return NopDataEntity(
      nop: nop,
      namaOp: namaOp,
      alamatOp: alamatOp,
      uptb: uptb,
      statusDigitalisasi: statusDigitalisasi,
    );
  }
}
