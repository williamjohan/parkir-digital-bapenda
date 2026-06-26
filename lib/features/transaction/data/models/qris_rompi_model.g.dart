part of 'qris_rompi_model.dart';

QrisRompiModel _$QrisRompiModelFromJson(Map<String, dynamic> json) =>
    QrisRompiModel(
      jenisKendaraanId: (json['jenisKendaraanId'] as num?)?.toInt() ?? 0,
      qrisImageBase64: json['qrisImageBase64'] as String? ?? '',
    );

Map<String, dynamic> _$QrisRompiModelToJson(QrisRompiModel instance) =>
    <String, dynamic>{
      'jenisKendaraanId': instance.jenisKendaraanId,
      'qrisImageBase64': instance.qrisImageBase64,
    };
