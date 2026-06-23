// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'detail_realisasi_op_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$RealisasiBulanEntity {
  String get namaBulan =>
      throw _privateConstructorUsedError; // Contoh: "Januari"
  String get tanggalSspd =>
      throw _privateConstructorUsedError; // Contoh: "SSPD 04 Feb 2025"
  double get nominal => throw _privateConstructorUsedError;

  /// Create a copy of RealisasiBulanEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RealisasiBulanEntityCopyWith<RealisasiBulanEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RealisasiBulanEntityCopyWith<$Res> {
  factory $RealisasiBulanEntityCopyWith(
    RealisasiBulanEntity value,
    $Res Function(RealisasiBulanEntity) then,
  ) = _$RealisasiBulanEntityCopyWithImpl<$Res, RealisasiBulanEntity>;
  @useResult
  $Res call({String namaBulan, String tanggalSspd, double nominal});
}

/// @nodoc
class _$RealisasiBulanEntityCopyWithImpl<
  $Res,
  $Val extends RealisasiBulanEntity
>
    implements $RealisasiBulanEntityCopyWith<$Res> {
  _$RealisasiBulanEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RealisasiBulanEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? namaBulan = null,
    Object? tanggalSspd = null,
    Object? nominal = null,
  }) {
    return _then(
      _value.copyWith(
            namaBulan: null == namaBulan
                ? _value.namaBulan
                : namaBulan // ignore: cast_nullable_to_non_nullable
                      as String,
            tanggalSspd: null == tanggalSspd
                ? _value.tanggalSspd
                : tanggalSspd // ignore: cast_nullable_to_non_nullable
                      as String,
            nominal: null == nominal
                ? _value.nominal
                : nominal // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RealisasiBulanEntityImplCopyWith<$Res>
    implements $RealisasiBulanEntityCopyWith<$Res> {
  factory _$$RealisasiBulanEntityImplCopyWith(
    _$RealisasiBulanEntityImpl value,
    $Res Function(_$RealisasiBulanEntityImpl) then,
  ) = __$$RealisasiBulanEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String namaBulan, String tanggalSspd, double nominal});
}

/// @nodoc
class __$$RealisasiBulanEntityImplCopyWithImpl<$Res>
    extends _$RealisasiBulanEntityCopyWithImpl<$Res, _$RealisasiBulanEntityImpl>
    implements _$$RealisasiBulanEntityImplCopyWith<$Res> {
  __$$RealisasiBulanEntityImplCopyWithImpl(
    _$RealisasiBulanEntityImpl _value,
    $Res Function(_$RealisasiBulanEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RealisasiBulanEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? namaBulan = null,
    Object? tanggalSspd = null,
    Object? nominal = null,
  }) {
    return _then(
      _$RealisasiBulanEntityImpl(
        namaBulan: null == namaBulan
            ? _value.namaBulan
            : namaBulan // ignore: cast_nullable_to_non_nullable
                  as String,
        tanggalSspd: null == tanggalSspd
            ? _value.tanggalSspd
            : tanggalSspd // ignore: cast_nullable_to_non_nullable
                  as String,
        nominal: null == nominal
            ? _value.nominal
            : nominal // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc

class _$RealisasiBulanEntityImpl implements _RealisasiBulanEntity {
  const _$RealisasiBulanEntityImpl({
    required this.namaBulan,
    required this.tanggalSspd,
    required this.nominal,
  });

  @override
  final String namaBulan;
  // Contoh: "Januari"
  @override
  final String tanggalSspd;
  // Contoh: "SSPD 04 Feb 2025"
  @override
  final double nominal;

  @override
  String toString() {
    return 'RealisasiBulanEntity(namaBulan: $namaBulan, tanggalSspd: $tanggalSspd, nominal: $nominal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RealisasiBulanEntityImpl &&
            (identical(other.namaBulan, namaBulan) ||
                other.namaBulan == namaBulan) &&
            (identical(other.tanggalSspd, tanggalSspd) ||
                other.tanggalSspd == tanggalSspd) &&
            (identical(other.nominal, nominal) || other.nominal == nominal));
  }

  @override
  int get hashCode => Object.hash(runtimeType, namaBulan, tanggalSspd, nominal);

  /// Create a copy of RealisasiBulanEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RealisasiBulanEntityImplCopyWith<_$RealisasiBulanEntityImpl>
  get copyWith =>
      __$$RealisasiBulanEntityImplCopyWithImpl<_$RealisasiBulanEntityImpl>(
        this,
        _$identity,
      );
}

abstract class _RealisasiBulanEntity implements RealisasiBulanEntity {
  const factory _RealisasiBulanEntity({
    required final String namaBulan,
    required final String tanggalSspd,
    required final double nominal,
  }) = _$RealisasiBulanEntityImpl;

  @override
  String get namaBulan; // Contoh: "Januari"
  @override
  String get tanggalSspd; // Contoh: "SSPD 04 Feb 2025"
  @override
  double get nominal;

  /// Create a copy of RealisasiBulanEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RealisasiBulanEntityImplCopyWith<_$RealisasiBulanEntityImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$RealisasiTahunEntity {
  int get tahun => throw _privateConstructorUsedError;
  double get totalRealisasi => throw _privateConstructorUsedError;
  List<RealisasiBulanEntity> get daftarBulan =>
      throw _privateConstructorUsedError;

  /// Create a copy of RealisasiTahunEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RealisasiTahunEntityCopyWith<RealisasiTahunEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RealisasiTahunEntityCopyWith<$Res> {
  factory $RealisasiTahunEntityCopyWith(
    RealisasiTahunEntity value,
    $Res Function(RealisasiTahunEntity) then,
  ) = _$RealisasiTahunEntityCopyWithImpl<$Res, RealisasiTahunEntity>;
  @useResult
  $Res call({
    int tahun,
    double totalRealisasi,
    List<RealisasiBulanEntity> daftarBulan,
  });
}

/// @nodoc
class _$RealisasiTahunEntityCopyWithImpl<
  $Res,
  $Val extends RealisasiTahunEntity
>
    implements $RealisasiTahunEntityCopyWith<$Res> {
  _$RealisasiTahunEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RealisasiTahunEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tahun = null,
    Object? totalRealisasi = null,
    Object? daftarBulan = null,
  }) {
    return _then(
      _value.copyWith(
            tahun: null == tahun
                ? _value.tahun
                : tahun // ignore: cast_nullable_to_non_nullable
                      as int,
            totalRealisasi: null == totalRealisasi
                ? _value.totalRealisasi
                : totalRealisasi // ignore: cast_nullable_to_non_nullable
                      as double,
            daftarBulan: null == daftarBulan
                ? _value.daftarBulan
                : daftarBulan // ignore: cast_nullable_to_non_nullable
                      as List<RealisasiBulanEntity>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RealisasiTahunEntityImplCopyWith<$Res>
    implements $RealisasiTahunEntityCopyWith<$Res> {
  factory _$$RealisasiTahunEntityImplCopyWith(
    _$RealisasiTahunEntityImpl value,
    $Res Function(_$RealisasiTahunEntityImpl) then,
  ) = __$$RealisasiTahunEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int tahun,
    double totalRealisasi,
    List<RealisasiBulanEntity> daftarBulan,
  });
}

/// @nodoc
class __$$RealisasiTahunEntityImplCopyWithImpl<$Res>
    extends _$RealisasiTahunEntityCopyWithImpl<$Res, _$RealisasiTahunEntityImpl>
    implements _$$RealisasiTahunEntityImplCopyWith<$Res> {
  __$$RealisasiTahunEntityImplCopyWithImpl(
    _$RealisasiTahunEntityImpl _value,
    $Res Function(_$RealisasiTahunEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RealisasiTahunEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tahun = null,
    Object? totalRealisasi = null,
    Object? daftarBulan = null,
  }) {
    return _then(
      _$RealisasiTahunEntityImpl(
        tahun: null == tahun
            ? _value.tahun
            : tahun // ignore: cast_nullable_to_non_nullable
                  as int,
        totalRealisasi: null == totalRealisasi
            ? _value.totalRealisasi
            : totalRealisasi // ignore: cast_nullable_to_non_nullable
                  as double,
        daftarBulan: null == daftarBulan
            ? _value._daftarBulan
            : daftarBulan // ignore: cast_nullable_to_non_nullable
                  as List<RealisasiBulanEntity>,
      ),
    );
  }
}

/// @nodoc

class _$RealisasiTahunEntityImpl implements _RealisasiTahunEntity {
  const _$RealisasiTahunEntityImpl({
    required this.tahun,
    required this.totalRealisasi,
    final List<RealisasiBulanEntity> daftarBulan = const [],
  }) : _daftarBulan = daftarBulan;

  @override
  final int tahun;
  @override
  final double totalRealisasi;
  final List<RealisasiBulanEntity> _daftarBulan;
  @override
  @JsonKey()
  List<RealisasiBulanEntity> get daftarBulan {
    if (_daftarBulan is EqualUnmodifiableListView) return _daftarBulan;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_daftarBulan);
  }

  @override
  String toString() {
    return 'RealisasiTahunEntity(tahun: $tahun, totalRealisasi: $totalRealisasi, daftarBulan: $daftarBulan)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RealisasiTahunEntityImpl &&
            (identical(other.tahun, tahun) || other.tahun == tahun) &&
            (identical(other.totalRealisasi, totalRealisasi) ||
                other.totalRealisasi == totalRealisasi) &&
            const DeepCollectionEquality().equals(
              other._daftarBulan,
              _daftarBulan,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    tahun,
    totalRealisasi,
    const DeepCollectionEquality().hash(_daftarBulan),
  );

  /// Create a copy of RealisasiTahunEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RealisasiTahunEntityImplCopyWith<_$RealisasiTahunEntityImpl>
  get copyWith =>
      __$$RealisasiTahunEntityImplCopyWithImpl<_$RealisasiTahunEntityImpl>(
        this,
        _$identity,
      );
}

abstract class _RealisasiTahunEntity implements RealisasiTahunEntity {
  const factory _RealisasiTahunEntity({
    required final int tahun,
    required final double totalRealisasi,
    final List<RealisasiBulanEntity> daftarBulan,
  }) = _$RealisasiTahunEntityImpl;

  @override
  int get tahun;
  @override
  double get totalRealisasi;
  @override
  List<RealisasiBulanEntity> get daftarBulan;

  /// Create a copy of RealisasiTahunEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RealisasiTahunEntityImplCopyWith<_$RealisasiTahunEntityImpl>
  get copyWith => throw _privateConstructorUsedError;
}
