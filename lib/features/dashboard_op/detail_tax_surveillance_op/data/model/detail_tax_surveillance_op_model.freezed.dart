// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'detail_tax_surveillance_op_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TaxSurveillanceDetailRequestModel _$TaxSurveillanceDetailRequestModelFromJson(
  Map<String, dynamic> json,
) {
  return _TaxSurveillanceDetailRequestModel.fromJson(json);
}

/// @nodoc
mixin _$TaxSurveillanceDetailRequestModel {
  String get nop => throw _privateConstructorUsedError;
  @ServerUtcDateTimeConverter()
  DateTime get startDate => throw _privateConstructorUsedError;
  @ServerUtcDateTimeConverter()
  DateTime get endDate => throw _privateConstructorUsedError;

  /// Serializes this TaxSurveillanceDetailRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaxSurveillanceDetailRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaxSurveillanceDetailRequestModelCopyWith<TaxSurveillanceDetailRequestModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaxSurveillanceDetailRequestModelCopyWith<$Res> {
  factory $TaxSurveillanceDetailRequestModelCopyWith(
    TaxSurveillanceDetailRequestModel value,
    $Res Function(TaxSurveillanceDetailRequestModel) then,
  ) =
      _$TaxSurveillanceDetailRequestModelCopyWithImpl<
        $Res,
        TaxSurveillanceDetailRequestModel
      >;
  @useResult
  $Res call({
    String nop,
    @ServerUtcDateTimeConverter() DateTime startDate,
    @ServerUtcDateTimeConverter() DateTime endDate,
  });
}

/// @nodoc
class _$TaxSurveillanceDetailRequestModelCopyWithImpl<
  $Res,
  $Val extends TaxSurveillanceDetailRequestModel
