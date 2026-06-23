// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'detail_realisasi_op_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DetailRealisasiOpResponse _$DetailRealisasiOpResponseFromJson(
  Map<String, dynamic> json,
) {
  return _DetailRealisasiOpResponse.fromJson(json);
}

/// @nodoc
mixin _$DetailRealisasiOpResponse {
  @JsonKey(name: 'isSuccess')
  bool? get isSuccess => throw _privateConstructorUsedError;
  @JsonKey(name: 'statusCode')
  int? get statusCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'message')
  String? get message => throw _privateConstructorUsedError;
  @JsonKey(name: 'data')
  DetailRealisasiOpModel? get data => throw _privateConstructorUsedError;

  /// Serializes this DetailRealisasiOpResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DetailRealisasiOpResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DetailRealisasiOpResponseCopyWith<DetailRealisasiOpResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DetailRealisasiOpResponseCopyWith<$Res> {
  factory $DetailRealisasiOpResponseCopyWith(
    DetailRealisasiOpResponse value,
    $Res Function(DetailRealisasiOpResponse) then,
  ) = _$DetailRealisasiOpResponseCopyWithImpl<$Res, DetailRealisasiOpResponse>;
  @useResult
  $Res call({
    @JsonKey(name: 'isSuccess') bool? isSuccess,
    @JsonKey(name: 'statusCode') int? statusCode,
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'data') DetailRealisasiOpModel? data,
  });

  $DetailRealisasiOpModelCopyWith<$Res>? get data;
}

/// @nodoc
class _$DetailRealisasiOpResponseCopyWithImpl<
  $Res,
  $Val extends DetailRealisasiOpResponse
>
    implements $DetailRealisasiOpResponseCopyWith<$Res> {
  _$DetailRealisasiOpResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DetailRealisasiOpResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSuccess = freezed,
    Object? statusCode = freezed,
    Object? message = freezed,
    Object? data = freezed,
  }) {
    return _then(
      _value.copyWith(
            isSuccess: freezed == isSuccess
                ? _value.isSuccess
                : isSuccess // ignore: cast_nullable_to_non_nullable
                      as bool?,
            statusCode: freezed == statusCode
                ? _value.statusCode
                : statusCode // ignore: cast_nullable_to_non_nullable
                      as int?,
            message: freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String?,
            data: freezed == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as DetailRealisasiOpModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of DetailRealisasiOpResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DetailRealisasiOpModelCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $DetailRealisasiOpModelCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DetailRealisasiOpResponseImplCopyWith<$Res>
    implements $DetailRealisasiOpResponseCopyWith<$Res> {
  factory _$$DetailRealisasiOpResponseImplCopyWith(
    _$DetailRealisasiOpResponseImpl value,
    $Res Function(_$DetailRealisasiOpResponseImpl) then,
  ) = __$$DetailRealisasiOpResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'isSuccess') bool? isSuccess,
    @JsonKey(name: 'statusCode') int? statusCode,
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'data') DetailRealisasiOpModel? data,
  });

  @override
  $DetailRealisasiOpModelCopyWith<$Res>? get data;
}

