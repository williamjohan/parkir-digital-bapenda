// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'qris_rompi_request_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$QrisRompiRequestEntity {
  String get nop => throw _privateConstructorUsedError;
  String get jukirUsername => throw _privateConstructorUsedError;
  String get idDevice => throw _privateConstructorUsedError;
  JenisKendaraan get jenisKendaraan => throw _privateConstructorUsedError;

  /// Create a copy of QrisRompiRequestEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QrisRompiRequestEntityCopyWith<QrisRompiRequestEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QrisRompiRequestEntityCopyWith<$Res> {
  factory $QrisRompiRequestEntityCopyWith(
    QrisRompiRequestEntity value,
    $Res Function(QrisRompiRequestEntity) then,
  ) = _$QrisRompiRequestEntityCopyWithImpl<$Res, QrisRompiRequestEntity>;
  @useResult
  $Res call({
    String nop,
    String jukirUsername,
    String idDevice,
    JenisKendaraan jenisKendaraan,
  });
}

/// @nodoc
class _$QrisRompiRequestEntityCopyWithImpl<
  $Res,
  $Val extends QrisRompiRequestEntity
>
    implements $QrisRompiRequestEntityCopyWith<$Res> {
  _$QrisRompiRequestEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QrisRompiRequestEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nop = null,
    Object? jukirUsername = null,
    Object? idDevice = null,
    Object? jenisKendaraan = null,
  }) {
    return _then(
      _value.copyWith(
            nop: null == nop
                ? _value.nop
                : nop // ignore: cast_nullable_to_non_nullable
                      as String,
            jukirUsername: null == jukirUsername
                ? _value.jukirUsername
                : jukirUsername // ignore: cast_nullable_to_non_nullable
                      as String,
            idDevice: null == idDevice
                ? _value.idDevice
                : idDevice // ignore: cast_nullable_to_non_nullable
                      as String,
            jenisKendaraan: null == jenisKendaraan
                ? _value.jenisKendaraan
                : jenisKendaraan // ignore: cast_nullable_to_non_nullable
                      as JenisKendaraan,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QrisRompiRequestEntityImplCopyWith<$Res>
    implements $QrisRompiRequestEntityCopyWith<$Res> {
  factory _$$QrisRompiRequestEntityImplCopyWith(
    _$QrisRompiRequestEntityImpl value,
    $Res Function(_$QrisRompiRequestEntityImpl) then,
  ) = __$$QrisRompiRequestEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String nop,
    String jukirUsername,
    String idDevice,
    JenisKendaraan jenisKendaraan,
  });
}

/// @nodoc
class __$$QrisRompiRequestEntityImplCopyWithImpl<$Res>
    extends
        _$QrisRompiRequestEntityCopyWithImpl<$Res, _$QrisRompiRequestEntityImpl>
    implements _$$QrisRompiRequestEntityImplCopyWith<$Res> {
  __$$QrisRompiRequestEntityImplCopyWithImpl(
    _$QrisRompiRequestEntityImpl _value,
    $Res Function(_$QrisRompiRequestEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QrisRompiRequestEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nop = null,
    Object? jukirUsername = null,
    Object? idDevice = null,
    Object? jenisKendaraan = null,
  }) {
    return _then(
      _$QrisRompiRequestEntityImpl(
        nop: null == nop
            ? _value.nop
            : nop // ignore: cast_nullable_to_non_nullable
                  as String,
        jukirUsername: null == jukirUsername
            ? _value.jukirUsername
            : jukirUsername // ignore: cast_nullable_to_non_nullable
                  as String,
        idDevice: null == idDevice
            ? _value.idDevice
            : idDevice // ignore: cast_nullable_to_non_nullable
                  as String,
        jenisKendaraan: null == jenisKendaraan
            ? _value.jenisKendaraan
            : jenisKendaraan // ignore: cast_nullable_to_non_nullable
                  as JenisKendaraan,
      ),
    );
  }
}

/// @nodoc

class _$QrisRompiRequestEntityImpl implements _QrisRompiRequestEntity {
  const _$QrisRompiRequestEntityImpl({
    required this.nop,
    required this.jukirUsername,
    required this.idDevice,
    required this.jenisKendaraan,
  });

  @override
  final String nop;
  @override
  final String jukirUsername;
  @override
  final String idDevice;
  @override
  final JenisKendaraan jenisKendaraan;

  @override
  String toString() {
    return 'QrisRompiRequestEntity(nop: $nop, jukirUsername: $jukirUsername, idDevice: $idDevice, jenisKendaraan: $jenisKendaraan)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QrisRompiRequestEntityImpl &&
            (identical(other.nop, nop) || other.nop == nop) &&
            (identical(other.jukirUsername, jukirUsername) ||
                other.jukirUsername == jukirUsername) &&
            (identical(other.idDevice, idDevice) ||
                other.idDevice == idDevice) &&
            (identical(other.jenisKendaraan, jenisKendaraan) ||
                other.jenisKendaraan == jenisKendaraan));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, nop, jukirUsername, idDevice, jenisKendaraan);

  /// Create a copy of QrisRompiRequestEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QrisRompiRequestEntityImplCopyWith<_$QrisRompiRequestEntityImpl>
  get copyWith =>
      __$$QrisRompiRequestEntityImplCopyWithImpl<_$QrisRompiRequestEntityImpl>(
        this,
        _$identity,
      );
}

abstract class _QrisRompiRequestEntity implements QrisRompiRequestEntity {
  const factory _QrisRompiRequestEntity({
    required final String nop,
    required final String jukirUsername,
    required final String idDevice,
    required final JenisKendaraan jenisKendaraan,
  }) = _$QrisRompiRequestEntityImpl;

  @override
  String get nop;
  @override
  String get jukirUsername;
  @override
  String get idDevice;
  @override
  JenisKendaraan get jenisKendaraan;

  /// Create a copy of QrisRompiRequestEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QrisRompiRequestEntityImplCopyWith<_$QrisRompiRequestEntityImpl>
  get copyWith => throw _privateConstructorUsedError;
}
