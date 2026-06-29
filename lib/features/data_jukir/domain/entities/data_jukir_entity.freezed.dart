// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'data_jukir_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DataJukirEntity {
  String get nop => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get deviceId => throw _privateConstructorUsedError;
  String get namaPetugas => throw _privateConstructorUsedError;
  String get shift => throw _privateConstructorUsedError;

  /// Create a copy of DataJukirEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DataJukirEntityCopyWith<DataJukirEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DataJukirEntityCopyWith<$Res> {
  factory $DataJukirEntityCopyWith(
    DataJukirEntity value,
    $Res Function(DataJukirEntity) then,
  ) = _$DataJukirEntityCopyWithImpl<$Res, DataJukirEntity>;
  @useResult
  $Res call({
    String nop,
    String username,
    String deviceId,
    String namaPetugas,
    String shift,
  });
}

/// @nodoc
class _$DataJukirEntityCopyWithImpl<$Res, $Val extends DataJukirEntity>
    implements $DataJukirEntityCopyWith<$Res> {
  _$DataJukirEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DataJukirEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nop = null,
    Object? username = null,
    Object? deviceId = null,
    Object? namaPetugas = null,
    Object? shift = null,
  }) {
    return _then(
      _value.copyWith(
            nop: null == nop
                ? _value.nop
                : nop // ignore: cast_nullable_to_non_nullable
                      as String,
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            deviceId: null == deviceId
                ? _value.deviceId
                : deviceId // ignore: cast_nullable_to_non_nullable
                      as String,
            namaPetugas: null == namaPetugas
                ? _value.namaPetugas
                : namaPetugas // ignore: cast_nullable_to_non_nullable
                      as String,
            shift: null == shift
                ? _value.shift
                : shift // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DataJukirEntityImplCopyWith<$Res>
    implements $DataJukirEntityCopyWith<$Res> {
  factory _$$DataJukirEntityImplCopyWith(
    _$DataJukirEntityImpl value,
    $Res Function(_$DataJukirEntityImpl) then,
  ) = __$$DataJukirEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String nop,
    String username,
    String deviceId,
    String namaPetugas,
    String shift,
  });
}

/// @nodoc
class __$$DataJukirEntityImplCopyWithImpl<$Res>
    extends _$DataJukirEntityCopyWithImpl<$Res, _$DataJukirEntityImpl>
    implements _$$DataJukirEntityImplCopyWith<$Res> {
  __$$DataJukirEntityImplCopyWithImpl(
    _$DataJukirEntityImpl _value,
    $Res Function(_$DataJukirEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DataJukirEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nop = null,
    Object? username = null,
    Object? deviceId = null,
    Object? namaPetugas = null,
    Object? shift = null,
  }) {
    return _then(
      _$DataJukirEntityImpl(
        nop: null == nop
            ? _value.nop
            : nop // ignore: cast_nullable_to_non_nullable
                  as String,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        deviceId: null == deviceId
            ? _value.deviceId
            : deviceId // ignore: cast_nullable_to_non_nullable
                  as String,
        namaPetugas: null == namaPetugas
            ? _value.namaPetugas
            : namaPetugas // ignore: cast_nullable_to_non_nullable
                  as String,
        shift: null == shift
            ? _value.shift
            : shift // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$DataJukirEntityImpl implements _DataJukirEntity {
  const _$DataJukirEntityImpl({
    required this.nop,
    required this.username,
    required this.deviceId,
    required this.namaPetugas,
    required this.shift,
  });

  @override
  final String nop;
  @override
  final String username;
  @override
  final String deviceId;
  @override
  final String namaPetugas;
  @override
  final String shift;

  @override
  String toString() {
    return 'DataJukirEntity(nop: $nop, username: $username, deviceId: $deviceId, namaPetugas: $namaPetugas, shift: $shift)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DataJukirEntityImpl &&
            (identical(other.nop, nop) || other.nop == nop) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.namaPetugas, namaPetugas) ||
                other.namaPetugas == namaPetugas) &&
            (identical(other.shift, shift) || other.shift == shift));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, nop, username, deviceId, namaPetugas, shift);

  /// Create a copy of DataJukirEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DataJukirEntityImplCopyWith<_$DataJukirEntityImpl> get copyWith =>
      __$$DataJukirEntityImplCopyWithImpl<_$DataJukirEntityImpl>(
        this,
        _$identity,
      );
}

abstract class _DataJukirEntity implements DataJukirEntity {
  const factory _DataJukirEntity({
    required final String nop,
    required final String username,
    required final String deviceId,
    required final String namaPetugas,
    required final String shift,
  }) = _$DataJukirEntityImpl;

  @override
  String get nop;
  @override
  String get username;
  @override
  String get deviceId;
  @override
  String get namaPetugas;
  @override
  String get shift;

  /// Create a copy of DataJukirEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DataJukirEntityImplCopyWith<_$DataJukirEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
