part of 'detail_realisasi_op_entity.dart';

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DetailRealisasiOpEntity {
  String get nop => throw _privateConstructorUsedError;
  String get namaOp => throw _privateConstructorUsedError;
  int get uptbId => throw _privateConstructorUsedError;
  int get tahun => throw _privateConstructorUsedError;
  bool get isDigital => throw _privateConstructorUsedError;
  String get tglDigitalisasi => throw _privateConstructorUsedError;
  double get nominalNonDigital => throw _privateConstructorUsedError;
  double get nominalDigital => throw _privateConstructorUsedError;
  double get totalNominal => throw _privateConstructorUsedError;
  List<RealisasiPerBulanEntity> get realisasiPerBulan =>
      throw _privateConstructorUsedError;

  /// Create a copy of DetailRealisasiOpEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DetailRealisasiOpEntityCopyWith<DetailRealisasiOpEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DetailRealisasiOpEntityCopyWith<$Res> {
  factory $DetailRealisasiOpEntityCopyWith(
    DetailRealisasiOpEntity value,
    $Res Function(DetailRealisasiOpEntity) then,
  ) = _$DetailRealisasiOpEntityCopyWithImpl<$Res, DetailRealisasiOpEntity>;
  @useResult
  $Res call({
    String nop,
    String namaOp,
    int uptbId,
    int tahun,
    bool isDigital,
    String tglDigitalisasi,
    double nominalNonDigital,
    double nominalDigital,
    double totalNominal,
    List<RealisasiPerBulanEntity> realisasiPerBulan,
  });
}

/// @nodoc
class _$DetailRealisasiOpEntityCopyWithImpl<
  $Res,
  $Val extends DetailRealisasiOpEntity
