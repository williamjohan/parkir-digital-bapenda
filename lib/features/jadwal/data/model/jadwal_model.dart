import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/jadwal_entity.dart';

part 'jadwal_model.g.dart';

@JsonSerializable()
class JadwalModel {
  @JsonKey(name: 'hari')
  final int hari;

  @JsonKey(name: 'hariNama')
  final String hariNama;

  @JsonKey(name: 'bulan')
  final int bulan;

  @JsonKey(name: 'bulanNama')
  final String bulanNama;

  @JsonKey(name: 'tahun')
  final int tahun;

  @JsonKey(name: 'tahunNama')
  final String tahunNama;

  @JsonKey(name: 'jamMasuk')
  final String? jamMasuk; //

  @JsonKey(name: 'jamPulang')
  final String? jamPulang; //

  @JsonKey(name: 'jamCheckIn')
  final String? jamCheckIn; //

  @JsonKey(name: 'jamCheckOut')
  final String? jamCheckOut; //

  @JsonKey(name: 'isLibur')
  final bool isLibur;

  JadwalModel({
    required this.hari,
    required this.hariNama,
    required this.bulan,
    required this.bulanNama,
    required this.tahun,
    required this.tahunNama,
    this.jamMasuk,
    this.jamPulang,
    this.jamCheckIn,
    this.jamCheckOut,
    required this.isLibur,
  });

  factory JadwalModel.fromJson(Map<String, dynamic> json) =>
      _$JadwalModelFromJson(json);

  Map<String, dynamic> toJson() => _$JadwalModelToJson(this);
}

//  1. Extension untuk Single Object
extension JadwalModelExt on JadwalModel {
  JadwalEntity toEntity() {
    return JadwalEntity(
      hari: hari,
      hariNama: hariNama,
      bulan: bulan,
      bulanNama: bulanNama,
      tahun: tahun,
      tahunNama: tahunNama,
      // 🚀 Proteksi Null: Ubah null dari API menjadi String kosong untuk UI
      jamMasuk: jamMasuk ?? '',
      jamPulang: jamPulang ?? '',
      jamCheckIn: jamCheckIn ?? '',
      jamCheckOut: jamCheckOut ?? '',
      isLibur: isLibur,
    );
  }
}

//  2. Extension Khusus untuk List (Best Practice!)
extension JadwalModelListExt on List<JadwalModel> {
  List<JadwalEntity> toEntityList() {
    // me-looping seluruh item model dan mengubahnya menjadi entity
    return map((model) => model.toEntity()).toList();
  }
}