>
    implements $TaxSurveillanceDetailRequestModelCopyWith<$Res> {
  _$TaxSurveillanceDetailRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaxSurveillanceDetailRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nop = null,
    Object? startDate = null,
    Object? endDate = null,
  }) {
    return _then(
      _value.copyWith(
            nop: null == nop
                ? _value.nop
                : nop // ignore: cast_nullable_to_non_nullable
                      as String,
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endDate: null == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TaxSurveillanceDetailRequestModelImplCopyWith<$Res>
    implements $TaxSurveillanceDetailRequestModelCopyWith<$Res> {
  factory _$$TaxSurveillanceDetailRequestModelImplCopyWith(
    _$TaxSurveillanceDetailRequestModelImpl value,
    $Res Function(_$TaxSurveillanceDetailRequestModelImpl) then,
  ) = __$$TaxSurveillanceDetailRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String nop,
    @ServerUtcDateTimeConverter() DateTime startDate,
    @ServerUtcDateTimeConverter() DateTime endDate,
  });
}

/// @nodoc
class __$$TaxSurveillanceDetailRequestModelImplCopyWithImpl<$Res>
    extends
        _$TaxSurveillanceDetailRequestModelCopyWithImpl<
          $Res,
          _$TaxSurveillanceDetailRequestModelImpl
        >
    implements _$$TaxSurveillanceDetailRequestModelImplCopyWith<$Res> {
  __$$TaxSurveillanceDetailRequestModelImplCopyWithImpl(
    _$TaxSurveillanceDetailRequestModelImpl _value,
    $Res Function(_$TaxSurveillanceDetailRequestModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TaxSurveillanceDetailRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nop = null,
    Object? startDate = null,
    Object? endDate = null,
  }) {
    return _then(
      _$TaxSurveillanceDetailRequestModelImpl(
        nop: null == nop
            ? _value.nop
            : nop // ignore: cast_nullable_to_non_nullable
                  as String,
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endDate: null == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TaxSurveillanceDetailRequestModelImpl
    implements _TaxSurveillanceDetailRequestModel {
  const _$TaxSurveillanceDetailRequestModelImpl({
    required this.nop,
    @ServerUtcDateTimeConverter() required this.startDate,
    @ServerUtcDateTimeConverter() required this.endDate,
  });

  factory _$TaxSurveillanceDetailRequestModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$TaxSurveillanceDetailRequestModelImplFromJson(json);

  @override
  final String nop;
  @override
  @ServerUtcDateTimeConverter()
  final DateTime startDate;
  @override
  @ServerUtcDateTimeConverter()
  final DateTime endDate;

  @override
  String toString() {
    return 'TaxSurveillanceDetailRequestModel(nop: $nop, startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaxSurveillanceDetailRequestModelImpl &&
            (identical(other.nop, nop) || other.nop == nop) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, nop, startDate, endDate);

  /// Create a copy of TaxSurveillanceDetailRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaxSurveillanceDetailRequestModelImplCopyWith<
    _$TaxSurveillanceDetailRequestModelImpl
  >
  get copyWith =>
      __$$TaxSurveillanceDetailRequestModelImplCopyWithImpl<
        _$TaxSurveillanceDetailRequestModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaxSurveillanceDetailRequestModelImplToJson(this);
  }
}

abstract class _TaxSurveillanceDetailRequestModel
    implements TaxSurveillanceDetailRequestModel {
  const factory _TaxSurveillanceDetailRequestModel({
    required final String nop,
    @ServerUtcDateTimeConverter() required final DateTime startDate,
    @ServerUtcDateTimeConverter() required final DateTime endDate,
  }) = _$TaxSurveillanceDetailRequestModelImpl;

  factory _TaxSurveillanceDetailRequestModel.fromJson(
    Map<String, dynamic> json,
  ) = _$TaxSurveillanceDetailRequestModelImpl.fromJson;

  @override
  String get nop;
  @override
  @ServerUtcDateTimeConverter()
  DateTime get startDate;
  @override
  @ServerUtcDateTimeConverter()
  DateTime get endDate;

  /// Create a copy of TaxSurveillanceDetailRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaxSurveillanceDetailRequestModelImplCopyWith<
    _$TaxSurveillanceDetailRequestModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

TaxSurveillanceDetailResponseModel _$TaxSurveillanceDetailResponseModelFromJson(
  Map<String, dynamic> json,
) {
  return _TaxSurveillanceDetailResponseModel.fromJson(json);
}

/// @nodoc
mixin _$TaxSurveillanceDetailResponseModel {
  String get jenisKendaraan => throw _privateConstructorUsedError;
  int get nominal => throw _privateConstructorUsedError;
  DateTime get tgl => throw _privateConstructorUsedError;

  /// Serializes this TaxSurveillanceDetailResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaxSurveillanceDetailResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaxSurveillanceDetailResponseModelCopyWith<
    TaxSurveillanceDetailResponseModel
  >
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaxSurveillanceDetailResponseModelCopyWith<$Res> {
  factory $TaxSurveillanceDetailResponseModelCopyWith(
    TaxSurveillanceDetailResponseModel value,
    $Res Function(TaxSurveillanceDetailResponseModel) then,
  ) =
      _$TaxSurveillanceDetailResponseModelCopyWithImpl<
        $Res,
        TaxSurveillanceDetailResponseModel
      >;
  @useResult
  $Res call({String jenisKendaraan, int nominal, DateTime tgl});
}

/// @nodoc
class _$TaxSurveillanceDetailResponseModelCopyWithImpl<
  $Res,
  $Val extends TaxSurveillanceDetailResponseModel
>
    implements $TaxSurveillanceDetailResponseModelCopyWith<$Res> {
  _$TaxSurveillanceDetailResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaxSurveillanceDetailResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? jenisKendaraan = null,
    Object? nominal = null,
    Object? tgl = null,
  }) {
    return _then(
      _value.copyWith(
            jenisKendaraan: null == jenisKendaraan
                ? _value.jenisKendaraan
                : jenisKendaraan // ignore: cast_nullable_to_non_nullable
                      as String,
            nominal: null == nominal
                ? _value.nominal
                : nominal // ignore: cast_nullable_to_non_nullable
                      as int,
            tgl: null == tgl
                ? _value.tgl
                : tgl // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TaxSurveillanceDetailResponseModelImplCopyWith<$Res>
    implements $TaxSurveillanceDetailResponseModelCopyWith<$Res> {
  factory _$$TaxSurveillanceDetailResponseModelImplCopyWith(
    _$TaxSurveillanceDetailResponseModelImpl value,
    $Res Function(_$TaxSurveillanceDetailResponseModelImpl) then,
  ) = __$$TaxSurveillanceDetailResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String jenisKendaraan, int nominal, DateTime tgl});
}

/// @nodoc
class __$$TaxSurveillanceDetailResponseModelImplCopyWithImpl<$Res>
    extends
        _$TaxSurveillanceDetailResponseModelCopyWithImpl<
          $Res,
          _$TaxSurveillanceDetailResponseModelImpl
        >
    implements _$$TaxSurveillanceDetailResponseModelImplCopyWith<$Res> {
  __$$TaxSurveillanceDetailResponseModelImplCopyWithImpl(
    _$TaxSurveillanceDetailResponseModelImpl _value,
    $Res Function(_$TaxSurveillanceDetailResponseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TaxSurveillanceDetailResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? jenisKendaraan = null,
    Object? nominal = null,
    Object? tgl = null,
  }) {
    return _then(
      _$TaxSurveillanceDetailResponseModelImpl(
        jenisKendaraan: null == jenisKendaraan
            ? _value.jenisKendaraan
            : jenisKendaraan // ignore: cast_nullable_to_non_nullable
                  as String,
        nominal: null == nominal
            ? _value.nominal
            : nominal // ignore: cast_nullable_to_non_nullable
                  as int,
        tgl: null == tgl
            ? _value.tgl
            : tgl // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TaxSurveillanceDetailResponseModelImpl
    implements _TaxSurveillanceDetailResponseModel {
  const _$TaxSurveillanceDetailResponseModelImpl({
    required this.jenisKendaraan,
    required this.nominal,
    required this.tgl,
  });

  factory _$TaxSurveillanceDetailResponseModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$TaxSurveillanceDetailResponseModelImplFromJson(json);

  @override
  final String jenisKendaraan;
  @override
  final int nominal;
  @override
  final DateTime tgl;

  @override
  String toString() {
    return 'TaxSurveillanceDetailResponseModel(jenisKendaraan: $jenisKendaraan, nominal: $nominal, tgl: $tgl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaxSurveillanceDetailResponseModelImpl &&
            (identical(other.jenisKendaraan, jenisKendaraan) ||
                other.jenisKendaraan == jenisKendaraan) &&
            (identical(other.nominal, nominal) || other.nominal == nominal) &&
            (identical(other.tgl, tgl) || other.tgl == tgl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, jenisKendaraan, nominal, tgl);

  /// Create a copy of TaxSurveillanceDetailResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaxSurveillanceDetailResponseModelImplCopyWith<
    _$TaxSurveillanceDetailResponseModelImpl
  >
  get copyWith =>
      __$$TaxSurveillanceDetailResponseModelImplCopyWithImpl<
        _$TaxSurveillanceDetailResponseModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaxSurveillanceDetailResponseModelImplToJson(this);
  }
}

abstract class _TaxSurveillanceDetailResponseModel
    implements TaxSurveillanceDetailResponseModel {
  const factory _TaxSurveillanceDetailResponseModel({
    required final String jenisKendaraan,
    required final int nominal,
    required final DateTime tgl,
  }) = _$TaxSurveillanceDetailResponseModelImpl;

  factory _TaxSurveillanceDetailResponseModel.fromJson(
    Map<String, dynamic> json,
  ) = _$TaxSurveillanceDetailResponseModelImpl.fromJson;

  @override
  String get jenisKendaraan;
  @override
  int get nominal;
  @override
  DateTime get tgl;

  /// Create a copy of TaxSurveillanceDetailResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaxSurveillanceDetailResponseModelImplCopyWith<
    _$TaxSurveillanceDetailResponseModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
