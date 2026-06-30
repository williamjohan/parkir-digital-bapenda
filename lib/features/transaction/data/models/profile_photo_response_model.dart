import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_photo_response_model.freezed.dart';
part 'profile_photo_response_model.g.dart';

@freezed
class ProfilePhotoResponseModel with _$ProfilePhotoResponseModel {
  const factory ProfilePhotoResponseModel({@Default('') String fotoPostcard}) =
      _ProfilePhotoResponseModel;

  factory ProfilePhotoResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ProfilePhotoResponseModelFromJson(json);
}
