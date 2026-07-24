import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/request_laporan_pengawasan_entity/request_laporan_pengawasan_entity.dart';

part 'add_pengawasan_model.g.dart';

@JsonSerializable()
class AddPengawasanModel extends Equatable {
  @JsonKey(name: 'JenisPel')
  final int jenisPel;

  @JsonKey(name: 'KetPel')
  final String ketPel;

  @JsonKey(name: 'NomorObjek')
  final String nomorObjek;

  @JsonKey(name: 'Shift')
  final int shift;

  @JsonKey(name: 'Jenis')
  final int jenis;

  const AddPengawasanModel({
    required this.jenisPel,
    required this.ketPel,
    required this.nomorObjek,
    required this.shift,
    required this.jenis,
  });

  factory AddPengawasanModel.fromJson(Map<String, dynamic> json) =>
      _$AddPengawasanModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddPengawasanModelToJson(this);

  factory AddPengawasanModel.fromEntity(RequestLaporanPengawasanEntity entity) {
    return AddPengawasanModel(
      jenisPel: entity.jenisPel,
      ketPel: entity.ketPel,
      nomorObjek: entity.nomorObjek,
      shift: entity.shift,
      jenis: entity.jenis,
    );
  }

  @override
  List<Object?> get props => [jenisPel, ketPel, nomorObjek, shift, jenis];
}

extension RequestLaporanPengawasanEntityExt on RequestLaporanPengawasanEntity {
  AddPengawasanModel toModel() {
    return AddPengawasanModel(
      jenisPel: jenisPel,
      ketPel: ketPel,
      nomorObjek: nomorObjek,
      shift: shift,
      jenis: jenis,
    );
  }
}
