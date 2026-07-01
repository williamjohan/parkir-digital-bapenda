import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/absensi_entity.dart';

part 'absensi_model.g.dart';

// --- SAFE PARSING HELPERS ---
int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

bool _toBool(dynamic value) {
  if (value == null) return false;
  if (value is bool) return value;
  if (value is int) return value == 1; // Jaga-jaga BE ngirim 1/0
  if (value is String) return value.toLowerCase() == 'true' || value == '1';
  return false;
}

DateTime _toDateTime(dynamic value) {
  if (value == null) return DateTime.now();
  if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
  return DateTime.now();
}

// ==========================================
// ABSENSI MODEL
// ==========================================
@JsonSerializable(explicitToJson: true)
class AbsensiModel {
  @JsonKey(name: 'date', fromJson: _toDateTime)
  final DateTime date;

  @JsonKey(name: 'isPresent', fromJson: _toBool)
  final bool isPresent;

  @JsonKey(name: 'latitude', fromJson: _toDouble)
  final double latitude;

  @JsonKey(name: 'longitude', fromJson: _toDouble)
  final double longitude;

  @JsonKey(name: 'checkList')
  final AbsensiCheckListModel? checkList;

  AbsensiModel({
    required this.date,
    this.isPresent = false,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.checkList,
  });

  factory AbsensiModel.fromJson(Map<String, dynamic> json) =>
      _$AbsensiModelFromJson(json);

  Map<String, dynamic> toJson() => _$AbsensiModelToJson(this);

  // Mapper Entity -> Model (Wajib ada untuk POST submit)
  factory AbsensiModel.fromEntity(AbsensiEntity entity) {
    return AbsensiModel(
      date: entity.date,
      isPresent: entity.isPresent,
      latitude: entity.latitude,
      longitude: entity.longitude,
      checkList: entity.checkList != null
          ? AbsensiCheckListModel.fromEntity(entity.checkList!)
          : null,
    );
  }
}

// EXTENSION ABSENSI: Model -> Entity
extension AbsensiModelExt on AbsensiModel {
  AbsensiEntity toEntity() {
    return AbsensiEntity(
      date: date,
      isPresent: isPresent,
      latitude: latitude,
      longitude: longitude,
      checkList: checkList?.toEntity(),
    );
  }
}

// ==========================================
// CHECKLIST MODEL
// ==========================================
@JsonSerializable()
class AbsensiCheckListModel {
  @JsonKey(name: 'edc', fromJson: _toBool)
  final bool edc;

  @JsonKey(name: 'qrisRompi', fromJson: _toBool)
  final bool qrisRompi;

  @JsonKey(name: 'cctv', fromJson: _toBool)
  final bool cctv;

  @JsonKey(name: 'tsPark', fromJson: _toBool)
  final bool tsPark;

  @JsonKey(name: 'totalMotor', fromJson: _toInt)
  final int totalMotor;

  @JsonKey(name: 'totalMobil', fromJson: _toInt)
  final int totalMobil;

  AbsensiCheckListModel({
    this.edc = false,
    this.qrisRompi = false,
    this.cctv = false,
    this.tsPark = false,
    this.totalMotor = 0,
    this.totalMobil = 0,
  });

  factory AbsensiCheckListModel.fromJson(Map<String, dynamic> json) =>
      _$AbsensiCheckListModelFromJson(json);

  Map<String, dynamic> toJson() => _$AbsensiCheckListModelToJson(this);

  // Mapper Entity -> Model (Wajib ada untuk POST submit)
  factory AbsensiCheckListModel.fromEntity(AbsensiCheckList entity) {
    return AbsensiCheckListModel(
      edc: entity.edc,
      qrisRompi: entity.qrisRompi,
      cctv: entity.cctv,
      tsPark: entity.tsPark,
      totalMotor: entity.totalMotor,
      totalMobil: entity.totalMobil,
    );
  }
}

// EXTENSION CHECKLIST: Model -> Entity
extension AbsensiCheckListModelExt on AbsensiCheckListModel {
  AbsensiCheckList toEntity() {
    return AbsensiCheckList(
      edc: edc,
      qrisRompi: qrisRompi,
      cctv: cctv,
      tsPark: tsPark,
      totalMotor: totalMotor,
      totalMobil: totalMobil,
    );
  }
}
