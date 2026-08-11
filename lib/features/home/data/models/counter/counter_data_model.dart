import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/counter_data_entity.dart';

part 'counter_data_model.g.dart';

// --- BUNGKUSAN RESPONSE GET ---
@JsonSerializable()
class CounterDataResponseModel {
  @JsonKey(name: 'isSuccess')
  final bool? isSuccess;

  @JsonKey(name: 'statusCode')
  final int? statusCode;

  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'data')
  final CounterDataModel? data;

  CounterDataResponseModel({
    this.isSuccess,
    this.statusCode,
    this.message,
    this.data,
  });

  factory CounterDataResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CounterDataResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CounterDataResponseModelToJson(this);
}

// --- BUNGKUSAN RESPONSE POST (Insert) ---
@JsonSerializable()
class InsertCounterResponseModel {
  @JsonKey(name: 'isSuccess')
  final bool? isSuccess;

  @JsonKey(name: 'statusCode')
  final int? statusCode;

  @JsonKey(name: 'message')
  final String? message;

  InsertCounterResponseModel({
    this.isSuccess,
    this.statusCode,
    this.message,
  });

  factory InsertCounterResponseModel.fromJson(Map<String, dynamic> json) =>
      _$InsertCounterResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$InsertCounterResponseModelToJson(this);
}

// --- ISI DATA (Data Objek) ---
@JsonSerializable()
class CounterDataModel {
  @JsonKey(name: 'jumlahMotor')
  final int? jumlahMotor;

  @JsonKey(name: 'jumlahMobil')
  final int? jumlahMobil;

  CounterDataModel({
    this.jumlahMotor,
    this.jumlahMobil,
  });

  factory CounterDataModel.fromJson(Map<String, dynamic> json) =>
      _$CounterDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$CounterDataModelToJson(this);
}

// Extension Mapper
extension CounterDataModelExt on CounterDataModel {
  CounterDataEntity toEntity() {
    return CounterDataEntity(
      // Berikan nilai default 0 jika null untuk mencegah error di UI
      jumlahMotor: jumlahMotor ?? 0, 
      jumlahMobil: jumlahMobil ?? 0,
    );
  }
}