import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parkir_digital_bapenda/core/enums/app_enums.dart';

part 'qris_rompi_request_entity.freezed.dart';

@freezed
class QrisRompiRequestEntity with _$QrisRompiRequestEntity {
  const factory QrisRompiRequestEntity({
    required String nop,
    required String jukirUsername,
    required String idDevice,
    required JenisKendaraan jenisKendaraan,
  }) = _QrisRompiRequestEntity;
}
