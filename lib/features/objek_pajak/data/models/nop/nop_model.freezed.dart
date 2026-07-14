// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nop_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NopModel _$NopModelFromJson(Map<String, dynamic> json) {
  return _NopModel.fromJson(json);
}

/// @nodoc
mixin _$NopModel {
  bool get isSuccess => throw _privateConstructorUsedError;
  int get statusCode => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  NopDataModel get data => throw _privateConstructorUsedError;

  /// Serializes this NopModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NopModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NopModelCopyWith<NopModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NopModelCopyWith<$Res> {
  factory $NopModelCopyWith(NopModel value, $Res Function(NopModel) then) =
      _$NopModelCopyWithImpl<$Res, NopModel>;
  @useResult
  $Res call({
    bool isSuccess,
    int statusCode,
    String message,
    NopDataModel data,
  });

  $NopDataModelCopyWith<$Res> get data;
}

/// @nodoc
class _$NopModelCopyWithImpl<$Res, $Val extends NopModel>
    implements $NopModelCopyWith<$Res> {
  _$NopModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NopModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSuccess = null,
    Object? statusCode = null,
    Object? message = null,
    Object? data = null,
  }) {
    return _then(
      _value.copyWith(
            isSuccess: null == isSuccess
                ? _value.isSuccess
                : isSuccess // ignore: cast_nullable_to_non_nullable
                      as bool,
            statusCode: null == statusCode
                ? _value.statusCode
                : statusCode // ignore: cast_nullable_to_non_nullable
                      as int,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            data: null == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as NopDataModel,
          )
          as $Val,
    );
  }

  /// Create a copy of NopModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NopDataModelCopyWith<$Res> get data {
    return $NopDataModelCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NopModelImplCopyWith<$Res>
    implements $NopModelCopyWith<$Res> {
  factory _$$NopModelImplCopyWith(
    _$NopModelImpl value,
    $Res Function(_$NopModelImpl) then,
  ) = __$$NopModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isSuccess,
    int statusCode,
    String message,
    NopDataModel data,
  });

  @override
  $NopDataModelCopyWith<$Res> get data;
}

