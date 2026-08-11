// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CounterDataResponseModel _$CounterDataResponseModelFromJson(
  Map<String, dynamic> json,
) => CounterDataResponseModel(
  isSuccess: json['isSuccess'] as bool?,
  statusCode: (json['statusCode'] as num?)?.toInt(),
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : CounterDataModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CounterDataResponseModelToJson(
  CounterDataResponseModel instance,
) => <String, dynamic>{
  'isSuccess': instance.isSuccess,
  'statusCode': instance.statusCode,
  'message': instance.message,
  'data': instance.data,
};

InsertCounterResponseModel _$InsertCounterResponseModelFromJson(
  Map<String, dynamic> json,
) => InsertCounterResponseModel(
  isSuccess: json['isSuccess'] as bool?,
  statusCode: (json['statusCode'] as num?)?.toInt(),
  message: json['message'] as String?,
);

Map<String, dynamic> _$InsertCounterResponseModelToJson(
  InsertCounterResponseModel instance,
) => <String, dynamic>{
  'isSuccess': instance.isSuccess,
  'statusCode': instance.statusCode,
  'message': instance.message,
};

CounterDataModel _$CounterDataModelFromJson(Map<String, dynamic> json) =>
    CounterDataModel(
      jumlahMotor: (json['jumlahMotor'] as num?)?.toInt(),
      jumlahMobil: (json['jumlahMobil'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CounterDataModelToJson(CounterDataModel instance) =>
    <String, dynamic>{
      'jumlahMotor': instance.jumlahMotor,
      'jumlahMobil': instance.jumlahMobil,
    };
