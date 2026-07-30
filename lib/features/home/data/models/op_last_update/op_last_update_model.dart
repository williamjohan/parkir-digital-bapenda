import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parkir_digital_bapenda/features/home/domain/entities/op_last_update_entity.dart';

part 'op_last_update_model.freezed.dart';
part 'op_last_update_model.g.dart';

/// 1. CLASS UTAMA (ROOT RESPONSE)
@freezed
class OpLastUpdateModel with _$OpLastUpdateModel {
  const factory OpLastUpdateModel({
    @Default(false) bool isSuccess,
    @Default(0) int statusCode,
    @Default('') String message,
    @Default('') String data,
  }) = _OpLastUpdateModel;

  factory OpLastUpdateModel.fromJson(Map<String, dynamic> json) =>
      _$OpLastUpdateModelFromJson(json);
}

extension OpLastUpdateModelExt on OpLastUpdateModel {
  OpLastUpdateEntity toEntity() {
    return OpLastUpdateEntity(
      isSuccess: isSuccess,
      statusCode: statusCode,
      message: message,
      data: data,
    );
  }
}
