import 'package:json_annotation/json_annotation.dart';
import '../../../../core/enums/app_enums.dart';
import '../../domain/entities/op_pengawas_entity.dart';

part 'op_pengawasan_model.g.dart';

@JsonSerializable()
class OpPengawasanModel {
  @JsonKey(name: 'idTempat')
  final String idTempat;

  @JsonKey(name: 'namaTempat')
  final String namaTempat;

  @JsonKey(name: 'alamatTempat')
  final String alamatTempat;

  @JsonKey(name: 'kdCamat')
  final String kdCamat;

  @JsonKey(name: 'nmCamat')
  final String nmCamat;

  @JsonKey(name: 'jenis')
  final int jenis;

  const OpPengawasanModel({
    required this.idTempat,
    required this.namaTempat,
    required this.alamatTempat,
    required this.kdCamat,
    required this.nmCamat,
    required this.jenis,
  });

  factory OpPengawasanModel.fromJson(Map<String, dynamic> json) =>
      _$OpPengawasanModelFromJson(json);

  Map<String, dynamic> toJson() => _$OpPengawasanModelToJson(this);
}

extension OpPengawasanModelExt on OpPengawasanModel {
  OpPengawasEntity toEntity() {
    return OpPengawasEntity(
      kecamatan: nmCamat,
      namaOp: namaTempat,
      jenisPengawasan: JenisPengawasan.fromId(jenis),
      nop: idTempat,
      alamat: alamatTempat,
    );
  }
}
