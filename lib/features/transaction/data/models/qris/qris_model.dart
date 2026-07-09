import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/qris_entity.dart';

part 'qris_model.freezed.dart';
part 'qris_model.g.dart';

@freezed
class QrisResponseModel with _$QrisResponseModel {
  const factory QrisResponseModel({
    @Default(0) int jenisKendaraanId,
    @Default('') String qrisImageBase64,
    @Default('') String kodeQris,
  }) = _QrisResponseModel;

  factory QrisResponseModel.fromJson(Map<String, dynamic> json) =>
      _$QrisResponseModelFromJson(json);
}

@freezed
class QrisLocalModel with _$QrisLocalModel {
  const factory QrisLocalModel({
    @Default('') String path,
    @Default('') String kodeQris,
  }) = _QrisLocalModel;

  factory QrisLocalModel.fromJson(Map<String, dynamic> json) =>
      _$QrisLocalModelFromJson(json);
}

extension QrisLocalModelExt on QrisLocalModel {
  QrisLocalEntity toEntity() {
    return QrisLocalEntity(path: path, kodeQris: kodeQris);
  }
}

extension QrisResponseModelExt on QrisResponseModel {
  QrisResponseEntity toEntity() {
    return QrisResponseEntity(
      jenisKendaraanId: jenisKendaraanId,
      qrisImageBase64: qrisImageBase64,
      kodeQris: kodeQris,
    );
  }
}
