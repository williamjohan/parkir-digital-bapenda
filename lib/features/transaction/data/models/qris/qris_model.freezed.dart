// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'qris_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

QrisResponseModel _$QrisResponseModelFromJson(Map<String, dynamic> json) {
  return _QrisResponseModel.fromJson(json);
}

/// @nodoc
mixin _$QrisResponseModel {
  int get jenisKendaraanId => throw _privateConstructorUsedError;
  String get qrisImageBase64 => throw _privateConstructorUsedError;
  String get kodeQris => throw _privateConstructorUsedError;

  /// Serializes this QrisResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QrisResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QrisResponseModelCopyWith<QrisResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QrisResponseModelCopyWith<$Res> {
  factory $QrisResponseModelCopyWith(
    QrisResponseModel value,
    $Res Function(QrisResponseModel) then,
  ) = _$QrisResponseModelCopyWithImpl<$Res, QrisResponseModel>;
  @useResult
  $Res call({int jenisKendaraanId, String qrisImageBase64, String kodeQris});
}

/// @nodoc
class _$QrisResponseModelCopyWithImpl<$Res, $Val extends QrisResponseModel>
    implements $QrisResponseModelCopyWith<$Res> {
  _$QrisResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QrisResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? jenisKendaraanId = null,
    Object? qrisImageBase64 = null,
    Object? kodeQris = null,
  }) {
    return _then(
      _value.copyWith(
            jenisKendaraanId: null == jenisKendaraanId
                ? _value.jenisKendaraanId
                : jenisKendaraanId // ignore: cast_nullable_to_non_nullable
                      as int,
            qrisImageBase64: null == qrisImageBase64
                ? _value.qrisImageBase64
                : qrisImageBase64 // ignore: cast_nullable_to_non_nullable
                      as String,
            kodeQris: null == kodeQris
                ? _value.kodeQris
                : kodeQris // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QrisResponseModelImplCopyWith<$Res>
    implements $QrisResponseModelCopyWith<$Res> {
  factory _$$QrisResponseModelImplCopyWith(
    _$QrisResponseModelImpl value,
    $Res Function(_$QrisResponseModelImpl) then,
  ) = __$$QrisResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int jenisKendaraanId, String qrisImageBase64, String kodeQris});
}

/// @nodoc
class __$$QrisResponseModelImplCopyWithImpl<$Res>
    extends _$QrisResponseModelCopyWithImpl<$Res, _$QrisResponseModelImpl>
    implements _$$QrisResponseModelImplCopyWith<$Res> {
  __$$QrisResponseModelImplCopyWithImpl(
    _$QrisResponseModelImpl _value,
    $Res Function(_$QrisResponseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QrisResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? jenisKendaraanId = null,
    Object? qrisImageBase64 = null,
    Object? kodeQris = null,
  }) {
    return _then(
      _$QrisResponseModelImpl(
        jenisKendaraanId: null == jenisKendaraanId
            ? _value.jenisKendaraanId
            : jenisKendaraanId // ignore: cast_nullable_to_non_nullable
                  as int,
        qrisImageBase64: null == qrisImageBase64
            ? _value.qrisImageBase64
            : qrisImageBase64 // ignore: cast_nullable_to_non_nullable
                  as String,
        kodeQris: null == kodeQris
            ? _value.kodeQris
            : kodeQris // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QrisResponseModelImpl implements _QrisResponseModel {
  const _$QrisResponseModelImpl({
    this.jenisKendaraanId = 0,
    this.qrisImageBase64 = '',
    this.kodeQris = '',
  });

  factory _$QrisResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$QrisResponseModelImplFromJson(json);

  @override
  @JsonKey()
  final int jenisKendaraanId;
  @override
  @JsonKey()
  final String qrisImageBase64;
  @override
  @JsonKey()
  final String kodeQris;

  @override
  String toString() {
    return 'QrisResponseModel(jenisKendaraanId: $jenisKendaraanId, qrisImageBase64: $qrisImageBase64, kodeQris: $kodeQris)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QrisResponseModelImpl &&
            (identical(other.jenisKendaraanId, jenisKendaraanId) ||
                other.jenisKendaraanId == jenisKendaraanId) &&
            (identical(other.qrisImageBase64, qrisImageBase64) ||
                other.qrisImageBase64 == qrisImageBase64) &&
            (identical(other.kodeQris, kodeQris) ||
                other.kodeQris == kodeQris));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, jenisKendaraanId, qrisImageBase64, kodeQris);

  /// Create a copy of QrisResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QrisResponseModelImplCopyWith<_$QrisResponseModelImpl> get copyWith =>
      __$$QrisResponseModelImplCopyWithImpl<_$QrisResponseModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$QrisResponseModelImplToJson(this);
  }
}

abstract class _QrisResponseModel implements QrisResponseModel {
  const factory _QrisResponseModel({
    final int jenisKendaraanId,
    final String qrisImageBase64,
    final String kodeQris,
  }) = _$QrisResponseModelImpl;

  factory _QrisResponseModel.fromJson(Map<String, dynamic> json) =
      _$QrisResponseModelImpl.fromJson;

  @override
  int get jenisKendaraanId;
  @override
  String get qrisImageBase64;
  @override
  String get kodeQris;

  /// Create a copy of QrisResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QrisResponseModelImplCopyWith<_$QrisResponseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QrisLocalModel _$QrisLocalModelFromJson(Map<String, dynamic> json) {
  return _QrisLocalModel.fromJson(json);
}

/// @nodoc
mixin _$QrisLocalModel {
  String get path => throw _privateConstructorUsedError;
  String get kodeQris => throw _privateConstructorUsedError;

  /// Serializes this QrisLocalModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QrisLocalModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QrisLocalModelCopyWith<QrisLocalModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QrisLocalModelCopyWith<$Res> {
  factory $QrisLocalModelCopyWith(
    QrisLocalModel value,
    $Res Function(QrisLocalModel) then,
  ) = _$QrisLocalModelCopyWithImpl<$Res, QrisLocalModel>;
  @useResult
  $Res call({String path, String kodeQris});
}

/// @nodoc
class _$QrisLocalModelCopyWithImpl<$Res, $Val extends QrisLocalModel>
    implements $QrisLocalModelCopyWith<$Res> {
  _$QrisLocalModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QrisLocalModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? path = null, Object? kodeQris = null}) {
    return _then(
      _value.copyWith(
            path: null == path
                ? _value.path
                : path // ignore: cast_nullable_to_non_nullable
                      as String,
            kodeQris: null == kodeQris
                ? _value.kodeQris
                : kodeQris // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QrisLocalModelImplCopyWith<$Res>
    implements $QrisLocalModelCopyWith<$Res> {
  factory _$$QrisLocalModelImplCopyWith(
    _$QrisLocalModelImpl value,
    $Res Function(_$QrisLocalModelImpl) then,
  ) = __$$QrisLocalModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String path, String kodeQris});
}

/// @nodoc
class __$$QrisLocalModelImplCopyWithImpl<$Res>
    extends _$QrisLocalModelCopyWithImpl<$Res, _$QrisLocalModelImpl>
    implements _$$QrisLocalModelImplCopyWith<$Res> {
  __$$QrisLocalModelImplCopyWithImpl(
    _$QrisLocalModelImpl _value,
    $Res Function(_$QrisLocalModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QrisLocalModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? path = null, Object? kodeQris = null}) {
    return _then(
      _$QrisLocalModelImpl(
        path: null == path
            ? _value.path
            : path // ignore: cast_nullable_to_non_nullable
                  as String,
        kodeQris: null == kodeQris
            ? _value.kodeQris
            : kodeQris // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QrisLocalModelImpl implements _QrisLocalModel {
  const _$QrisLocalModelImpl({this.path = '', this.kodeQris = ''});

  factory _$QrisLocalModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$QrisLocalModelImplFromJson(json);

  @override
  @JsonKey()
  final String path;
  @override
  @JsonKey()
  final String kodeQris;

  @override
  String toString() {
    return 'QrisLocalModel(path: $path, kodeQris: $kodeQris)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QrisLocalModelImpl &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.kodeQris, kodeQris) ||
                other.kodeQris == kodeQris));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, path, kodeQris);

  /// Create a copy of QrisLocalModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QrisLocalModelImplCopyWith<_$QrisLocalModelImpl> get copyWith =>
      __$$QrisLocalModelImplCopyWithImpl<_$QrisLocalModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$QrisLocalModelImplToJson(this);
  }
}

abstract class _QrisLocalModel implements QrisLocalModel {
  const factory _QrisLocalModel({final String path, final String kodeQris}) =
      _$QrisLocalModelImpl;

  factory _QrisLocalModel.fromJson(Map<String, dynamic> json) =
      _$QrisLocalModelImpl.fromJson;

  @override
  String get path;
  @override
  String get kodeQris;

  /// Create a copy of QrisLocalModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QrisLocalModelImplCopyWith<_$QrisLocalModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
