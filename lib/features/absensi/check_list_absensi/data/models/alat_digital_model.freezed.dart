// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alat_digital_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AlatDigitalModel _$AlatDigitalModelFromJson(Map<String, dynamic> json) {
  return _AlatDigitalModel.fromJson(json);
}

/// @nodoc
mixin _$AlatDigitalModel {
  int get id => throw _privateConstructorUsedError;
  String get nama => throw _privateConstructorUsedError;
  int get jenis => throw _privateConstructorUsedError;

  /// Serializes this AlatDigitalModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AlatDigitalModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlatDigitalModelCopyWith<AlatDigitalModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlatDigitalModelCopyWith<$Res> {
  factory $AlatDigitalModelCopyWith(
    AlatDigitalModel value,
    $Res Function(AlatDigitalModel) then,
  ) = _$AlatDigitalModelCopyWithImpl<$Res, AlatDigitalModel>;
  @useResult
  $Res call({int id, String nama, int jenis});
}

/// @nodoc
class _$AlatDigitalModelCopyWithImpl<$Res, $Val extends AlatDigitalModel>
    implements $AlatDigitalModelCopyWith<$Res> {
  _$AlatDigitalModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AlatDigitalModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? nama = null, Object? jenis = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            nama: null == nama
                ? _value.nama
                : nama // ignore: cast_nullable_to_non_nullable
                      as String,
            jenis: null == jenis
                ? _value.jenis
                : jenis // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AlatDigitalModelImplCopyWith<$Res>
    implements $AlatDigitalModelCopyWith<$Res> {
  factory _$$AlatDigitalModelImplCopyWith(
    _$AlatDigitalModelImpl value,
    $Res Function(_$AlatDigitalModelImpl) then,
  ) = __$$AlatDigitalModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String nama, int jenis});
}

/// @nodoc
class __$$AlatDigitalModelImplCopyWithImpl<$Res>
    extends _$AlatDigitalModelCopyWithImpl<$Res, _$AlatDigitalModelImpl>
    implements _$$AlatDigitalModelImplCopyWith<$Res> {
  __$$AlatDigitalModelImplCopyWithImpl(
    _$AlatDigitalModelImpl _value,
    $Res Function(_$AlatDigitalModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AlatDigitalModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? nama = null, Object? jenis = null}) {
    return _then(
      _$AlatDigitalModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        nama: null == nama
            ? _value.nama
            : nama // ignore: cast_nullable_to_non_nullable
                  as String,
        jenis: null == jenis
            ? _value.jenis
            : jenis // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AlatDigitalModelImpl extends _AlatDigitalModel {
  const _$AlatDigitalModelImpl({this.id = 0, this.nama = '', this.jenis = 0})
    : super._();

  factory _$AlatDigitalModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlatDigitalModelImplFromJson(json);

  @override
  @JsonKey()
  final int id;
  @override
  @JsonKey()
  final String nama;
  @override
  @JsonKey()
  final int jenis;

  @override
  String toString() {
    return 'AlatDigitalModel(id: $id, nama: $nama, jenis: $jenis)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlatDigitalModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nama, nama) || other.nama == nama) &&
            (identical(other.jenis, jenis) || other.jenis == jenis));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, nama, jenis);

  /// Create a copy of AlatDigitalModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlatDigitalModelImplCopyWith<_$AlatDigitalModelImpl> get copyWith =>
      __$$AlatDigitalModelImplCopyWithImpl<_$AlatDigitalModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AlatDigitalModelImplToJson(this);
  }
}

abstract class _AlatDigitalModel extends AlatDigitalModel {
  const factory _AlatDigitalModel({
    final int id,
    final String nama,
    final int jenis,
  }) = _$AlatDigitalModelImpl;
  const _AlatDigitalModel._() : super._();

  factory _AlatDigitalModel.fromJson(Map<String, dynamic> json) =
      _$AlatDigitalModelImpl.fromJson;

  @override
  int get id;
  @override
  String get nama;
  @override
  int get jenis;

  /// Create a copy of AlatDigitalModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlatDigitalModelImplCopyWith<_$AlatDigitalModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
