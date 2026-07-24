import 'package:json_annotation/json_annotation.dart';
import 'package:parkir_digital_bapenda/features/jadwal/domain/entities/riwayat_abensi_entity.dart';

part 'riwayat_absensi_model.g.dart';

@JsonSerializable()
class RiwayatAbsensiModel {
  @JsonKey(name: 'tanggal')
  final String tanggal;

  @JsonKey(name: 'tanggalString')
  final String tanggalString;

  @JsonKey(name: 'objekList')
  final List<ObjekPengawasanModel> objekList;

  RiwayatAbsensiModel({
    required this.tanggal,
    required this.tanggalString,
    required this.objekList,
  });

  factory RiwayatAbsensiModel.fromJson(Map<String, dynamic> json) =>
      _$RiwayatAbsensiModelFromJson(json);

  Map<String, dynamic> toJson() => _$RiwayatAbsensiModelToJson(this);
}

@JsonSerializable()
class ObjekPengawasanModel {
  @JsonKey(name: 'idTempat')
  final String idTempat;

  @JsonKey(name: 'namaTempat')
  final String namaTempat;

  @JsonKey(name: 'checkIn')
  final CheckInOutModel? checkIn;

  @JsonKey(name: 'checkOut')
  final CheckInOutModel? checkOut;

  ObjekPengawasanModel({
    required this.idTempat,
    required this.namaTempat,
    this.checkIn,
    this.checkOut,
  });

  factory ObjekPengawasanModel.fromJson(Map<String, dynamic> json) =>
      _$ObjekPengawasanModelFromJson(json);

  Map<String, dynamic> toJson() => _$ObjekPengawasanModelToJson(this);
}

@JsonSerializable()
class CheckInOutModel {
  @JsonKey(name: 'check')
  final String? check;

  @JsonKey(name: 'jmlMotor')
  final int jmlMotor;

  @JsonKey(name: 'jmlMobil')
  final int jmlMobil;

  @JsonKey(name: 'alatList')
  final List<AlatModel> alatList;

  CheckInOutModel({
    this.check,
    required this.jmlMotor,
    required this.jmlMobil,
    required this.alatList,
  });

  factory CheckInOutModel.fromJson(Map<String, dynamic> json) =>
      _$CheckInOutModelFromJson(json);

  Map<String, dynamic> toJson() => _$CheckInOutModelToJson(this);
}

@JsonSerializable()
class AlatModel {
  @JsonKey(name: 'alatId')
  final int alatId;

  @JsonKey(name: 'nama')
  final String nama;

  @JsonKey(name: 'jenis')
  final int jenis;

  @JsonKey(name: 'isChecked')
  final bool isChecked;

  AlatModel({
    required this.alatId,
    required this.nama,
    required this.jenis,
    required this.isChecked,
  });

  factory AlatModel.fromJson(Map<String, dynamic> json) =>
      _$AlatModelFromJson(json);

  Map<String, dynamic> toJson() => _$AlatModelToJson(this);
}

// ===========================================================================
// Extension toEntity() — pola sama persis kayak JadwalModelExt sebelumnya
// ===========================================================================

extension RiwayatAbsensiModelExt on RiwayatAbsensiModel {
  RiwayatAbsensiEntity toEntity() {
    return RiwayatAbsensiEntity(
      tanggal: DateTime.tryParse(tanggal) ?? DateTime.now(),
      tanggalString: tanggalString,
      objekList: objekList.map((e) => e.toEntity()).toList(),
    );
  }
}

extension RiwayatPengawasanModelListExt on List<RiwayatAbsensiModel> {
  List<RiwayatAbsensiEntity> toEntityList() =>
      map((model) => model.toEntity()).toList();
}

extension ObjekPengawasanModelExt on ObjekPengawasanModel {
  ObjekPengawasanEntity toEntity() {
    final sudahCheckOut = checkOut?.check != null;

    return ObjekPengawasanEntity(
      nop: idTempat,
      namaNop: namaTempat,
      jamCheckIn: _formatJam(checkIn?.check),
      jamCheckOut: sudahCheckOut ? _formatJam(checkOut!.check) : null,
      motorCheckIn: checkIn?.jmlMotor ?? 0,
      mobilCheckIn: checkIn?.jmlMobil ?? 0,
      motorCheckOut: sudahCheckOut ? checkOut!.jmlMotor : null,
      mobilCheckOut: sudahCheckOut ? checkOut!.jmlMobil : null,
      instrumenCheckIn: (checkIn?.alatList ?? [])
          .map((a) => a.toEntity())
          .toList(),
      instrumenCheckOut: sudahCheckOut
          ? checkOut!.alatList.map((a) => a.toEntity()).toList()
          : null,
    );
  }
}

extension AlatModelExt on AlatModel {
  InstrumenTersediaEntity toEntity() =>
      InstrumenTersediaEntity(nama: nama, tersedia: isChecked);
}

String _formatJam(String? isoString) {
  if (isoString == null) return '--:--';
  final dt = DateTime.tryParse(isoString);
  if (dt == null) return '--:--';
  return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}
