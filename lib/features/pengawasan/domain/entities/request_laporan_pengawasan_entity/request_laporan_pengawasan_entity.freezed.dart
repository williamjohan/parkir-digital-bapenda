// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_laporan_pengawasan_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$RequestLaporanPengawasanEntity {
  int get jenisPel => throw _privateConstructorUsedError;
  String get ketPel => throw _privateConstructorUsedError;
  File? get buktiFoto => throw _privateConstructorUsedError;

  /// Create a copy of RequestLaporanPengawasanEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RequestLaporanPengawasanEntityCopyWith<RequestLaporanPengawasanEntity>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RequestLaporanPengawasanEntityCopyWith<$Res> {
  factory $RequestLaporanPengawasanEntityCopyWith(
    RequestLaporanPengawasanEntity value,
    $Res Function(RequestLaporanPengawasanEntity) then,
  ) =
      _$RequestLaporanPengawasanEntityCopyWithImpl<
        $Res,
        RequestLaporanPengawasanEntity
      >;
  @useResult
  $Res call({int jenisPel, String ketPel, File? buktiFoto});
}

/// @nodoc
class _$RequestLaporanPengawasanEntityCopyWithImpl<
  $Res,
  $Val extends RequestLaporanPengawasanEntity
>
    implements $RequestLaporanPengawasanEntityCopyWith<$Res> {
  _$RequestLaporanPengawasanEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RequestLaporanPengawasanEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? jenisPel = null,
    Object? ketPel = null,
    Object? buktiFoto = freezed,
  }) {
    return _then(
      _value.copyWith(
            jenisPel: null == jenisPel
                ? _value.jenisPel
                : jenisPel // ignore: cast_nullable_to_non_nullable
                      as int,
            ketPel: null == ketPel
                ? _value.ketPel
                : ketPel // ignore: cast_nullable_to_non_nullable
                      as String,
            buktiFoto: freezed == buktiFoto
                ? _value.buktiFoto
                : buktiFoto // ignore: cast_nullable_to_non_nullable
                      as File?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RequestLaporanPengawasanEntityImplCopyWith<$Res>
    implements $RequestLaporanPengawasanEntityCopyWith<$Res> {
  factory _$$RequestLaporanPengawasanEntityImplCopyWith(
    _$RequestLaporanPengawasanEntityImpl value,
    $Res Function(_$RequestLaporanPengawasanEntityImpl) then,
  ) = __$$RequestLaporanPengawasanEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int jenisPel, String ketPel, File? buktiFoto});
}

/// @nodoc
class __$$RequestLaporanPengawasanEntityImplCopyWithImpl<$Res>
    extends
        _$RequestLaporanPengawasanEntityCopyWithImpl<
          $Res,
          _$RequestLaporanPengawasanEntityImpl
        >
    implements _$$RequestLaporanPengawasanEntityImplCopyWith<$Res> {
  __$$RequestLaporanPengawasanEntityImplCopyWithImpl(
    _$RequestLaporanPengawasanEntityImpl _value,
    $Res Function(_$RequestLaporanPengawasanEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RequestLaporanPengawasanEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? jenisPel = null,
    Object? ketPel = null,
    Object? buktiFoto = freezed,
  }) {
    return _then(
      _$RequestLaporanPengawasanEntityImpl(
        jenisPel: null == jenisPel
            ? _value.jenisPel
            : jenisPel // ignore: cast_nullable_to_non_nullable
                  as int,
        ketPel: null == ketPel
            ? _value.ketPel
            : ketPel // ignore: cast_nullable_to_non_nullable
                  as String,
        buktiFoto: freezed == buktiFoto
            ? _value.buktiFoto
            : buktiFoto // ignore: cast_nullable_to_non_nullable
                  as File?,
      ),
    );
  }
}

/// @nodoc

class _$RequestLaporanPengawasanEntityImpl
    implements _RequestLaporanPengawasanEntity {
  const _$RequestLaporanPengawasanEntityImpl({
    this.jenisPel = 0,
    this.ketPel = '',
    this.buktiFoto,
  });

  @override
  @JsonKey()
  final int jenisPel;
  @override
  @JsonKey()
  final String ketPel;
  @override
  final File? buktiFoto;

  @override
  String toString() {
    return 'RequestLaporanPengawasanEntity(jenisPel: $jenisPel, ketPel: $ketPel, buktiFoto: $buktiFoto)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RequestLaporanPengawasanEntityImpl &&
            (identical(other.jenisPel, jenisPel) ||
                other.jenisPel == jenisPel) &&
            (identical(other.ketPel, ketPel) || other.ketPel == ketPel) &&
            (identical(other.buktiFoto, buktiFoto) ||
                other.buktiFoto == buktiFoto));
  }

  @override
  int get hashCode => Object.hash(runtimeType, jenisPel, ketPel, buktiFoto);

  /// Create a copy of RequestLaporanPengawasanEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RequestLaporanPengawasanEntityImplCopyWith<
    _$RequestLaporanPengawasanEntityImpl
  >
  get copyWith =>
      __$$RequestLaporanPengawasanEntityImplCopyWithImpl<
        _$RequestLaporanPengawasanEntityImpl
      >(this, _$identity);
}

abstract class _RequestLaporanPengawasanEntity
    implements RequestLaporanPengawasanEntity {
  const factory _RequestLaporanPengawasanEntity({
    final int jenisPel,
    final String ketPel,
    final File? buktiFoto,
  }) = _$RequestLaporanPengawasanEntityImpl;

  @override
  int get jenisPel;
  @override
  String get ketPel;
  @override
  File? get buktiFoto;

  /// Create a copy of RequestLaporanPengawasanEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RequestLaporanPengawasanEntityImplCopyWith<
    _$RequestLaporanPengawasanEntityImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
