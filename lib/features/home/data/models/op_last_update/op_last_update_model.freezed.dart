// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'op_last_update_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OpLastUpdateModel _$OpLastUpdateModelFromJson(Map<String, dynamic> json) {
  return _OpLastUpdateModel.fromJson(json);
}

/// @nodoc
mixin _$OpLastUpdateModel {
  bool get isSuccess => throw _privateConstructorUsedError;
  int get statusCode => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String get data => throw _privateConstructorUsedError;

  /// Serializes this OpLastUpdateModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OpLastUpdateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OpLastUpdateModelCopyWith<OpLastUpdateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OpLastUpdateModelCopyWith<$Res> {
  factory $OpLastUpdateModelCopyWith(
    OpLastUpdateModel value,
    $Res Function(OpLastUpdateModel) then,
  ) = _$OpLastUpdateModelCopyWithImpl<$Res, OpLastUpdateModel>;
  @useResult
  $Res call({bool isSuccess, int statusCode, String message, String data});
}

/// @nodoc
class _$OpLastUpdateModelCopyWithImpl<$Res, $Val extends OpLastUpdateModel>
    implements $OpLastUpdateModelCopyWith<$Res> {
  _$OpLastUpdateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OpLastUpdateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSuccess = null,
    Object? statusCode = null,
    Object? message = null,
    Object? data = null,
  }) {
    return _then(
      _value.copyWith(
            isSuccess: null == isSuccess
                ? _value.isSuccess
                : isSuccess // ignore: cast_nullable_to_non_nullable
                      as bool,
            statusCode: null == statusCode
                ? _value.statusCode
                : statusCode // ignore: cast_nullable_to_non_nullable
                      as int,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            data: null == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OpLastUpdateModelImplCopyWith<$Res>
    implements $OpLastUpdateModelCopyWith<$Res> {
  factory _$$OpLastUpdateModelImplCopyWith(
    _$OpLastUpdateModelImpl value,
    $Res Function(_$OpLastUpdateModelImpl) then,
  ) = __$$OpLastUpdateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isSuccess, int statusCode, String message, String data});
}

/// @nodoc
class __$$OpLastUpdateModelImplCopyWithImpl<$Res>
    extends _$OpLastUpdateModelCopyWithImpl<$Res, _$OpLastUpdateModelImpl>
    implements _$$OpLastUpdateModelImplCopyWith<$Res> {
  __$$OpLastUpdateModelImplCopyWithImpl(
    _$OpLastUpdateModelImpl _value,
    $Res Function(_$OpLastUpdateModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OpLastUpdateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSuccess = null,
    Object? statusCode = null,
    Object? message = null,
    Object? data = null,
  }) {
    return _then(
      _$OpLastUpdateModelImpl(
        isSuccess: null == isSuccess
            ? _value.isSuccess
            : isSuccess // ignore: cast_nullable_to_non_nullable
                  as bool,
        statusCode: null == statusCode
            ? _value.statusCode
            : statusCode // ignore: cast_nullable_to_non_nullable
                  as int,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        data: null == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OpLastUpdateModelImpl implements _OpLastUpdateModel {
  const _$OpLastUpdateModelImpl({
    this.isSuccess = false,
    this.statusCode = 0,
    this.message = '',
    this.data = '',
  });

  factory _$OpLastUpdateModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OpLastUpdateModelImplFromJson(json);

  @override
  @JsonKey()
  final bool isSuccess;
  @override
  @JsonKey()
  final int statusCode;
  @override
  @JsonKey()
  final String message;
  @override
  @JsonKey()
  final String data;

  @override
  String toString() {
    return 'OpLastUpdateModel(isSuccess: $isSuccess, statusCode: $statusCode, message: $message, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OpLastUpdateModelImpl &&
            (identical(other.isSuccess, isSuccess) ||
                other.isSuccess == isSuccess) &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, isSuccess, statusCode, message, data);

  /// Create a copy of OpLastUpdateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OpLastUpdateModelImplCopyWith<_$OpLastUpdateModelImpl> get copyWith =>
      __$$OpLastUpdateModelImplCopyWithImpl<_$OpLastUpdateModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OpLastUpdateModelImplToJson(this);
  }
}

abstract class _OpLastUpdateModel implements OpLastUpdateModel {
  const factory _OpLastUpdateModel({
    final bool isSuccess,
    final int statusCode,
    final String message,
    final String data,
  }) = _$OpLastUpdateModelImpl;

  factory _OpLastUpdateModel.fromJson(Map<String, dynamic> json) =
      _$OpLastUpdateModelImpl.fromJson;

  @override
  bool get isSuccess;
  @override
  int get statusCode;
  @override
  String get message;
  @override
  String get data;

  /// Create a copy of OpLastUpdateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OpLastUpdateModelImplCopyWith<_$OpLastUpdateModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
