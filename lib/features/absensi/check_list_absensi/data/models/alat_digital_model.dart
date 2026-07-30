// features/absensi/check_list_absensi/data/models/alat_digital_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/alat_digital_entity.dart';

part 'alat_digital_model.freezed.dart';
part 'alat_digital_model.g.dart';

@freezed
class AlatDigitalModel with _$AlatDigitalModel {
  const AlatDigitalModel._();

  const factory AlatDigitalModel({
    @Default(0) int id,
    @Default('') String nama,
    @Default(0) int jenis,
  }) = _AlatDigitalModel;

  factory AlatDigitalModel.fromJson(Map<String, dynamic> json) =>
      _$AlatDigitalModelFromJson(json);

  AlatDigitalEntity toEntity() =>
      AlatDigitalEntity(id: id, nama: nama, jenis: jenis);
}
