// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_photo_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProfilePhotoResponseModel _$ProfilePhotoResponseModelFromJson(
  Map<String, dynamic> json,
) {
  return _ProfilePhotoResponseModel.fromJson(json);
}

/// @nodoc
mixin _$ProfilePhotoResponseModel {
  String get fotoPostcard => throw _privateConstructorUsedError;

  /// Serializes this ProfilePhotoResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProfilePhotoResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfilePhotoResponseModelCopyWith<ProfilePhotoResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfilePhotoResponseModelCopyWith<$Res> {
  factory $ProfilePhotoResponseModelCopyWith(
    ProfilePhotoResponseModel value,
    $Res Function(ProfilePhotoResponseModel) then,
  ) = _$ProfilePhotoResponseModelCopyWithImpl<$Res, ProfilePhotoResponseModel>;
  @useResult
  $Res call({String fotoPostcard});
}

/// @nodoc
class _$ProfilePhotoResponseModelCopyWithImpl<
  $Res,
  $Val extends ProfilePhotoResponseModel
>
    implements $ProfilePhotoResponseModelCopyWith<$Res> {
  _$ProfilePhotoResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfilePhotoResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? fotoPostcard = null}) {
    return _then(
      _value.copyWith(
            fotoPostcard: null == fotoPostcard
                ? _value.fotoPostcard
                : fotoPostcard // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProfilePhotoResponseModelImplCopyWith<$Res>
    implements $ProfilePhotoResponseModelCopyWith<$Res> {
  factory _$$ProfilePhotoResponseModelImplCopyWith(
    _$ProfilePhotoResponseModelImpl value,
    $Res Function(_$ProfilePhotoResponseModelImpl) then,
  ) = __$$ProfilePhotoResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String fotoPostcard});
}

/// @nodoc
class __$$ProfilePhotoResponseModelImplCopyWithImpl<$Res>
    extends
        _$ProfilePhotoResponseModelCopyWithImpl<
          $Res,
          _$ProfilePhotoResponseModelImpl
        >
    implements _$$ProfilePhotoResponseModelImplCopyWith<$Res> {
  __$$ProfilePhotoResponseModelImplCopyWithImpl(
    _$ProfilePhotoResponseModelImpl _value,
    $Res Function(_$ProfilePhotoResponseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProfilePhotoResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? fotoPostcard = null}) {
    return _then(
      _$ProfilePhotoResponseModelImpl(
        fotoPostcard: null == fotoPostcard
            ? _value.fotoPostcard
            : fotoPostcard // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfilePhotoResponseModelImpl implements _ProfilePhotoResponseModel {
  const _$ProfilePhotoResponseModelImpl({this.fotoPostcard = ''});

  factory _$ProfilePhotoResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfilePhotoResponseModelImplFromJson(json);

  @override
  @JsonKey()
  final String fotoPostcard;

  @override
  String toString() {
    return 'ProfilePhotoResponseModel(fotoPostcard: $fotoPostcard)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfilePhotoResponseModelImpl &&
            (identical(other.fotoPostcard, fotoPostcard) ||
                other.fotoPostcard == fotoPostcard));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, fotoPostcard);

  /// Create a copy of ProfilePhotoResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfilePhotoResponseModelImplCopyWith<_$ProfilePhotoResponseModelImpl>
  get copyWith =>
      __$$ProfilePhotoResponseModelImplCopyWithImpl<
        _$ProfilePhotoResponseModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfilePhotoResponseModelImplToJson(this);
  }
}

abstract class _ProfilePhotoResponseModel implements ProfilePhotoResponseModel {
  const factory _ProfilePhotoResponseModel({final String fotoPostcard}) =
      _$ProfilePhotoResponseModelImpl;

  factory _ProfilePhotoResponseModel.fromJson(Map<String, dynamic> json) =
      _$ProfilePhotoResponseModelImpl.fromJson;

  @override
  String get fotoPostcard;

  /// Create a copy of ProfilePhotoResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfilePhotoResponseModelImplCopyWith<_$ProfilePhotoResponseModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
