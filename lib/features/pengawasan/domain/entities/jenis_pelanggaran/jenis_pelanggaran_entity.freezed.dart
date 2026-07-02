// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'jenis_pelanggaran_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$JenisPelanggaranEntity {
  int get id => throw _privateConstructorUsedError;
  String get nama => throw _privateConstructorUsedError;

  /// Create a copy of JenisPelanggaranEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JenisPelanggaranEntityCopyWith<JenisPelanggaranEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JenisPelanggaranEntityCopyWith<$Res> {
  factory $JenisPelanggaranEntityCopyWith(
    JenisPelanggaranEntity value,
    $Res Function(JenisPelanggaranEntity) then,
  ) = _$JenisPelanggaranEntityCopyWithImpl<$Res, JenisPelanggaranEntity>;
  @useResult
  $Res call({int id, String nama});
}

/// @nodoc
class _$JenisPelanggaranEntityCopyWithImpl<
  $Res,
  $Val extends JenisPelanggaranEntity
>
    implements $JenisPelanggaranEntityCopyWith<$Res> {
  _$JenisPelanggaranEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JenisPelanggaranEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? nama = null}) {
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$JenisPelanggaranEntityImplCopyWith<$Res>
    implements $JenisPelanggaranEntityCopyWith<$Res> {
  factory _$$JenisPelanggaranEntityImplCopyWith(
    _$JenisPelanggaranEntityImpl value,
    $Res Function(_$JenisPelanggaranEntityImpl) then,
  ) = __$$JenisPelanggaranEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String nama});
}

/// @nodoc
class __$$JenisPelanggaranEntityImplCopyWithImpl<$Res>
    extends
        _$JenisPelanggaranEntityCopyWithImpl<$Res, _$JenisPelanggaranEntityImpl>
    implements _$$JenisPelanggaranEntityImplCopyWith<$Res> {
  __$$JenisPelanggaranEntityImplCopyWithImpl(
    _$JenisPelanggaranEntityImpl _value,
    $Res Function(_$JenisPelanggaranEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JenisPelanggaranEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? nama = null}) {
    return _then(
      _$JenisPelanggaranEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        nama: null == nama
            ? _value.nama
            : nama // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$JenisPelanggaranEntityImpl implements _JenisPelanggaranEntity {
  const _$JenisPelanggaranEntityImpl({required this.id, required this.nama});

  @override
  final int id;
  @override
  final String nama;

  @override
  String toString() {
    return 'JenisPelanggaranEntity(id: $id, nama: $nama)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JenisPelanggaranEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nama, nama) || other.nama == nama));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, nama);

  /// Create a copy of JenisPelanggaranEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JenisPelanggaranEntityImplCopyWith<_$JenisPelanggaranEntityImpl>
  get copyWith =>
      __$$JenisPelanggaranEntityImplCopyWithImpl<_$JenisPelanggaranEntityImpl>(
        this,
        _$identity,
      );
}

abstract class _JenisPelanggaranEntity implements JenisPelanggaranEntity {
  const factory _JenisPelanggaranEntity({
    required final int id,
    required final String nama,
  }) = _$JenisPelanggaranEntityImpl;

  @override
  int get id;
  @override
  String get nama;

  /// Create a copy of JenisPelanggaranEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JenisPelanggaranEntityImplCopyWith<_$JenisPelanggaranEntityImpl>
  get copyWith => throw _privateConstructorUsedError;
}