/// @nodoc
class __$$NopModelImplCopyWithImpl<$Res>
    extends _$NopModelCopyWithImpl<$Res, _$NopModelImpl>
    implements _$$NopModelImplCopyWith<$Res> {
  __$$NopModelImplCopyWithImpl(
    _$NopModelImpl _value,
    $Res Function(_$NopModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NopModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSuccess = null,
    Object? statusCode = null,
    Object? message = null,
    Object? data = null,
  }) {
    return _then(
      _$NopModelImpl(
        isSuccess: null == isSuccess
            ? _value.isSuccess
            : isSuccess // ignore: cast_nullable_to_non_nullable
                  as bool,
        statusCode: null == statusCode
            ? _value.statusCode
            : statusCode // ignore: cast_nullable_to_non_nullable
                  as int,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        data: null == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as NopDataModel,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NopModelImpl implements _NopModel {
  const _$NopModelImpl({
    this.isSuccess = false,
    this.statusCode = 0,
    this.message = '',
    this.data = const NopDataModel(),
  });

  factory _$NopModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NopModelImplFromJson(json);

  @override
  @JsonKey()
  final bool isSuccess;
  @override
  @JsonKey()
  final int statusCode;
  @override
  @JsonKey()
  final String message;
  @override
  @JsonKey()
  final NopDataModel data;

  @override
  String toString() {
    return 'NopModel(isSuccess: $isSuccess, statusCode: $statusCode, message: $message, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NopModelImpl &&
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

  /// Create a copy of NopModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NopModelImplCopyWith<_$NopModelImpl> get copyWith =>
      __$$NopModelImplCopyWithImpl<_$NopModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NopModelImplToJson(this);
  }
}

abstract class _NopModel implements NopModel {
  const factory _NopModel({
    final bool isSuccess,
    final int statusCode,
    final String message,
    final NopDataModel data,
  }) = _$NopModelImpl;

  factory _NopModel.fromJson(Map<String, dynamic> json) =
      _$NopModelImpl.fromJson;

  @override
  bool get isSuccess;
  @override
  int get statusCode;
  @override
  String get message;
  @override
  NopDataModel get data;

  /// Create a copy of NopModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NopModelImplCopyWith<_$NopModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NopDataModel _$NopDataModelFromJson(Map<String, dynamic> json) {
  return _NopDataModel.fromJson(json);
}

/// @nodoc
mixin _$NopDataModel {
  String get nop => throw _privateConstructorUsedError;
  String get namaOp => throw _privateConstructorUsedError;
  String get alamatOp => throw _privateConstructorUsedError;
  bool get isDigital => throw _privateConstructorUsedError;
  int get pungutTarif => throw _privateConstructorUsedError;
  int get uptb => throw _privateConstructorUsedError;
  String get statusDigitalisasi => throw _privateConstructorUsedError;
  int get totalPendapatan => throw _privateConstructorUsedError;

  /// Serializes this NopDataModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NopDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NopDataModelCopyWith<NopDataModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NopDataModelCopyWith<$Res> {
  factory $NopDataModelCopyWith(
    NopDataModel value,
    $Res Function(NopDataModel) then,
  ) = _$NopDataModelCopyWithImpl<$Res, NopDataModel>;
  @useResult
  $Res call({
    String nop,
    String namaOp,
    String alamatOp,
    bool isDigital,
    int pungutTarif,
    int uptb,
    String statusDigitalisasi,
    int totalPendapatan,
  });
}

/// @nodoc
class _$NopDataModelCopyWithImpl<$Res, $Val extends NopDataModel>
    implements $NopDataModelCopyWith<$Res> {
  _$NopDataModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NopDataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nop = null,
    Object? namaOp = null,
    Object? alamatOp = null,
    Object? isDigital = null,
    Object? pungutTarif = null,
    Object? uptb = null,
    Object? statusDigitalisasi = null,
    Object? totalPendapatan = null,
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
            alamatOp: null == alamatOp
                ? _value.alamatOp
                : alamatOp // ignore: cast_nullable_to_non_nullable
                      as String,
            isDigital: null == isDigital
                ? _value.isDigital
                : isDigital // ignore: cast_nullable_to_non_nullable
                      as bool,
            pungutTarif: null == pungutTarif
                ? _value.pungutTarif
                : pungutTarif // ignore: cast_nullable_to_non_nullable
                      as int,
            uptb: null == uptb
                ? _value.uptb
                : uptb // ignore: cast_nullable_to_non_nullable
                      as int,
            statusDigitalisasi: null == statusDigitalisasi
                ? _value.statusDigitalisasi
                : statusDigitalisasi // ignore: cast_nullable_to_non_nullable
                      as String,
            totalPendapatan: null == totalPendapatan
                ? _value.totalPendapatan
                : totalPendapatan // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NopDataModelImplCopyWith<$Res>
    implements $NopDataModelCopyWith<$Res> {
  factory _$$NopDataModelImplCopyWith(
    _$NopDataModelImpl value,
    $Res Function(_$NopDataModelImpl) then,
  ) = __$$NopDataModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String nop,
    String namaOp,
    String alamatOp,
    bool isDigital,
    int pungutTarif,
    int uptb,
    String statusDigitalisasi,
    int totalPendapatan,
  });
}

/// @nodoc
class __$$NopDataModelImplCopyWithImpl<$Res>
    extends _$NopDataModelCopyWithImpl<$Res, _$NopDataModelImpl>
    implements _$$NopDataModelImplCopyWith<$Res> {
  __$$NopDataModelImplCopyWithImpl(
    _$NopDataModelImpl _value,
    $Res Function(_$NopDataModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NopDataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nop = null,
    Object? namaOp = null,
    Object? alamatOp = null,
    Object? isDigital = null,
    Object? pungutTarif = null,
    Object? uptb = null,
    Object? statusDigitalisasi = null,
    Object? totalPendapatan = null,
  }) {
    return _then(
      _$NopDataModelImpl(
        nop: null == nop
            ? _value.nop
            : nop // ignore: cast_nullable_to_non_nullable
                  as String,
        namaOp: null == namaOp
            ? _value.namaOp
            : namaOp // ignore: cast_nullable_to_non_nullable
                  as String,
        alamatOp: null == alamatOp
            ? _value.alamatOp
            : alamatOp // ignore: cast_nullable_to_non_nullable
                  as String,
        isDigital: null == isDigital
            ? _value.isDigital
            : isDigital // ignore: cast_nullable_to_non_nullable
                  as bool,
        pungutTarif: null == pungutTarif
            ? _value.pungutTarif
            : pungutTarif // ignore: cast_nullable_to_non_nullable
                  as int,
        uptb: null == uptb
            ? _value.uptb
            : uptb // ignore: cast_nullable_to_non_nullable
                  as int,
        statusDigitalisasi: null == statusDigitalisasi
            ? _value.statusDigitalisasi
            : statusDigitalisasi // ignore: cast_nullable_to_non_nullable
                  as String,
        totalPendapatan: null == totalPendapatan
            ? _value.totalPendapatan
            : totalPendapatan // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NopDataModelImpl implements _NopDataModel {
  const _$NopDataModelImpl({
    this.nop = '',
    this.namaOp = '',
    this.alamatOp = '',
    this.isDigital = false,
    this.pungutTarif = 0,
    this.uptb = 0,
    this.statusDigitalisasi = '',
    this.totalPendapatan = 0,
  });

  factory _$NopDataModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NopDataModelImplFromJson(json);

  @override
  @JsonKey()
  final String nop;
  @override
  @JsonKey()
  final String namaOp;
  @override
  @JsonKey()
  final String alamatOp;
  @override
  @JsonKey()
  final bool isDigital;
  @override
  @JsonKey()
  final int pungutTarif;
  @override
  @JsonKey()
  final int uptb;
  @override
  @JsonKey()
  final String statusDigitalisasi;
  @override
  @JsonKey()
  final int totalPendapatan;

  @override
  String toString() {
    return 'NopDataModel(nop: $nop, namaOp: $namaOp, alamatOp: $alamatOp, isDigital: $isDigital, pungutTarif: $pungutTarif, uptb: $uptb, statusDigitalisasi: $statusDigitalisasi, totalPendapatan: $totalPendapatan)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NopDataModelImpl &&
            (identical(other.nop, nop) || other.nop == nop) &&
            (identical(other.namaOp, namaOp) || other.namaOp == namaOp) &&
            (identical(other.alamatOp, alamatOp) ||
                other.alamatOp == alamatOp) &&
            (identical(other.isDigital, isDigital) ||
                other.isDigital == isDigital) &&
            (identical(other.pungutTarif, pungutTarif) ||
                other.pungutTarif == pungutTarif) &&
            (identical(other.uptb, uptb) || other.uptb == uptb) &&
            (identical(other.statusDigitalisasi, statusDigitalisasi) ||
                other.statusDigitalisasi == statusDigitalisasi) &&
            (identical(other.totalPendapatan, totalPendapatan) ||
                other.totalPendapatan == totalPendapatan));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    nop,
    namaOp,
    alamatOp,
    isDigital,
    pungutTarif,
    uptb,
    statusDigitalisasi,
    totalPendapatan,
  );

  /// Create a copy of NopDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NopDataModelImplCopyWith<_$NopDataModelImpl> get copyWith =>
      __$$NopDataModelImplCopyWithImpl<_$NopDataModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NopDataModelImplToJson(this);
  }
}

abstract class _NopDataModel implements NopDataModel {
  const factory _NopDataModel({
    final String nop,
    final String namaOp,
    final String alamatOp,
    final bool isDigital,
    final int pungutTarif,
    final int uptb,
    final String statusDigitalisasi,
    final int totalPendapatan,
  }) = _$NopDataModelImpl;

  factory _NopDataModel.fromJson(Map<String, dynamic> json) =
      _$NopDataModelImpl.fromJson;

  @override
  String get nop;
  @override
  String get namaOp;
  @override
  String get alamatOp;
  @override
  bool get isDigital;
  @override
  int get pungutTarif;
  @override
  int get uptb;
  @override
  String get statusDigitalisasi;
  @override
  int get totalPendapatan;

  /// Create a copy of NopDataModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NopDataModelImplCopyWith<_$NopDataModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