/// @nodoc
class __$$DetailRealisasiOpResponseImplCopyWithImpl<$Res>
    extends
        _$DetailRealisasiOpResponseCopyWithImpl<
          $Res,
          _$DetailRealisasiOpResponseImpl
        >
    implements _$$DetailRealisasiOpResponseImplCopyWith<$Res> {
  __$$DetailRealisasiOpResponseImplCopyWithImpl(
    _$DetailRealisasiOpResponseImpl _value,
    $Res Function(_$DetailRealisasiOpResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DetailRealisasiOpResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSuccess = freezed,
    Object? statusCode = freezed,
    Object? message = freezed,
    Object? data = freezed,
  }) {
    return _then(
      _$DetailRealisasiOpResponseImpl(
        isSuccess: freezed == isSuccess
            ? _value.isSuccess
            : isSuccess // ignore: cast_nullable_to_non_nullable
                  as bool?,
        statusCode: freezed == statusCode
            ? _value.statusCode
            : statusCode // ignore: cast_nullable_to_non_nullable
                  as int?,
        message: freezed == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String?,
        data: freezed == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as DetailRealisasiOpModel?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DetailRealisasiOpResponseImpl implements _DetailRealisasiOpResponse {
  const _$DetailRealisasiOpResponseImpl({
    @JsonKey(name: 'isSuccess') this.isSuccess,
    @JsonKey(name: 'statusCode') this.statusCode,
    @JsonKey(name: 'message') this.message,
    @JsonKey(name: 'data') this.data,
  });

  factory _$DetailRealisasiOpResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$DetailRealisasiOpResponseImplFromJson(json);

  @override
  @JsonKey(name: 'isSuccess')
  final bool? isSuccess;
  @override
  @JsonKey(name: 'statusCode')
  final int? statusCode;
  @override
  @JsonKey(name: 'message')
  final String? message;
  @override
  @JsonKey(name: 'data')
  final DetailRealisasiOpModel? data;

  @override
  String toString() {
    return 'DetailRealisasiOpResponse(isSuccess: $isSuccess, statusCode: $statusCode, message: $message, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DetailRealisasiOpResponseImpl &&
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

  /// Create a copy of DetailRealisasiOpResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DetailRealisasiOpResponseImplCopyWith<_$DetailRealisasiOpResponseImpl>
  get copyWith =>
      __$$DetailRealisasiOpResponseImplCopyWithImpl<
        _$DetailRealisasiOpResponseImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DetailRealisasiOpResponseImplToJson(this);
  }
}

abstract class _DetailRealisasiOpResponse implements DetailRealisasiOpResponse {
  const factory _DetailRealisasiOpResponse({
    @JsonKey(name: 'isSuccess') final bool? isSuccess,
    @JsonKey(name: 'statusCode') final int? statusCode,
    @JsonKey(name: 'message') final String? message,
    @JsonKey(name: 'data') final DetailRealisasiOpModel? data,
  }) = _$DetailRealisasiOpResponseImpl;

  factory _DetailRealisasiOpResponse.fromJson(Map<String, dynamic> json) =
      _$DetailRealisasiOpResponseImpl.fromJson;

  @override
  @JsonKey(name: 'isSuccess')
  bool? get isSuccess;
  @override
  @JsonKey(name: 'statusCode')
  int? get statusCode;
  @override
  @JsonKey(name: 'message')
  String? get message;
  @override
  @JsonKey(name: 'data')
  DetailRealisasiOpModel? get data;

  /// Create a copy of DetailRealisasiOpResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DetailRealisasiOpResponseImplCopyWith<_$DetailRealisasiOpResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}

DetailRealisasiOpModel _$DetailRealisasiOpModelFromJson(
  Map<String, dynamic> json,
) {
  return _DetailRealisasiOpModel.fromJson(json);
}

/// @nodoc
mixin _$DetailRealisasiOpModel {
  @JsonKey(name: 'nop')
  String? get nop => throw _privateConstructorUsedError;
  @JsonKey(name: 'namaOp')
  String? get namaOp => throw _privateConstructorUsedError;
  @JsonKey(name: 'uptbId')
  int? get uptbId => throw _privateConstructorUsedError;
  @JsonKey(name: 'tahun')
  int? get tahun => throw _privateConstructorUsedError;
  @JsonKey(name: 'isDigital')
  bool? get isDigital => throw _privateConstructorUsedError;
  @JsonKey(name: 'tglDigitalisasi')
  String? get tglDigitalisasi => throw _privateConstructorUsedError;
  @JsonKey(name: 'nominalNonDigital')
  double? get nominalNonDigital => throw _privateConstructorUsedError;
  @JsonKey(name: 'nominalDigital')
  double? get nominalDigital => throw _privateConstructorUsedError;
  @JsonKey(name: 'totalNominal')
  double? get totalNominal => throw _privateConstructorUsedError;
  @JsonKey(name: 'realisasiPerBulan')
  List<RealisasiPerBulanModel>? get realisasiPerBulan =>
      throw _privateConstructorUsedError;

  /// Serializes this DetailRealisasiOpModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DetailRealisasiOpModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DetailRealisasiOpModelCopyWith<DetailRealisasiOpModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DetailRealisasiOpModelCopyWith<$Res> {
  factory $DetailRealisasiOpModelCopyWith(
    DetailRealisasiOpModel value,
    $Res Function(DetailRealisasiOpModel) then,
  ) = _$DetailRealisasiOpModelCopyWithImpl<$Res, DetailRealisasiOpModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'nop') String? nop,
    @JsonKey(name: 'namaOp') String? namaOp,
    @JsonKey(name: 'uptbId') int? uptbId,
    @JsonKey(name: 'tahun') int? tahun,
    @JsonKey(name: 'isDigital') bool? isDigital,
    @JsonKey(name: 'tglDigitalisasi') String? tglDigitalisasi,
    @JsonKey(name: 'nominalNonDigital') double? nominalNonDigital,
    @JsonKey(name: 'nominalDigital') double? nominalDigital,
    @JsonKey(name: 'totalNominal') double? totalNominal,
    @JsonKey(name: 'realisasiPerBulan')
    List<RealisasiPerBulanModel>? realisasiPerBulan,
  });
}

/// @nodoc
class _$DetailRealisasiOpModelCopyWithImpl<
  $Res,
  $Val extends DetailRealisasiOpModel
>
    implements $DetailRealisasiOpModelCopyWith<$Res> {
  _$DetailRealisasiOpModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DetailRealisasiOpModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nop = freezed,
    Object? namaOp = freezed,
    Object? uptbId = freezed,
    Object? tahun = freezed,
    Object? isDigital = freezed,
    Object? tglDigitalisasi = freezed,
    Object? nominalNonDigital = freezed,
    Object? nominalDigital = freezed,
    Object? totalNominal = freezed,
    Object? realisasiPerBulan = freezed,
  }) {
    return _then(
      _value.copyWith(
            nop: freezed == nop
                ? _value.nop
                : nop // ignore: cast_nullable_to_non_nullable
                      as String?,
            namaOp: freezed == namaOp
                ? _value.namaOp
                : namaOp // ignore: cast_nullable_to_non_nullable
                      as String?,
            uptbId: freezed == uptbId
                ? _value.uptbId
                : uptbId // ignore: cast_nullable_to_non_nullable
                      as int?,
            tahun: freezed == tahun
                ? _value.tahun
                : tahun // ignore: cast_nullable_to_non_nullable
                      as int?,
            isDigital: freezed == isDigital
                ? _value.isDigital
                : isDigital // ignore: cast_nullable_to_non_nullable
                      as bool?,
            tglDigitalisasi: freezed == tglDigitalisasi
                ? _value.tglDigitalisasi
                : tglDigitalisasi // ignore: cast_nullable_to_non_nullable
                      as String?,
            nominalNonDigital: freezed == nominalNonDigital
                ? _value.nominalNonDigital
                : nominalNonDigital // ignore: cast_nullable_to_non_nullable
                      as double?,
            nominalDigital: freezed == nominalDigital
                ? _value.nominalDigital
                : nominalDigital // ignore: cast_nullable_to_non_nullable
                      as double?,
            totalNominal: freezed == totalNominal
                ? _value.totalNominal
                : totalNominal // ignore: cast_nullable_to_non_nullable
                      as double?,
            realisasiPerBulan: freezed == realisasiPerBulan
                ? _value.realisasiPerBulan
                : realisasiPerBulan // ignore: cast_nullable_to_non_nullable
                      as List<RealisasiPerBulanModel>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DetailRealisasiOpModelImplCopyWith<$Res>
    implements $DetailRealisasiOpModelCopyWith<$Res> {
  factory _$$DetailRealisasiOpModelImplCopyWith(
    _$DetailRealisasiOpModelImpl value,
    $Res Function(_$DetailRealisasiOpModelImpl) then,
  ) = __$$DetailRealisasiOpModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'nop') String? nop,
    @JsonKey(name: 'namaOp') String? namaOp,
    @JsonKey(name: 'uptbId') int? uptbId,
    @JsonKey(name: 'tahun') int? tahun,
    @JsonKey(name: 'isDigital') bool? isDigital,
    @JsonKey(name: 'tglDigitalisasi') String? tglDigitalisasi,
    @JsonKey(name: 'nominalNonDigital') double? nominalNonDigital,
    @JsonKey(name: 'nominalDigital') double? nominalDigital,
    @JsonKey(name: 'totalNominal') double? totalNominal,
    @JsonKey(name: 'realisasiPerBulan')
    List<RealisasiPerBulanModel>? realisasiPerBulan,
  });
}

/// @nodoc
class __$$DetailRealisasiOpModelImplCopyWithImpl<$Res>
    extends
        _$DetailRealisasiOpModelCopyWithImpl<$Res, _$DetailRealisasiOpModelImpl>
    implements _$$DetailRealisasiOpModelImplCopyWith<$Res> {
  __$$DetailRealisasiOpModelImplCopyWithImpl(
    _$DetailRealisasiOpModelImpl _value,
    $Res Function(_$DetailRealisasiOpModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DetailRealisasiOpModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nop = freezed,
    Object? namaOp = freezed,
    Object? uptbId = freezed,
    Object? tahun = freezed,
    Object? isDigital = freezed,
    Object? tglDigitalisasi = freezed,
    Object? nominalNonDigital = freezed,
    Object? nominalDigital = freezed,
    Object? totalNominal = freezed,
    Object? realisasiPerBulan = freezed,
  }) {
    return _then(
      _$DetailRealisasiOpModelImpl(
        nop: freezed == nop
            ? _value.nop
            : nop // ignore: cast_nullable_to_non_nullable
                  as String?,
        namaOp: freezed == namaOp
            ? _value.namaOp
            : namaOp // ignore: cast_nullable_to_non_nullable
                  as String?,
        uptbId: freezed == uptbId
            ? _value.uptbId
            : uptbId // ignore: cast_nullable_to_non_nullable
                  as int?,
        tahun: freezed == tahun
            ? _value.tahun
            : tahun // ignore: cast_nullable_to_non_nullable
                  as int?,
        isDigital: freezed == isDigital
            ? _value.isDigital
            : isDigital // ignore: cast_nullable_to_non_nullable
                  as bool?,
        tglDigitalisasi: freezed == tglDigitalisasi
            ? _value.tglDigitalisasi
            : tglDigitalisasi // ignore: cast_nullable_to_non_nullable
                  as String?,
        nominalNonDigital: freezed == nominalNonDigital
            ? _value.nominalNonDigital
            : nominalNonDigital // ignore: cast_nullable_to_non_nullable
                  as double?,
        nominalDigital: freezed == nominalDigital
            ? _value.nominalDigital
            : nominalDigital // ignore: cast_nullable_to_non_nullable
                  as double?,
        totalNominal: freezed == totalNominal
            ? _value.totalNominal
            : totalNominal // ignore: cast_nullable_to_non_nullable
                  as double?,
        realisasiPerBulan: freezed == realisasiPerBulan
            ? _value._realisasiPerBulan
            : realisasiPerBulan // ignore: cast_nullable_to_non_nullable
                  as List<RealisasiPerBulanModel>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DetailRealisasiOpModelImpl implements _DetailRealisasiOpModel {
  const _$DetailRealisasiOpModelImpl({
    @JsonKey(name: 'nop') this.nop,
    @JsonKey(name: 'namaOp') this.namaOp,
    @JsonKey(name: 'uptbId') this.uptbId,
    @JsonKey(name: 'tahun') this.tahun,
    @JsonKey(name: 'isDigital') this.isDigital,
    @JsonKey(name: 'tglDigitalisasi') this.tglDigitalisasi,
    @JsonKey(name: 'nominalNonDigital') this.nominalNonDigital,
    @JsonKey(name: 'nominalDigital') this.nominalDigital,
    @JsonKey(name: 'totalNominal') this.totalNominal,
    @JsonKey(name: 'realisasiPerBulan')
    final List<RealisasiPerBulanModel>? realisasiPerBulan,
  }) : _realisasiPerBulan = realisasiPerBulan;

  factory _$DetailRealisasiOpModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DetailRealisasiOpModelImplFromJson(json);

  @override
  @JsonKey(name: 'nop')
  final String? nop;
  @override
  @JsonKey(name: 'namaOp')
  final String? namaOp;
  @override
  @JsonKey(name: 'uptbId')
  final int? uptbId;
  @override
  @JsonKey(name: 'tahun')
  final int? tahun;
  @override
  @JsonKey(name: 'isDigital')
  final bool? isDigital;
  @override
  @JsonKey(name: 'tglDigitalisasi')
  final String? tglDigitalisasi;
  @override
  @JsonKey(name: 'nominalNonDigital')
  final double? nominalNonDigital;
  @override
  @JsonKey(name: 'nominalDigital')
  final double? nominalDigital;
  @override
  @JsonKey(name: 'totalNominal')
  final double? totalNominal;
  final List<RealisasiPerBulanModel>? _realisasiPerBulan;
  @override
  @JsonKey(name: 'realisasiPerBulan')
  List<RealisasiPerBulanModel>? get realisasiPerBulan {
    final value = _realisasiPerBulan;
    if (value == null) return null;
    if (_realisasiPerBulan is EqualUnmodifiableListView)
      return _realisasiPerBulan;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'DetailRealisasiOpModel(nop: $nop, namaOp: $namaOp, uptbId: $uptbId, tahun: $tahun, isDigital: $isDigital, tglDigitalisasi: $tglDigitalisasi, nominalNonDigital: $nominalNonDigital, nominalDigital: $nominalDigital, totalNominal: $totalNominal, realisasiPerBulan: $realisasiPerBulan)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DetailRealisasiOpModelImpl &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
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

  /// Create a copy of DetailRealisasiOpModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DetailRealisasiOpModelImplCopyWith<_$DetailRealisasiOpModelImpl>
  get copyWith =>
      __$$DetailRealisasiOpModelImplCopyWithImpl<_$DetailRealisasiOpModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DetailRealisasiOpModelImplToJson(this);
  }
}

abstract class _DetailRealisasiOpModel implements DetailRealisasiOpModel {
  const factory _DetailRealisasiOpModel({
    @JsonKey(name: 'nop') final String? nop,
    @JsonKey(name: 'namaOp') final String? namaOp,
    @JsonKey(name: 'uptbId') final int? uptbId,
    @JsonKey(name: 'tahun') final int? tahun,
    @JsonKey(name: 'isDigital') final bool? isDigital,
    @JsonKey(name: 'tglDigitalisasi') final String? tglDigitalisasi,
    @JsonKey(name: 'nominalNonDigital') final double? nominalNonDigital,
    @JsonKey(name: 'nominalDigital') final double? nominalDigital,
    @JsonKey(name: 'totalNominal') final double? totalNominal,
    @JsonKey(name: 'realisasiPerBulan')
    final List<RealisasiPerBulanModel>? realisasiPerBulan,
  }) = _$DetailRealisasiOpModelImpl;

  factory _DetailRealisasiOpModel.fromJson(Map<String, dynamic> json) =
      _$DetailRealisasiOpModelImpl.fromJson;

  @override
  @JsonKey(name: 'nop')
  String? get nop;
  @override
  @JsonKey(name: 'namaOp')
  String? get namaOp;
  @override
  @JsonKey(name: 'uptbId')
  int? get uptbId;
  @override
  @JsonKey(name: 'tahun')
  int? get tahun;
  @override
  @JsonKey(name: 'isDigital')
  bool? get isDigital;
  @override
  @JsonKey(name: 'tglDigitalisasi')
  String? get tglDigitalisasi;
  @override
  @JsonKey(name: 'nominalNonDigital')
  double? get nominalNonDigital;
  @override
  @JsonKey(name: 'nominalDigital')
  double? get nominalDigital;
  @override
  @JsonKey(name: 'totalNominal')
  double? get totalNominal;
  @override
  @JsonKey(name: 'realisasiPerBulan')
  List<RealisasiPerBulanModel>? get realisasiPerBulan;

  /// Create a copy of DetailRealisasiOpModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DetailRealisasiOpModelImplCopyWith<_$DetailRealisasiOpModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

RealisasiPerBulanModel _$RealisasiPerBulanModelFromJson(
  Map<String, dynamic> json,
) {
  return _RealisasiPerBulanModel.fromJson(json);
}

/// @nodoc
mixin _$RealisasiPerBulanModel {
  @JsonKey(name: 'bulan')
  int? get bulan => throw _privateConstructorUsedError;
  @JsonKey(name: 'bulanNama')
  String? get bulanNama => throw _privateConstructorUsedError;
  @JsonKey(name: 'tglSspd')
  String? get tglSspd => throw _privateConstructorUsedError;
  @JsonKey(name: 'nominalNonDigital')
  double? get nominalNonDigital => throw _privateConstructorUsedError;
  @JsonKey(name: 'nominalDigital')
  double? get nominalDigital => throw _privateConstructorUsedError;
  @JsonKey(name: 'totalNominal')
  double? get totalNominal => throw _privateConstructorUsedError;

  /// Serializes this RealisasiPerBulanModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RealisasiPerBulanModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RealisasiPerBulanModelCopyWith<RealisasiPerBulanModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RealisasiPerBulanModelCopyWith<$Res> {
  factory $RealisasiPerBulanModelCopyWith(
    RealisasiPerBulanModel value,
    $Res Function(RealisasiPerBulanModel) then,
  ) = _$RealisasiPerBulanModelCopyWithImpl<$Res, RealisasiPerBulanModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'bulan') int? bulan,
    @JsonKey(name: 'bulanNama') String? bulanNama,
    @JsonKey(name: 'tglSspd') String? tglSspd,
    @JsonKey(name: 'nominalNonDigital') double? nominalNonDigital,
    @JsonKey(name: 'nominalDigital') double? nominalDigital,
    @JsonKey(name: 'totalNominal') double? totalNominal,
  });
}

/// @nodoc
class _$RealisasiPerBulanModelCopyWithImpl<
  $Res,
  $Val extends RealisasiPerBulanModel
>
    implements $RealisasiPerBulanModelCopyWith<$Res> {
  _$RealisasiPerBulanModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RealisasiPerBulanModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bulan = freezed,
    Object? bulanNama = freezed,
    Object? tglSspd = freezed,
    Object? nominalNonDigital = freezed,
    Object? nominalDigital = freezed,
    Object? totalNominal = freezed,
  }) {
    return _then(
      _value.copyWith(
            bulan: freezed == bulan
                ? _value.bulan
                : bulan // ignore: cast_nullable_to_non_nullable
                      as int?,
            bulanNama: freezed == bulanNama
                ? _value.bulanNama
                : bulanNama // ignore: cast_nullable_to_non_nullable
                      as String?,
            tglSspd: freezed == tglSspd
                ? _value.tglSspd
                : tglSspd // ignore: cast_nullable_to_non_nullable
                      as String?,
            nominalNonDigital: freezed == nominalNonDigital
                ? _value.nominalNonDigital
                : nominalNonDigital // ignore: cast_nullable_to_non_nullable
                      as double?,
            nominalDigital: freezed == nominalDigital
                ? _value.nominalDigital
                : nominalDigital // ignore: cast_nullable_to_non_nullable
                      as double?,
            totalNominal: freezed == totalNominal
                ? _value.totalNominal
                : totalNominal // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RealisasiPerBulanModelImplCopyWith<$Res>
    implements $RealisasiPerBulanModelCopyWith<$Res> {
  factory _$$RealisasiPerBulanModelImplCopyWith(
    _$RealisasiPerBulanModelImpl value,
    $Res Function(_$RealisasiPerBulanModelImpl) then,
  ) = __$$RealisasiPerBulanModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'bulan') int? bulan,
    @JsonKey(name: 'bulanNama') String? bulanNama,
    @JsonKey(name: 'tglSspd') String? tglSspd,
    @JsonKey(name: 'nominalNonDigital') double? nominalNonDigital,
    @JsonKey(name: 'nominalDigital') double? nominalDigital,
    @JsonKey(name: 'totalNominal') double? totalNominal,
  });
}

/// @nodoc
class __$$RealisasiPerBulanModelImplCopyWithImpl<$Res>
    extends
        _$RealisasiPerBulanModelCopyWithImpl<$Res, _$RealisasiPerBulanModelImpl>
    implements _$$RealisasiPerBulanModelImplCopyWith<$Res> {
  __$$RealisasiPerBulanModelImplCopyWithImpl(
    _$RealisasiPerBulanModelImpl _value,
    $Res Function(_$RealisasiPerBulanModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RealisasiPerBulanModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bulan = freezed,
    Object? bulanNama = freezed,
    Object? tglSspd = freezed,
    Object? nominalNonDigital = freezed,
    Object? nominalDigital = freezed,
    Object? totalNominal = freezed,
  }) {
    return _then(
      _$RealisasiPerBulanModelImpl(
        bulan: freezed == bulan
            ? _value.bulan
            : bulan // ignore: cast_nullable_to_non_nullable
                  as int?,
        bulanNama: freezed == bulanNama
            ? _value.bulanNama
            : bulanNama // ignore: cast_nullable_to_non_nullable
                  as String?,
        tglSspd: freezed == tglSspd
            ? _value.tglSspd
            : tglSspd // ignore: cast_nullable_to_non_nullable
                  as String?,
        nominalNonDigital: freezed == nominalNonDigital
            ? _value.nominalNonDigital
            : nominalNonDigital // ignore: cast_nullable_to_non_nullable
                  as double?,
        nominalDigital: freezed == nominalDigital
            ? _value.nominalDigital
            : nominalDigital // ignore: cast_nullable_to_non_nullable
                  as double?,
        totalNominal: freezed == totalNominal
            ? _value.totalNominal
            : totalNominal // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RealisasiPerBulanModelImpl implements _RealisasiPerBulanModel {
  const _$RealisasiPerBulanModelImpl({
    @JsonKey(name: 'bulan') this.bulan,
    @JsonKey(name: 'bulanNama') this.bulanNama,
    @JsonKey(name: 'tglSspd') this.tglSspd,
    @JsonKey(name: 'nominalNonDigital') this.nominalNonDigital,
    @JsonKey(name: 'nominalDigital') this.nominalDigital,
    @JsonKey(name: 'totalNominal') this.totalNominal,
  });

  factory _$RealisasiPerBulanModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RealisasiPerBulanModelImplFromJson(json);

  @override
  @JsonKey(name: 'bulan')
  final int? bulan;
  @override
  @JsonKey(name: 'bulanNama')
  final String? bulanNama;
  @override
  @JsonKey(name: 'tglSspd')
  final String? tglSspd;
  @override
  @JsonKey(name: 'nominalNonDigital')
  final double? nominalNonDigital;
  @override
  @JsonKey(name: 'nominalDigital')
  final double? nominalDigital;
  @override
  @JsonKey(name: 'totalNominal')
  final double? totalNominal;

  @override
  String toString() {
    return 'RealisasiPerBulanModel(bulan: $bulan, bulanNama: $bulanNama, tglSspd: $tglSspd, nominalNonDigital: $nominalNonDigital, nominalDigital: $nominalDigital, totalNominal: $totalNominal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RealisasiPerBulanModelImpl &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
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

  /// Create a copy of RealisasiPerBulanModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RealisasiPerBulanModelImplCopyWith<_$RealisasiPerBulanModelImpl>
  get copyWith =>
      __$$RealisasiPerBulanModelImplCopyWithImpl<_$RealisasiPerBulanModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RealisasiPerBulanModelImplToJson(this);
  }
}

abstract class _RealisasiPerBulanModel implements RealisasiPerBulanModel {
  const factory _RealisasiPerBulanModel({
    @JsonKey(name: 'bulan') final int? bulan,
    @JsonKey(name: 'bulanNama') final String? bulanNama,
    @JsonKey(name: 'tglSspd') final String? tglSspd,
    @JsonKey(name: 'nominalNonDigital') final double? nominalNonDigital,
    @JsonKey(name: 'nominalDigital') final double? nominalDigital,
    @JsonKey(name: 'totalNominal') final double? totalNominal,
  }) = _$RealisasiPerBulanModelImpl;

  factory _RealisasiPerBulanModel.fromJson(Map<String, dynamic> json) =
      _$RealisasiPerBulanModelImpl.fromJson;

  @override
  @JsonKey(name: 'bulan')
  int? get bulan;
  @override
  @JsonKey(name: 'bulanNama')
  String? get bulanNama;
  @override
  @JsonKey(name: 'tglSspd')
  String? get tglSspd;
  @override
  @JsonKey(name: 'nominalNonDigital')
  double? get nominalNonDigital;
  @override
  @JsonKey(name: 'nominalDigital')
  double? get nominalDigital;
  @override
  @JsonKey(name: 'totalNominal')
  double? get totalNominal;

  /// Create a copy of RealisasiPerBulanModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RealisasiPerBulanModelImplCopyWith<_$RealisasiPerBulanModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
