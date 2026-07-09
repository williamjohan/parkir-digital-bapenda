import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_response_model.freezed.dart';
part 'auth_response_model.g.dart';

@freezed
class AuthResponseModel with _$AuthResponseModel {
  const factory AuthResponseModel({
    @Default('') String accessToken,
    @Default('') String nop,
    @Default('') String uuidStatic,
    @Default(0) int roleLoginId,
    @Default(0) int pungutTarif,
    @Default([]) List<NopModel> nopList,
    OpPengawasAuthModel? opPengawas,
  }) = _AuthResponseModel;

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);
}

@freezed
class NopModel with _$NopModel {
  const factory NopModel({
    @Default('') String nop,
    @Default('') String namaOp,
    @Default('') String alamatOp,
    @Default(false) bool isDigital,
    @Default(0) int pungutTarif,
    @Default(0) int uptb,
    @Default('') String kdCamat,
    @Default('') String nmCamat,
    @Default('') String kdLurah,
    @Default('') String nmLurah,
  }) = _NopModel;

  factory NopModel.fromJson(Map<String, dynamic> json) =>
      _$NopModelFromJson(json);
}

@freezed
class OpPengawasAuthModel with _$OpPengawasAuthModel {
  const factory OpPengawasAuthModel({
    @Default(0) int idEvent,
    @Default('') String op,
    @Default('') String nip,
    @Default(false) bool isPresent,
    // (Bisa tambahkan field lain jika memang diperlukan untuk logic UI Auth/Splash)
  }) = _OpPengawasAuthModel;

  factory OpPengawasAuthModel.fromJson(Map<String, dynamic> json) =>
      _$OpPengawasAuthModelFromJson(json);
}