>
    implements $DetailRealisasiOpEntityCopyWith<$Res> {
  _$DetailRealisasiOpEntityCopyWithImpl(this._value, this._then);
  final $Val _value;
  final $Res Function($Val) _then;

  /// Create a copy of DetailRealisasiOpEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nop = null,
    Object? namaOp = null,
    Object? uptbId = null,
    Object? tahun = null,
    Object? isDigital = null,
    Object? tglDigitalisasi = null,
    Object? nominalNonDigital = null,
    Object? nominalDigital = null,
    Object? totalNominal = null,
    Object? realisasiPerBulan = null,
  }) {
    return _then(
      _value.copyWith(
            nop: null == nop
                ? _value.nop
                : nop // ignore: cast_nullable_to_non_nullable
                      as String,
            namaOp: null == namaOp
                ? _value.namaOp
                : namaOp // ignore: cast_nullable_to_non_nullable
                      as String,
            uptbId: null == uptbId
                ? _value.uptbId
                : uptbId // ignore: cast_nullable_to_non_nullable
                      as int,
            tahun: null == tahun
                ? _value.tahun
                : tahun // ignore: cast_nullable_to_non_nullable
                      as int,
            isDigital: null == isDigital
                ? _value.isDigital
                : isDigital // ignore: cast_nullable_to_non_nullable
                      as bool,
            tglDigitalisasi: null == tglDigitalisasi
                ? _value.tglDigitalisasi
                : tglDigitalisasi // ignore: cast_nullable_to_non_nullable
                      as String,
            nominalNonDigital: null == nominalNonDigital
                ? _value.nominalNonDigital
                : nominalNonDigital // ignore: cast_nullable_to_non_nullable
                      as double,
            nominalDigital: null == nominalDigital
                ? _value.nominalDigital
                : nominalDigital // ignore: cast_nullable_to_non_nullable
                      as double,
            totalNominal: null == totalNominal
                ? _value.totalNominal
                : totalNominal // ignore: cast_nullable_to_non_nullable
                      as double,
            realisasiPerBulan: null == realisasiPerBulan
                ? _value.realisasiPerBulan
                : realisasiPerBulan // ignore: cast_nullable_to_non_nullable
                      as List<RealisasiPerBulanEntity>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DetailRealisasiOpEntityImplCopyWith<$Res>
    implements $DetailRealisasiOpEntityCopyWith<$Res> {
  factory _$$DetailRealisasiOpEntityImplCopyWith(
    _$DetailRealisasiOpEntityImpl value,
    $Res Function(_$DetailRealisasiOpEntityImpl) then,
  ) = __$$DetailRealisasiOpEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String nop,
    String namaOp,
    int uptbId,
    int tahun,
    bool isDigital,
    String tglDigitalisasi,
    double nominalNonDigital,
    double nominalDigital,
    double totalNominal,
    List<RealisasiPerBulanEntity> realisasiPerBulan,
  });
}

/// @nodoc
class __$$DetailRealisasiOpEntityImplCopyWithImpl<$Res>
    extends
        _$DetailRealisasiOpEntityCopyWithImpl<
          $Res,
          _$DetailRealisasiOpEntityImpl
        >
    implements _$$DetailRealisasiOpEntityImplCopyWith<$Res> {
  __$$DetailRealisasiOpEntityImplCopyWithImpl(
    _$DetailRealisasiOpEntityImpl _value,
    $Res Function(_$DetailRealisasiOpEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DetailRealisasiOpEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nop = null,
    Object? namaOp = null,
    Object? uptbId = null,
    Object? tahun = null,
    Object? isDigital = null,
    Object? tglDigitalisasi = null,
    Object? nominalNonDigital = null,
    Object? nominalDigital = null,
    Object? totalNominal = null,
    Object? realisasiPerBulan = null,
  }) {
    return _then(
      _$DetailRealisasiOpEntityImpl(
        nop: null == nop
            ? _value.nop
            : nop // ignore: cast_nullable_to_non_nullable
                  as String,
        namaOp: null == namaOp
            ? _value.namaOp
            : namaOp // ignore: cast_nullable_to_non_nullable
                  as String,
        uptbId: null == uptbId
            ? _value.uptbId
            : uptbId // ignore: cast_nullable_to_non_nullable
                  as int,
        tahun: null == tahun
            ? _value.tahun
            : tahun // ignore: cast_nullable_to_non_nullable
                  as int,
        isDigital: null == isDigital
            ? _value.isDigital
            : isDigital // ignore: cast_nullable_to_non_nullable
                  as bool,
        tglDigitalisasi: null == tglDigitalisasi
            ? _value.tglDigitalisasi
            : tglDigitalisasi // ignore: cast_nullable_to_non_nullable
                  as String,
        nominalNonDigital: null == nominalNonDigital
            ? _value.nominalNonDigital
            : nominalNonDigital // ignore: cast_nullable_to_non_nullable
                  as double,
        nominalDigital: null == nominalDigital
            ? _value.nominalDigital
            : nominalDigital // ignore: cast_nullable_to_non_nullable
                  as double,
        totalNominal: null == totalNominal
            ? _value.totalNominal
            : totalNominal // ignore: cast_nullable_to_non_nullable
                  as double,
        realisasiPerBulan: null == realisasiPerBulan
            ? _value._realisasiPerBulan
            : realisasiPerBulan // ignore: cast_nullable_to_non_nullable
                  as List<RealisasiPerBulanEntity>,
      ),
    );
  }
}

/// @nodoc

class _$DetailRealisasiOpEntityImpl implements _DetailRealisasiOpEntity {
  const _$DetailRealisasiOpEntityImpl({
    required this.nop,
    required this.namaOp,
    required this.uptbId,
    required this.tahun,
    required this.isDigital,
    required this.tglDigitalisasi,
    required this.nominalNonDigital,
    required this.nominalDigital,
    required this.totalNominal,
    final List<RealisasiPerBulanEntity> realisasiPerBulan = const [],
  }) : _realisasiPerBulan = realisasiPerBulan;

  @override
  final String nop;
  @override
  final String namaOp;
  @override
  final int uptbId;
  @override
  final int tahun;
  @override
  final bool isDigital;
  @override
  final String tglDigitalisasi;
  @override
  final double nominalNonDigital;
  @override
  final double nominalDigital;
  @override
  final double totalNominal;
  final List<RealisasiPerBulanEntity> _realisasiPerBulan;
  @override
  @JsonKey()
  List<RealisasiPerBulanEntity> get realisasiPerBulan {
    if (_realisasiPerBulan is EqualUnmodifiableListView)
      return _realisasiPerBulan;
    return EqualUnmodifiableListView(_realisasiPerBulan);
  }

  @override
  String toString() {
    return 'DetailRealisasiOpEntity(nop: $nop, namaOp: $namaOp, uptbId: $uptbId, tahun: $tahun, isDigital: $isDigital, tglDigitalisasi: $tglDigitalisasi, nominalNonDigital: $nominalNonDigital, nominalDigital: $nominalDigital, totalNominal: $totalNominal, realisasiPerBulan: $realisasiPerBulan)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DetailRealisasiOpEntityImpl &&
            (identical(other.nop, nop) || other.nop == nop) &&
            (identical(other.namaOp, namaOp) || other.namaOp == namaOp) &&
            (identical(other.uptbId, uptbId) || other.uptbId == uptbId) &&
            (identical(other.tahun, tahun) || other.tahun == tahun) &&
            (identical(other.isDigital, isDigital) ||
                other.isDigital == isDigital) &&
            (identical(other.tglDigitalisasi, tglDigitalisasi) ||
                other.tglDigitalisasi == tglDigitalisasi) &&
            (identical(other.nominalNonDigital, nominalNonDigital) ||
                other.nominalNonDigital == nominalNonDigital) &&
            (identical(other.nominalDigital, nominalDigital) ||
                other.nominalDigital == nominalDigital) &&
            (identical(other.totalNominal, totalNominal) ||
                other.totalNominal == totalNominal) &&
            const DeepCollectionEquality().equals(
              other._realisasiPerBulan,
              _realisasiPerBulan,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    nop,
    namaOp,
    uptbId,
    tahun,
    isDigital,
    tglDigitalisasi,
    nominalNonDigital,
    nominalDigital,
    totalNominal,
    const DeepCollectionEquality().hash(_realisasiPerBulan),
  );

  /// Create a copy of DetailRealisasiOpEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DetailRealisasiOpEntityImplCopyWith<_$DetailRealisasiOpEntityImpl>
  get copyWith =>
      __$$DetailRealisasiOpEntityImplCopyWithImpl<
        _$DetailRealisasiOpEntityImpl
      >(this, _$identity);
}

abstract class _DetailRealisasiOpEntity implements DetailRealisasiOpEntity {
  const factory _DetailRealisasiOpEntity({
    required final String nop,
    required final String namaOp,
    required final int uptbId,
    required final int tahun,
    required final bool isDigital,
    required final String tglDigitalisasi,
    required final double nominalNonDigital,
    required final double nominalDigital,
    required final double totalNominal,
    final List<RealisasiPerBulanEntity> realisasiPerBulan,
  }) = _$DetailRealisasiOpEntityImpl;

  @override
  String get nop;
  @override
  String get namaOp;
  @override
  int get uptbId;
  @override
  int get tahun;
  @override
  bool get isDigital;
  @override
  String get tglDigitalisasi;
  @override
  double get nominalNonDigital;
  @override
  double get nominalDigital;
  @override
  double get totalNominal;
  @override
  List<RealisasiPerBulanEntity> get realisasiPerBulan;

  /// Create a copy of DetailRealisasiOpEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DetailRealisasiOpEntityImplCopyWith<_$DetailRealisasiOpEntityImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$RealisasiPerBulanEntity {
  int get bulan => throw _privateConstructorUsedError;
  String get bulanNama => throw _privateConstructorUsedError;
  String get tglSspd => throw _privateConstructorUsedError;
  double get nominalNonDigital => throw _privateConstructorUsedError;
  double get nominalDigital => throw _privateConstructorUsedError;
  double get totalNominal => throw _privateConstructorUsedError;

  /// Create a copy of RealisasiPerBulanEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RealisasiPerBulanEntityCopyWith<RealisasiPerBulanEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RealisasiPerBulanEntityCopyWith<$Res> {
  factory $RealisasiPerBulanEntityCopyWith(
    RealisasiPerBulanEntity value,
    $Res Function(RealisasiPerBulanEntity) then,
  ) = _$RealisasiPerBulanEntityCopyWithImpl<$Res, RealisasiPerBulanEntity>;
  @useResult
  $Res call({
    int bulan,
    String bulanNama,
    String tglSspd,
    double nominalNonDigital,
    double nominalDigital,
    double totalNominal,
  });
}

/// @nodoc
class _$RealisasiPerBulanEntityCopyWithImpl<
  $Res,
  $Val extends RealisasiPerBulanEntity
>
    implements $RealisasiPerBulanEntityCopyWith<$Res> {
  _$RealisasiPerBulanEntityCopyWithImpl(this._value, this._then);
  final $Val _value;
  final $Res Function($Val) _then;

  /// Create a copy of RealisasiPerBulanEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bulan = null,
    Object? bulanNama = null,
    Object? tglSspd = null,
    Object? nominalNonDigital = null,
    Object? nominalDigital = null,
    Object? totalNominal = null,
  }) {
    return _then(
      _value.copyWith(
            bulan: null == bulan
                ? _value.bulan
                : bulan // ignore: cast_nullable_to_non_nullable
                      as int,
            bulanNama: null == bulanNama
                ? _value.bulanNama
                : bulanNama // ignore: cast_nullable_to_non_nullable
                      as String,
            tglSspd: null == tglSspd
                ? _value.tglSspd
                : tglSspd // ignore: cast_nullable_to_non_nullable
                      as String,
            nominalNonDigital: null == nominalNonDigital
                ? _value.nominalNonDigital
                : nominalNonDigital // ignore: cast_nullable_to_non_nullable
                      as double,
            nominalDigital: null == nominalDigital
                ? _value.nominalDigital
                : nominalDigital // ignore: cast_nullable_to_non_nullable
                      as double,
            totalNominal: null == totalNominal
                ? _value.totalNominal
                : totalNominal // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RealisasiPerBulanEntityImplCopyWith<$Res>
    implements $RealisasiPerBulanEntityCopyWith<$Res> {
  factory _$$RealisasiPerBulanEntityImplCopyWith(
    _$RealisasiPerBulanEntityImpl value,
    $Res Function(_$RealisasiPerBulanEntityImpl) then,
  ) = __$$RealisasiPerBulanEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int bulan,
    String bulanNama,
    String tglSspd,
    double nominalNonDigital,
    double nominalDigital,
    double totalNominal,
  });
}

/// @nodoc
class __$$RealisasiPerBulanEntityImplCopyWithImpl<$Res>
    extends
        _$RealisasiPerBulanEntityCopyWithImpl<
          $Res,
          _$RealisasiPerBulanEntityImpl
        >
    implements _$$RealisasiPerBulanEntityImplCopyWith<$Res> {
  __$$RealisasiPerBulanEntityImplCopyWithImpl(
    _$RealisasiPerBulanEntityImpl _value,
    $Res Function(_$RealisasiPerBulanEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RealisasiPerBulanEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bulan = null,
    Object? bulanNama = null,
    Object? tglSspd = null,
    Object? nominalNonDigital = null,
    Object? nominalDigital = null,
    Object? totalNominal = null,
  }) {
    return _then(
      _$RealisasiPerBulanEntityImpl(
        bulan: null == bulan
            ? _value.bulan
            : bulan // ignore: cast_nullable_to_non_nullable
                  as int,
        bulanNama: null == bulanNama
            ? _value.bulanNama
            : bulanNama // ignore: cast_nullable_to_non_nullable
                  as String,
        tglSspd: null == tglSspd
            ? _value.tglSspd
            : tglSspd // ignore: cast_nullable_to_non_nullable
                  as String,
        nominalNonDigital: null == nominalNonDigital
            ? _value.nominalNonDigital
            : nominalNonDigital // ignore: cast_nullable_to_non_nullable
                  as double,
        nominalDigital: null == nominalDigital
            ? _value.nominalDigital
            : nominalDigital // ignore: cast_nullable_to_non_nullable
                  as double,
        totalNominal: null == totalNominal
            ? _value.totalNominal
            : totalNominal // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc

class _$RealisasiPerBulanEntityImpl implements _RealisasiPerBulanEntity {
  const _$RealisasiPerBulanEntityImpl({
    required this.bulan,
    required this.bulanNama,
    required this.tglSspd,
    required this.nominalNonDigital,
    required this.nominalDigital,
    required this.totalNominal,
  });

  @override
  final int bulan;
  @override
  final String bulanNama;
  @override
  final String tglSspd;
  @override
  final double nominalNonDigital;
  @override
  final double nominalDigital;
  @override
  final double totalNominal;

  @override
  String toString() {
    return 'RealisasiPerBulanEntity(bulan: $bulan, bulanNama: $bulanNama, tglSspd: $tglSspd, nominalNonDigital: $nominalNonDigital, nominalDigital: $nominalDigital, totalNominal: $totalNominal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RealisasiPerBulanEntityImpl &&
            (identical(other.bulan, bulan) || other.bulan == bulan) &&
            (identical(other.bulanNama, bulanNama) ||
                other.bulanNama == bulanNama) &&
            (identical(other.tglSspd, tglSspd) || other.tglSspd == tglSspd) &&
            (identical(other.nominalNonDigital, nominalNonDigital) ||
                other.nominalNonDigital == nominalNonDigital) &&
            (identical(other.nominalDigital, nominalDigital) ||
                other.nominalDigital == nominalDigital) &&
            (identical(other.totalNominal, totalNominal) ||
                other.totalNominal == totalNominal));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    bulan,
    bulanNama,
    tglSspd,
    nominalNonDigital,
    nominalDigital,
    totalNominal,
  );

  /// Create a copy of RealisasiPerBulanEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RealisasiPerBulanEntityImplCopyWith<_$RealisasiPerBulanEntityImpl>
  get copyWith =>
      __$$RealisasiPerBulanEntityImplCopyWithImpl<
        _$RealisasiPerBulanEntityImpl
      >(this, _$identity);
}

abstract class _RealisasiPerBulanEntity implements RealisasiPerBulanEntity {
  const factory _RealisasiPerBulanEntity({
    required final int bulan,
    required final String bulanNama,
    required final String tglSspd,
    required final double nominalNonDigital,
    required final double nominalDigital,
    required final double totalNominal,
  }) = _$RealisasiPerBulanEntityImpl;

  @override
  int get bulan;
  @override
  String get bulanNama;
  @override
  String get tglSspd;
  @override
  double get nominalNonDigital;
  @override
  double get nominalDigital;
  @override
  double get totalNominal;

  /// Create a copy of RealisasiPerBulanEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RealisasiPerBulanEntityImplCopyWith<_$RealisasiPerBulanEntityImpl>
  get copyWith => throw _privateConstructorUsedError;
}
