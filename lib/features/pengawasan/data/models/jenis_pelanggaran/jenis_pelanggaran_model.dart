import 'package:json_annotation/json_annotation.dart';

import '../../../../../core/enums/app_enums.dart';
import '../../../domain/entities/jenis_pelanggaran/jenis_pelanggaran_entity.dart';
part 'jenis_pelanggaran_model.g.dart';

@JsonSerializable()
class JenisPelanggaranModel {
  final int id;

  @JsonKey(name: 'nama')
  final String namaPelanggaran;

  @JsonKey(name: 'jenis')
  final int jenis;

  const JenisPelanggaranModel({
    required this.id,
    required this.namaPelanggaran,
    required this.jenis,
  });

  factory JenisPelanggaranModel.fromJson(Map<String, dynamic> json) =>
      _$JenisPelanggaranModelFromJson(json);

  Map<String, dynamic> toJson() => _$JenisPelanggaranModelToJson(this);
}

extension JenisPelanggaranModelExt on JenisPelanggaranModel {
  JenisPelanggaranEntity toEntity() {
    return JenisPelanggaranEntity(
      id: id,
      namaPelanggaran: namaPelanggaran,
      jenisPelanggaran: JenisPengawasan.fromId(jenis),
    );
  }
}
