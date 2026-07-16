import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../../core/utils/server_utc_date_time_converter.dart';
import '../../domain/entities/detail_tax_surveillance_op_entity.dart';

part 'detail_tax_surveillance_op_model.freezed.dart';
part 'detail_tax_surveillance_op_model.g.dart';

// =====================================================================
// 1. REQUEST MODEL
// =====================================================================

@freezed
class TaxSurveillanceDetailRequestModel
    with _$TaxSurveillanceDetailRequestModel {
  const factory TaxSurveillanceDetailRequestModel({
    required String nop,

    @ServerUtcDateTimeConverter() required DateTime startDate,

    @ServerUtcDateTimeConverter() required DateTime endDate,
  }) = _TaxSurveillanceDetailRequestModel;

  factory TaxSurveillanceDetailRequestModel.fromJson(
    Map<String, dynamic> json,
  ) => _$TaxSurveillanceDetailRequestModelFromJson(json);
}
// =====================================================================
// 2. RESPONSE MODEL
// =====================================================================

@freezed
class TaxSurveillanceDetailResponseModel
    with _$TaxSurveillanceDetailResponseModel {
  const factory TaxSurveillanceDetailResponseModel({
    required String jenisKendaraan,
    required int nominal,
    required DateTime tgl,
  }) = _TaxSurveillanceDetailResponseModel;

  factory TaxSurveillanceDetailResponseModel.fromJson(
    Map<String, dynamic> json,
  ) => _$TaxSurveillanceDetailResponseModelFromJson(json);
}

// =====================================================================
// 3. EXTENSION MAPPERS (Jembatan Data Layer -> Domain Layer)
// =====================================================================

/// ResponseModel (Data) -> ResponseEntity (Domain)
extension TaxSurveillanceDetailResponseModelExt
    on TaxSurveillanceDetailResponseModel {
  TaxSurveillanceDetailResponseEntity toEntity() {
    return TaxSurveillanceDetailResponseEntity(
      jenisKendaraan: jenisKendaraan,
      nominal: nominal,
      tgl: tgl,
    );
  }
}

extension TaxSurveillanceDetailListModelExt
    on List<TaxSurveillanceDetailResponseModel> {
  List<TaxSurveillanceDetailResponseEntity> toEntityList() {
    return map((model) => model.toEntity()).toList();
  }
}

/// RequestEntity (Domain) -> RequestModel (Data)
extension TaxSurveillanceRequestEntityExt on TaxSurveillanceRequestEntity {
  TaxSurveillanceDetailRequestModel toModel() {
    return TaxSurveillanceDetailRequestModel(
      nop: nop,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
