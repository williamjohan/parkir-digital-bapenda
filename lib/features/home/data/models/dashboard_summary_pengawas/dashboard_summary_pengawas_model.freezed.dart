// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_summary_pengawas_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DashboardSummaryPengawasModel _$DashboardSummaryPengawasModelFromJson(
  Map<String, dynamic> json,
) {
  return _DashboardSummaryPengawasModel.fromJson(json);
}

/// @nodoc
mixin _$DashboardSummaryPengawasModel {
  bool get isSuccess => throw _privateConstructorUsedError;
  int get statusCode => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  DashboardDataModel get data => throw _privateConstructorUsedError;

  /// Serializes this DashboardSummaryPengawasModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DashboardSummaryPengawasModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardSummaryPengawasModelCopyWith<DashboardSummaryPengawasModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardSummaryPengawasModelCopyWith<$Res> {
  factory $DashboardSummaryPengawasModelCopyWith(
    DashboardSummaryPengawasModel value,
    $Res Function(DashboardSummaryPengawasModel) then,
  ) =
      _$DashboardSummaryPengawasModelCopyWithImpl<
        $Res,
        DashboardSummaryPengawasModel
      >;
  @useResult
  $Res call({
    bool isSuccess,
    int statusCode,
    String message,
    DashboardDataModel data,
  });

  $DashboardDataModelCopyWith<$Res> get data;
}

/// @nodoc
class _$DashboardSummaryPengawasModelCopyWithImpl<
  $Res,
  $Val extends DashboardSummaryPengawasModel
>
    implements $DashboardSummaryPengawasModelCopyWith<$Res> {
  _$DashboardSummaryPengawasModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardSummaryPengawasModel
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
                      as DashboardDataModel,
          )
          as $Val,
    );
  }

  /// Create a copy of DashboardSummaryPengawasModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DashboardDataModelCopyWith<$Res> get data {
    return $DashboardDataModelCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DashboardSummaryPengawasModelImplCopyWith<$Res>
    implements $DashboardSummaryPengawasModelCopyWith<$Res> {
  factory _$$DashboardSummaryPengawasModelImplCopyWith(
    _$DashboardSummaryPengawasModelImpl value,
    $Res Function(_$DashboardSummaryPengawasModelImpl) then,
  ) = __$$DashboardSummaryPengawasModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isSuccess,
    int statusCode,
    String message,
    DashboardDataModel data,
  });

  @override
  $DashboardDataModelCopyWith<$Res> get data;
}

/// @nodoc
class __$$DashboardSummaryPengawasModelImplCopyWithImpl<$Res>
    extends
        _$DashboardSummaryPengawasModelCopyWithImpl<
          $Res,
          _$DashboardSummaryPengawasModelImpl
        >
    implements _$$DashboardSummaryPengawasModelImplCopyWith<$Res> {
  __$$DashboardSummaryPengawasModelImplCopyWithImpl(
    _$DashboardSummaryPengawasModelImpl _value,
    $Res Function(_$DashboardSummaryPengawasModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DashboardSummaryPengawasModel
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
      _$DashboardSummaryPengawasModelImpl(
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
                  as DashboardDataModel,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardSummaryPengawasModelImpl
    implements _DashboardSummaryPengawasModel {
  const _$DashboardSummaryPengawasModelImpl({
    this.isSuccess = false,
    this.statusCode = 0,
    this.message = '',
    this.data = const DashboardDataModel(),
  });

  factory _$DashboardSummaryPengawasModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$DashboardSummaryPengawasModelImplFromJson(json);

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
  final DashboardDataModel data;

  @override
  String toString() {
    return 'DashboardSummaryPengawasModel(isSuccess: $isSuccess, statusCode: $statusCode, message: $message, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardSummaryPengawasModelImpl &&
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

  /// Create a copy of DashboardSummaryPengawasModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardSummaryPengawasModelImplCopyWith<
    _$DashboardSummaryPengawasModelImpl
  >
  get copyWith =>
      __$$DashboardSummaryPengawasModelImplCopyWithImpl<
        _$DashboardSummaryPengawasModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardSummaryPengawasModelImplToJson(this);
  }
}

abstract class _DashboardSummaryPengawasModel
    implements DashboardSummaryPengawasModel {
  const factory _DashboardSummaryPengawasModel({
    final bool isSuccess,
    final int statusCode,
    final String message,
    final DashboardDataModel data,
  }) = _$DashboardSummaryPengawasModelImpl;

  factory _DashboardSummaryPengawasModel.fromJson(Map<String, dynamic> json) =
      _$DashboardSummaryPengawasModelImpl.fromJson;

  @override
  bool get isSuccess;
  @override
  int get statusCode;
  @override
  String get message;
  @override
  DashboardDataModel get data;

  /// Create a copy of DashboardSummaryPengawasModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardSummaryPengawasModelImplCopyWith<
    _$DashboardSummaryPengawasModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

DashboardDataModel _$DashboardDataModelFromJson(Map<String, dynamic> json) {
  return _DashboardDataModel.fromJson(json);
}

/// @nodoc
mixin _$DashboardDataModel {
  int get laporanPelanggaran => throw _privateConstructorUsedError;
  DashboardInfoModel get dashboard => throw _privateConstructorUsedError;
  CheckInOutModel get checkInOut => throw _privateConstructorUsedError;

  /// Serializes this DashboardDataModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DashboardDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardDataModelCopyWith<DashboardDataModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardDataModelCopyWith<$Res> {
  factory $DashboardDataModelCopyWith(
    DashboardDataModel value,
    $Res Function(DashboardDataModel) then,
  ) = _$DashboardDataModelCopyWithImpl<$Res, DashboardDataModel>;
  @useResult
  $Res call({
    int laporanPelanggaran,
    DashboardInfoModel dashboard,
    CheckInOutModel checkInOut,
  });

  $DashboardInfoModelCopyWith<$Res> get dashboard;
  $CheckInOutModelCopyWith<$Res> get checkInOut;
}

/// @nodoc
class _$DashboardDataModelCopyWithImpl<$Res, $Val extends DashboardDataModel>
    implements $DashboardDataModelCopyWith<$Res> {
  _$DashboardDataModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardDataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? laporanPelanggaran = null,
    Object? dashboard = null,
    Object? checkInOut = null,
  }) {
    return _then(
      _value.copyWith(
            laporanPelanggaran: null == laporanPelanggaran
                ? _value.laporanPelanggaran
                : laporanPelanggaran // ignore: cast_nullable_to_non_nullable
                      as int,
            dashboard: null == dashboard
                ? _value.dashboard
                : dashboard // ignore: cast_nullable_to_non_nullable
                      as DashboardInfoModel,
            checkInOut: null == checkInOut
                ? _value.checkInOut
                : checkInOut // ignore: cast_nullable_to_non_nullable
                      as CheckInOutModel,
          )
          as $Val,
    );
  }

  /// Create a copy of DashboardDataModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DashboardInfoModelCopyWith<$Res> get dashboard {
    return $DashboardInfoModelCopyWith<$Res>(_value.dashboard, (value) {
      return _then(_value.copyWith(dashboard: value) as $Val);
    });
  }

  /// Create a copy of DashboardDataModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CheckInOutModelCopyWith<$Res> get checkInOut {
    return $CheckInOutModelCopyWith<$Res>(_value.checkInOut, (value) {
      return _then(_value.copyWith(checkInOut: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DashboardDataModelImplCopyWith<$Res>
    implements $DashboardDataModelCopyWith<$Res> {
  factory _$$DashboardDataModelImplCopyWith(
    _$DashboardDataModelImpl value,
    $Res Function(_$DashboardDataModelImpl) then,
  ) = __$$DashboardDataModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int laporanPelanggaran,
    DashboardInfoModel dashboard,
    CheckInOutModel checkInOut,
  });

  @override
  $DashboardInfoModelCopyWith<$Res> get dashboard;
  @override
  $CheckInOutModelCopyWith<$Res> get checkInOut;
}

/// @nodoc
class __$$DashboardDataModelImplCopyWithImpl<$Res>
    extends _$DashboardDataModelCopyWithImpl<$Res, _$DashboardDataModelImpl>
    implements _$$DashboardDataModelImplCopyWith<$Res> {
  __$$DashboardDataModelImplCopyWithImpl(
    _$DashboardDataModelImpl _value,
    $Res Function(_$DashboardDataModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DashboardDataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? laporanPelanggaran = null,
    Object? dashboard = null,
    Object? checkInOut = null,
  }) {
    return _then(
      _$DashboardDataModelImpl(
        laporanPelanggaran: null == laporanPelanggaran
            ? _value.laporanPelanggaran
            : laporanPelanggaran // ignore: cast_nullable_to_non_nullable
                  as int,
        dashboard: null == dashboard
            ? _value.dashboard
            : dashboard // ignore: cast_nullable_to_non_nullable
                  as DashboardInfoModel,
        checkInOut: null == checkInOut
            ? _value.checkInOut
            : checkInOut // ignore: cast_nullable_to_non_nullable
                  as CheckInOutModel,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardDataModelImpl implements _DashboardDataModel {
  const _$DashboardDataModelImpl({
    this.laporanPelanggaran = 0,
    this.dashboard = const DashboardInfoModel(),
    this.checkInOut = const CheckInOutModel(),
  });

  factory _$DashboardDataModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardDataModelImplFromJson(json);

  @override
  @JsonKey()
  final int laporanPelanggaran;
  @override
  @JsonKey()
  final DashboardInfoModel dashboard;
  @override
  @JsonKey()
  final CheckInOutModel checkInOut;

  @override
  String toString() {
    return 'DashboardDataModel(laporanPelanggaran: $laporanPelanggaran, dashboard: $dashboard, checkInOut: $checkInOut)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardDataModelImpl &&
            (identical(other.laporanPelanggaran, laporanPelanggaran) ||
                other.laporanPelanggaran == laporanPelanggaran) &&
            (identical(other.dashboard, dashboard) ||
                other.dashboard == dashboard) &&
            (identical(other.checkInOut, checkInOut) ||
                other.checkInOut == checkInOut));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, laporanPelanggaran, dashboard, checkInOut);

  /// Create a copy of DashboardDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardDataModelImplCopyWith<_$DashboardDataModelImpl> get copyWith =>
      __$$DashboardDataModelImplCopyWithImpl<_$DashboardDataModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardDataModelImplToJson(this);
  }
}

abstract class _DashboardDataModel implements DashboardDataModel {
  const factory _DashboardDataModel({
    final int laporanPelanggaran,
    final DashboardInfoModel dashboard,
    final CheckInOutModel checkInOut,
  }) = _$DashboardDataModelImpl;

  factory _DashboardDataModel.fromJson(Map<String, dynamic> json) =
      _$DashboardDataModelImpl.fromJson;

  @override
  int get laporanPelanggaran;
  @override
  DashboardInfoModel get dashboard;
  @override
  CheckInOutModel get checkInOut;

  /// Create a copy of DashboardDataModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardDataModelImplCopyWith<_$DashboardDataModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DashboardInfoModel _$DashboardInfoModelFromJson(Map<String, dynamic> json) {
  return _DashboardInfoModel.fromJson(json);
}

/// @nodoc
mixin _$DashboardInfoModel {
  int get jumlahMotorHariIni => throw _privateConstructorUsedError;
  int get jumlahMobilHariIni => throw _privateConstructorUsedError;
  int get totalNominalHariIni => throw _privateConstructorUsedError;
  int get totalNominalBersihUntukWajibPajak =>
      throw _privateConstructorUsedError;
  int get totalNominalBersihUntukBapenda => throw _privateConstructorUsedError;

  /// Serializes this DashboardInfoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DashboardInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardInfoModelCopyWith<DashboardInfoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardInfoModelCopyWith<$Res> {
  factory $DashboardInfoModelCopyWith(
    DashboardInfoModel value,
    $Res Function(DashboardInfoModel) then,
  ) = _$DashboardInfoModelCopyWithImpl<$Res, DashboardInfoModel>;
  @useResult
  $Res call({
    int jumlahMotorHariIni,
    int jumlahMobilHariIni,
    int totalNominalHariIni,
    int totalNominalBersihUntukWajibPajak,
    int totalNominalBersihUntukBapenda,
  });
}

/// @nodoc
class _$DashboardInfoModelCopyWithImpl<$Res, $Val extends DashboardInfoModel>
    implements $DashboardInfoModelCopyWith<$Res> {
  _$DashboardInfoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? jumlahMotorHariIni = null,
    Object? jumlahMobilHariIni = null,
    Object? totalNominalHariIni = null,
    Object? totalNominalBersihUntukWajibPajak = null,
    Object? totalNominalBersihUntukBapenda = null,
  }) {
    return _then(
      _value.copyWith(
            jumlahMotorHariIni: null == jumlahMotorHariIni
                ? _value.jumlahMotorHariIni
                : jumlahMotorHariIni // ignore: cast_nullable_to_non_nullable
                      as int,
            jumlahMobilHariIni: null == jumlahMobilHariIni
                ? _value.jumlahMobilHariIni
                : jumlahMobilHariIni // ignore: cast_nullable_to_non_nullable
                      as int,
            totalNominalHariIni: null == totalNominalHariIni
                ? _value.totalNominalHariIni
                : totalNominalHariIni // ignore: cast_nullable_to_non_nullable
                      as int,
            totalNominalBersihUntukWajibPajak:
                null == totalNominalBersihUntukWajibPajak
                ? _value.totalNominalBersihUntukWajibPajak
                : totalNominalBersihUntukWajibPajak // ignore: cast_nullable_to_non_nullable
                      as int,
            totalNominalBersihUntukBapenda:
                null == totalNominalBersihUntukBapenda
                ? _value.totalNominalBersihUntukBapenda
                : totalNominalBersihUntukBapenda // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DashboardInfoModelImplCopyWith<$Res>
    implements $DashboardInfoModelCopyWith<$Res> {
  factory _$$DashboardInfoModelImplCopyWith(
    _$DashboardInfoModelImpl value,
    $Res Function(_$DashboardInfoModelImpl) then,
  ) = __$$DashboardInfoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int jumlahMotorHariIni,
    int jumlahMobilHariIni,
    int totalNominalHariIni,
    int totalNominalBersihUntukWajibPajak,
    int totalNominalBersihUntukBapenda,
  });
}

/// @nodoc
class __$$DashboardInfoModelImplCopyWithImpl<$Res>
    extends _$DashboardInfoModelCopyWithImpl<$Res, _$DashboardInfoModelImpl>
    implements _$$DashboardInfoModelImplCopyWith<$Res> {
  __$$DashboardInfoModelImplCopyWithImpl(
    _$DashboardInfoModelImpl _value,
    $Res Function(_$DashboardInfoModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DashboardInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? jumlahMotorHariIni = null,
    Object? jumlahMobilHariIni = null,
    Object? totalNominalHariIni = null,
    Object? totalNominalBersihUntukWajibPajak = null,
    Object? totalNominalBersihUntukBapenda = null,
  }) {
    return _then(
      _$DashboardInfoModelImpl(
        jumlahMotorHariIni: null == jumlahMotorHariIni
            ? _value.jumlahMotorHariIni
            : jumlahMotorHariIni // ignore: cast_nullable_to_non_nullable
                  as int,
        jumlahMobilHariIni: null == jumlahMobilHariIni
            ? _value.jumlahMobilHariIni
            : jumlahMobilHariIni // ignore: cast_nullable_to_non_nullable
                  as int,
        totalNominalHariIni: null == totalNominalHariIni
            ? _value.totalNominalHariIni
            : totalNominalHariIni // ignore: cast_nullable_to_non_nullable
                  as int,
        totalNominalBersihUntukWajibPajak:
            null == totalNominalBersihUntukWajibPajak
            ? _value.totalNominalBersihUntukWajibPajak
            : totalNominalBersihUntukWajibPajak // ignore: cast_nullable_to_non_nullable
                  as int,
        totalNominalBersihUntukBapenda: null == totalNominalBersihUntukBapenda
            ? _value.totalNominalBersihUntukBapenda
            : totalNominalBersihUntukBapenda // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardInfoModelImpl implements _DashboardInfoModel {
  const _$DashboardInfoModelImpl({
    this.jumlahMotorHariIni = 0,
    this.jumlahMobilHariIni = 0,
    this.totalNominalHariIni = 0,
    this.totalNominalBersihUntukWajibPajak = 0,
    this.totalNominalBersihUntukBapenda = 0,
  });

  factory _$DashboardInfoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardInfoModelImplFromJson(json);

  @override
  @JsonKey()
  final int jumlahMotorHariIni;
  @override
  @JsonKey()
  final int jumlahMobilHariIni;
  @override
  @JsonKey()
  final int totalNominalHariIni;
  @override
  @JsonKey()
  final int totalNominalBersihUntukWajibPajak;
  @override
  @JsonKey()
  final int totalNominalBersihUntukBapenda;

  @override
  String toString() {
    return 'DashboardInfoModel(jumlahMotorHariIni: $jumlahMotorHariIni, jumlahMobilHariIni: $jumlahMobilHariIni, totalNominalHariIni: $totalNominalHariIni, totalNominalBersihUntukWajibPajak: $totalNominalBersihUntukWajibPajak, totalNominalBersihUntukBapenda: $totalNominalBersihUntukBapenda)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardInfoModelImpl &&
            (identical(other.jumlahMotorHariIni, jumlahMotorHariIni) ||
                other.jumlahMotorHariIni == jumlahMotorHariIni) &&
            (identical(other.jumlahMobilHariIni, jumlahMobilHariIni) ||
                other.jumlahMobilHariIni == jumlahMobilHariIni) &&
            (identical(other.totalNominalHariIni, totalNominalHariIni) ||
                other.totalNominalHariIni == totalNominalHariIni) &&
            (identical(
                  other.totalNominalBersihUntukWajibPajak,
                  totalNominalBersihUntukWajibPajak,
                ) ||
                other.totalNominalBersihUntukWajibPajak ==
                    totalNominalBersihUntukWajibPajak) &&
            (identical(
                  other.totalNominalBersihUntukBapenda,
                  totalNominalBersihUntukBapenda,
                ) ||
                other.totalNominalBersihUntukBapenda ==
                    totalNominalBersihUntukBapenda));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    jumlahMotorHariIni,
    jumlahMobilHariIni,
    totalNominalHariIni,
    totalNominalBersihUntukWajibPajak,
    totalNominalBersihUntukBapenda,
  );

  /// Create a copy of DashboardInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardInfoModelImplCopyWith<_$DashboardInfoModelImpl> get copyWith =>
      __$$DashboardInfoModelImplCopyWithImpl<_$DashboardInfoModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardInfoModelImplToJson(this);
  }
}

abstract class _DashboardInfoModel implements DashboardInfoModel {
  const factory _DashboardInfoModel({
    final int jumlahMotorHariIni,
    final int jumlahMobilHariIni,
    final int totalNominalHariIni,
    final int totalNominalBersihUntukWajibPajak,
    final int totalNominalBersihUntukBapenda,
  }) = _$DashboardInfoModelImpl;

  factory _DashboardInfoModel.fromJson(Map<String, dynamic> json) =
      _$DashboardInfoModelImpl.fromJson;

  @override
  int get jumlahMotorHariIni;
  @override
  int get jumlahMobilHariIni;
  @override
  int get totalNominalHariIni;
  @override
  int get totalNominalBersihUntukWajibPajak;
  @override
  int get totalNominalBersihUntukBapenda;

  /// Create a copy of DashboardInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardInfoModelImplCopyWith<_$DashboardInfoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CheckInOutModel _$CheckInOutModelFromJson(Map<String, dynamic> json) {
  return _CheckInOutModel.fromJson(json);
}

/// @nodoc
mixin _$CheckInOutModel {
  int get idEvent => throw _privateConstructorUsedError;
  String get op => throw _privateConstructorUsedError;
  String get nip => throw _privateConstructorUsedError;
  String get tglRoster => throw _privateConstructorUsedError;
  String get jadwalMasuk => throw _privateConstructorUsedError;
  String get jadwalOut => throw _privateConstructorUsedError;
  int get status => throw _privateConstructorUsedError;
  String get checkIn => throw _privateConstructorUsedError;
  String get checkInString => throw _privateConstructorUsedError;
  int get checkInJmlMobil => throw _privateConstructorUsedError;
  int get checkInJmlMotor => throw _privateConstructorUsedError;
  String get checkOut => throw _privateConstructorUsedError;
  String get checkOutString => throw _privateConstructorUsedError;
  int get checkOutJmlMobil => throw _privateConstructorUsedError;
  int get checkOutJmlMotor => throw _privateConstructorUsedError;
  String get latitude => throw _privateConstructorUsedError;
  String get longitude => throw _privateConstructorUsedError;
  List<DetailAlatModel> get detailAlatCheckIn =>
      throw _privateConstructorUsedError;
  List<DetailAlatModel> get detailAlatCheckOut =>
      throw _privateConstructorUsedError;

  /// Serializes this CheckInOutModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CheckInOutModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CheckInOutModelCopyWith<CheckInOutModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckInOutModelCopyWith<$Res> {
  factory $CheckInOutModelCopyWith(
    CheckInOutModel value,
    $Res Function(CheckInOutModel) then,
  ) = _$CheckInOutModelCopyWithImpl<$Res, CheckInOutModel>;
  @useResult
  $Res call({
    int idEvent,
    String op,
    String nip,
    String tglRoster,
    String jadwalMasuk,
    String jadwalOut,
    int status,
    String checkIn,
    String checkInString,
    int checkInJmlMobil,
    int checkInJmlMotor,
    String checkOut,
    String checkOutString,
    int checkOutJmlMobil,
    int checkOutJmlMotor,
    String latitude,
    String longitude,
    List<DetailAlatModel> detailAlatCheckIn,
    List<DetailAlatModel> detailAlatCheckOut,
  });
}

/// @nodoc
class _$CheckInOutModelCopyWithImpl<$Res, $Val extends CheckInOutModel>
    implements $CheckInOutModelCopyWith<$Res> {
  _$CheckInOutModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CheckInOutModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idEvent = null,
    Object? op = null,
    Object? nip = null,
    Object? tglRoster = null,
    Object? jadwalMasuk = null,
    Object? jadwalOut = null,
    Object? status = null,
    Object? checkIn = null,
    Object? checkInString = null,
    Object? checkInJmlMobil = null,
    Object? checkInJmlMotor = null,
    Object? checkOut = null,
    Object? checkOutString = null,
    Object? checkOutJmlMobil = null,
    Object? checkOutJmlMotor = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? detailAlatCheckIn = null,
    Object? detailAlatCheckOut = null,
  }) {
    return _then(
      _value.copyWith(
            idEvent: null == idEvent
                ? _value.idEvent
                : idEvent // ignore: cast_nullable_to_non_nullable
                      as int,
            op: null == op
                ? _value.op
                : op // ignore: cast_nullable_to_non_nullable
                      as String,
            nip: null == nip
                ? _value.nip
                : nip // ignore: cast_nullable_to_non_nullable
                      as String,
            tglRoster: null == tglRoster
                ? _value.tglRoster
                : tglRoster // ignore: cast_nullable_to_non_nullable
                      as String,
            jadwalMasuk: null == jadwalMasuk
                ? _value.jadwalMasuk
                : jadwalMasuk // ignore: cast_nullable_to_non_nullable
                      as String,
            jadwalOut: null == jadwalOut
                ? _value.jadwalOut
                : jadwalOut // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as int,
            checkIn: null == checkIn
                ? _value.checkIn
                : checkIn // ignore: cast_nullable_to_non_nullable
                      as String,
            checkInString: null == checkInString
                ? _value.checkInString
                : checkInString // ignore: cast_nullable_to_non_nullable
                      as String,
            checkInJmlMobil: null == checkInJmlMobil
                ? _value.checkInJmlMobil
                : checkInJmlMobil // ignore: cast_nullable_to_non_nullable
                      as int,
            checkInJmlMotor: null == checkInJmlMotor
                ? _value.checkInJmlMotor
                : checkInJmlMotor // ignore: cast_nullable_to_non_nullable
                      as int,
            checkOut: null == checkOut
                ? _value.checkOut
                : checkOut // ignore: cast_nullable_to_non_nullable
                      as String,
            checkOutString: null == checkOutString
                ? _value.checkOutString
                : checkOutString // ignore: cast_nullable_to_non_nullable
                      as String,
            checkOutJmlMobil: null == checkOutJmlMobil
                ? _value.checkOutJmlMobil
                : checkOutJmlMobil // ignore: cast_nullable_to_non_nullable
                      as int,
            checkOutJmlMotor: null == checkOutJmlMotor
                ? _value.checkOutJmlMotor
                : checkOutJmlMotor // ignore: cast_nullable_to_non_nullable
                      as int,
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as String,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as String,
            detailAlatCheckIn: null == detailAlatCheckIn
                ? _value.detailAlatCheckIn
                : detailAlatCheckIn // ignore: cast_nullable_to_non_nullable
                      as List<DetailAlatModel>,
            detailAlatCheckOut: null == detailAlatCheckOut
                ? _value.detailAlatCheckOut
                : detailAlatCheckOut // ignore: cast_nullable_to_non_nullable
                      as List<DetailAlatModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CheckInOutModelImplCopyWith<$Res>
    implements $CheckInOutModelCopyWith<$Res> {
  factory _$$CheckInOutModelImplCopyWith(
    _$CheckInOutModelImpl value,
    $Res Function(_$CheckInOutModelImpl) then,
  ) = __$$CheckInOutModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int idEvent,
    String op,
    String nip,
    String tglRoster,
    String jadwalMasuk,
    String jadwalOut,
    int status,
    String checkIn,
    String checkInString,
    int checkInJmlMobil,
    int checkInJmlMotor,
    String checkOut,
    String checkOutString,
    int checkOutJmlMobil,
    int checkOutJmlMotor,
    String latitude,
    String longitude,
    List<DetailAlatModel> detailAlatCheckIn,
    List<DetailAlatModel> detailAlatCheckOut,
  });
}

/// @nodoc
class __$$CheckInOutModelImplCopyWithImpl<$Res>
    extends _$CheckInOutModelCopyWithImpl<$Res, _$CheckInOutModelImpl>
    implements _$$CheckInOutModelImplCopyWith<$Res> {
  __$$CheckInOutModelImplCopyWithImpl(
    _$CheckInOutModelImpl _value,
    $Res Function(_$CheckInOutModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CheckInOutModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idEvent = null,
    Object? op = null,
    Object? nip = null,
    Object? tglRoster = null,
    Object? jadwalMasuk = null,
    Object? jadwalOut = null,
    Object? status = null,
    Object? checkIn = null,
    Object? checkInString = null,
    Object? checkInJmlMobil = null,
    Object? checkInJmlMotor = null,
    Object? checkOut = null,
    Object? checkOutString = null,
    Object? checkOutJmlMobil = null,
    Object? checkOutJmlMotor = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? detailAlatCheckIn = null,
    Object? detailAlatCheckOut = null,
  }) {
    return _then(
      _$CheckInOutModelImpl(
        idEvent: null == idEvent
            ? _value.idEvent
            : idEvent // ignore: cast_nullable_to_non_nullable
                  as int,
        op: null == op
            ? _value.op
            : op // ignore: cast_nullable_to_non_nullable
                  as String,
        nip: null == nip
            ? _value.nip
            : nip // ignore: cast_nullable_to_non_nullable
                  as String,
        tglRoster: null == tglRoster
            ? _value.tglRoster
            : tglRoster // ignore: cast_nullable_to_non_nullable
                  as String,
        jadwalMasuk: null == jadwalMasuk
            ? _value.jadwalMasuk
            : jadwalMasuk // ignore: cast_nullable_to_non_nullable
                  as String,
        jadwalOut: null == jadwalOut
            ? _value.jadwalOut
            : jadwalOut // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as int,
        checkIn: null == checkIn
            ? _value.checkIn
            : checkIn // ignore: cast_nullable_to_non_nullable
                  as String,
        checkInString: null == checkInString
            ? _value.checkInString
            : checkInString // ignore: cast_nullable_to_non_nullable
                  as String,
        checkInJmlMobil: null == checkInJmlMobil
            ? _value.checkInJmlMobil
            : checkInJmlMobil // ignore: cast_nullable_to_non_nullable
                  as int,
        checkInJmlMotor: null == checkInJmlMotor
            ? _value.checkInJmlMotor
            : checkInJmlMotor // ignore: cast_nullable_to_non_nullable
                  as int,
        checkOut: null == checkOut
            ? _value.checkOut
            : checkOut // ignore: cast_nullable_to_non_nullable
                  as String,
        checkOutString: null == checkOutString
            ? _value.checkOutString
            : checkOutString // ignore: cast_nullable_to_non_nullable
                  as String,
        checkOutJmlMobil: null == checkOutJmlMobil
            ? _value.checkOutJmlMobil
            : checkOutJmlMobil // ignore: cast_nullable_to_non_nullable
                  as int,
        checkOutJmlMotor: null == checkOutJmlMotor
            ? _value.checkOutJmlMotor
            : checkOutJmlMotor // ignore: cast_nullable_to_non_nullable
                  as int,
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as String,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as String,
        detailAlatCheckIn: null == detailAlatCheckIn
            ? _value._detailAlatCheckIn
            : detailAlatCheckIn // ignore: cast_nullable_to_non_nullable
                  as List<DetailAlatModel>,
        detailAlatCheckOut: null == detailAlatCheckOut
            ? _value._detailAlatCheckOut
            : detailAlatCheckOut // ignore: cast_nullable_to_non_nullable
                  as List<DetailAlatModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CheckInOutModelImpl implements _CheckInOutModel {
  const _$CheckInOutModelImpl({
    this.idEvent = 0,
    this.op = '',
    this.nip = '',
    this.tglRoster = '',
    this.jadwalMasuk = '',
    this.jadwalOut = '',
    this.status = 0,
    this.checkIn = '',
    this.checkInString = '',
    this.checkInJmlMobil = 0,
    this.checkInJmlMotor = 0,
    this.checkOut = '',
    this.checkOutString = '',
    this.checkOutJmlMobil = 0,
    this.checkOutJmlMotor = 0,
    this.latitude = '',
    this.longitude = '',
    final List<DetailAlatModel> detailAlatCheckIn = const [],
    final List<DetailAlatModel> detailAlatCheckOut = const [],
  }) : _detailAlatCheckIn = detailAlatCheckIn,
       _detailAlatCheckOut = detailAlatCheckOut;

  factory _$CheckInOutModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CheckInOutModelImplFromJson(json);

  @override
  @JsonKey()
  final int idEvent;
  @override
  @JsonKey()
  final String op;
  @override
  @JsonKey()
  final String nip;
  @override
  @JsonKey()
  final String tglRoster;
  @override
  @JsonKey()
  final String jadwalMasuk;
  @override
  @JsonKey()
  final String jadwalOut;
  @override
  @JsonKey()
  final int status;
  @override
  @JsonKey()
  final String checkIn;
  @override
  @JsonKey()
  final String checkInString;
  @override
  @JsonKey()
  final int checkInJmlMobil;
  @override
  @JsonKey()
  final int checkInJmlMotor;
  @override
  @JsonKey()
  final String checkOut;
  @override
  @JsonKey()
  final String checkOutString;
  @override
  @JsonKey()
  final int checkOutJmlMobil;
  @override
  @JsonKey()
  final int checkOutJmlMotor;
  @override
  @JsonKey()
  final String latitude;
  @override
  @JsonKey()
  final String longitude;
  final List<DetailAlatModel> _detailAlatCheckIn;
  @override
  @JsonKey()
  List<DetailAlatModel> get detailAlatCheckIn {
    if (_detailAlatCheckIn is EqualUnmodifiableListView)
      return _detailAlatCheckIn;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_detailAlatCheckIn);
  }

  final List<DetailAlatModel> _detailAlatCheckOut;
  @override
  @JsonKey()
  List<DetailAlatModel> get detailAlatCheckOut {
    if (_detailAlatCheckOut is EqualUnmodifiableListView)
      return _detailAlatCheckOut;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_detailAlatCheckOut);
  }

  @override
  String toString() {
    return 'CheckInOutModel(idEvent: $idEvent, op: $op, nip: $nip, tglRoster: $tglRoster, jadwalMasuk: $jadwalMasuk, jadwalOut: $jadwalOut, status: $status, checkIn: $checkIn, checkInString: $checkInString, checkInJmlMobil: $checkInJmlMobil, checkInJmlMotor: $checkInJmlMotor, checkOut: $checkOut, checkOutString: $checkOutString, checkOutJmlMobil: $checkOutJmlMobil, checkOutJmlMotor: $checkOutJmlMotor, latitude: $latitude, longitude: $longitude, detailAlatCheckIn: $detailAlatCheckIn, detailAlatCheckOut: $detailAlatCheckOut)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckInOutModelImpl &&
            (identical(other.idEvent, idEvent) || other.idEvent == idEvent) &&
            (identical(other.op, op) || other.op == op) &&
            (identical(other.nip, nip) || other.nip == nip) &&
            (identical(other.tglRoster, tglRoster) ||
                other.tglRoster == tglRoster) &&
            (identical(other.jadwalMasuk, jadwalMasuk) ||
                other.jadwalMasuk == jadwalMasuk) &&
            (identical(other.jadwalOut, jadwalOut) ||
                other.jadwalOut == jadwalOut) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.checkIn, checkIn) || other.checkIn == checkIn) &&
            (identical(other.checkInString, checkInString) ||
                other.checkInString == checkInString) &&
            (identical(other.checkInJmlMobil, checkInJmlMobil) ||
                other.checkInJmlMobil == checkInJmlMobil) &&
            (identical(other.checkInJmlMotor, checkInJmlMotor) ||
                other.checkInJmlMotor == checkInJmlMotor) &&
            (identical(other.checkOut, checkOut) ||
                other.checkOut == checkOut) &&
            (identical(other.checkOutString, checkOutString) ||
                other.checkOutString == checkOutString) &&
            (identical(other.checkOutJmlMobil, checkOutJmlMobil) ||
                other.checkOutJmlMobil == checkOutJmlMobil) &&
            (identical(other.checkOutJmlMotor, checkOutJmlMotor) ||
                other.checkOutJmlMotor == checkOutJmlMotor) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            const DeepCollectionEquality().equals(
              other._detailAlatCheckIn,
              _detailAlatCheckIn,
            ) &&
            const DeepCollectionEquality().equals(
              other._detailAlatCheckOut,
              _detailAlatCheckOut,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    idEvent,
    op,
    nip,
    tglRoster,
    jadwalMasuk,
    jadwalOut,
    status,
    checkIn,
    checkInString,
    checkInJmlMobil,
    checkInJmlMotor,
    checkOut,
    checkOutString,
    checkOutJmlMobil,
    checkOutJmlMotor,
    latitude,
    longitude,
    const DeepCollectionEquality().hash(_detailAlatCheckIn),
    const DeepCollectionEquality().hash(_detailAlatCheckOut),
  ]);

  /// Create a copy of CheckInOutModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckInOutModelImplCopyWith<_$CheckInOutModelImpl> get copyWith =>
      __$$CheckInOutModelImplCopyWithImpl<_$CheckInOutModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CheckInOutModelImplToJson(this);
  }
}

abstract class _CheckInOutModel implements CheckInOutModel {
  const factory _CheckInOutModel({
    final int idEvent,
    final String op,
    final String nip,
    final String tglRoster,
    final String jadwalMasuk,
    final String jadwalOut,
    final int status,
    final String checkIn,
    final String checkInString,
    final int checkInJmlMobil,
    final int checkInJmlMotor,
    final String checkOut,
    final String checkOutString,
    final int checkOutJmlMobil,
    final int checkOutJmlMotor,
    final String latitude,
    final String longitude,
    final List<DetailAlatModel> detailAlatCheckIn,
    final List<DetailAlatModel> detailAlatCheckOut,
  }) = _$CheckInOutModelImpl;

  factory _CheckInOutModel.fromJson(Map<String, dynamic> json) =
      _$CheckInOutModelImpl.fromJson;

  @override
  int get idEvent;
  @override
  String get op;
  @override
  String get nip;
  @override
  String get tglRoster;
  @override
  String get jadwalMasuk;
  @override
  String get jadwalOut;
  @override
  int get status;
  @override
  String get checkIn;
  @override
  String get checkInString;
  @override
  int get checkInJmlMobil;
  @override
  int get checkInJmlMotor;
  @override
  String get checkOut;
  @override
  String get checkOutString;
  @override
  int get checkOutJmlMobil;
  @override
  int get checkOutJmlMotor;
  @override
  String get latitude;
  @override
  String get longitude;
  @override
  List<DetailAlatModel> get detailAlatCheckIn;
  @override
  List<DetailAlatModel> get detailAlatCheckOut;

  /// Create a copy of CheckInOutModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckInOutModelImplCopyWith<_$CheckInOutModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DetailAlatModel _$DetailAlatModelFromJson(Map<String, dynamic> json) {
  return _DetailAlatModel.fromJson(json);
}

/// @nodoc
mixin _$DetailAlatModel {
  int get alatId => throw _privateConstructorUsedError;
  String get nama => throw _privateConstructorUsedError;
  bool get isBawa => throw _privateConstructorUsedError;

  /// Serializes this DetailAlatModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DetailAlatModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DetailAlatModelCopyWith<DetailAlatModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DetailAlatModelCopyWith<$Res> {
  factory $DetailAlatModelCopyWith(
    DetailAlatModel value,
    $Res Function(DetailAlatModel) then,
  ) = _$DetailAlatModelCopyWithImpl<$Res, DetailAlatModel>;
  @useResult
  $Res call({int alatId, String nama, bool isBawa});
}

/// @nodoc
class _$DetailAlatModelCopyWithImpl<$Res, $Val extends DetailAlatModel>
    implements $DetailAlatModelCopyWith<$Res> {
  _$DetailAlatModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DetailAlatModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? alatId = null,
    Object? nama = null,
    Object? isBawa = null,
  }) {
    return _then(
      _value.copyWith(
            alatId: null == alatId
                ? _value.alatId
                : alatId // ignore: cast_nullable_to_non_nullable
                      as int,
            nama: null == nama
                ? _value.nama
                : nama // ignore: cast_nullable_to_non_nullable
                      as String,
            isBawa: null == isBawa
                ? _value.isBawa
                : isBawa // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DetailAlatModelImplCopyWith<$Res>
    implements $DetailAlatModelCopyWith<$Res> {
  factory _$$DetailAlatModelImplCopyWith(
    _$DetailAlatModelImpl value,
    $Res Function(_$DetailAlatModelImpl) then,
  ) = __$$DetailAlatModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int alatId, String nama, bool isBawa});
}

/// @nodoc
class __$$DetailAlatModelImplCopyWithImpl<$Res>
    extends _$DetailAlatModelCopyWithImpl<$Res, _$DetailAlatModelImpl>
    implements _$$DetailAlatModelImplCopyWith<$Res> {
  __$$DetailAlatModelImplCopyWithImpl(
    _$DetailAlatModelImpl _value,
    $Res Function(_$DetailAlatModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DetailAlatModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? alatId = null,
    Object? nama = null,
    Object? isBawa = null,
  }) {
    return _then(
      _$DetailAlatModelImpl(
        alatId: null == alatId
            ? _value.alatId
            : alatId // ignore: cast_nullable_to_non_nullable
                  as int,
        nama: null == nama
            ? _value.nama
            : nama // ignore: cast_nullable_to_non_nullable
                  as String,
        isBawa: null == isBawa
            ? _value.isBawa
            : isBawa // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DetailAlatModelImpl implements _DetailAlatModel {
  const _$DetailAlatModelImpl({
    this.alatId = 0,
    this.nama = '',
    this.isBawa = true,
  });

  factory _$DetailAlatModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DetailAlatModelImplFromJson(json);

  @override
  @JsonKey()
  final int alatId;
  @override
  @JsonKey()
  final String nama;
  @override
  @JsonKey()
  final bool isBawa;

  @override
  String toString() {
    return 'DetailAlatModel(alatId: $alatId, nama: $nama, isBawa: $isBawa)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DetailAlatModelImpl &&
            (identical(other.alatId, alatId) || other.alatId == alatId) &&
            (identical(other.nama, nama) || other.nama == nama) &&
            (identical(other.isBawa, isBawa) || other.isBawa == isBawa));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, alatId, nama, isBawa);

  /// Create a copy of DetailAlatModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DetailAlatModelImplCopyWith<_$DetailAlatModelImpl> get copyWith =>
      __$$DetailAlatModelImplCopyWithImpl<_$DetailAlatModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DetailAlatModelImplToJson(this);
  }
}

abstract class _DetailAlatModel implements DetailAlatModel {
  const factory _DetailAlatModel({
    final int alatId,
    final String nama,
    final bool isBawa,
  }) = _$DetailAlatModelImpl;

  factory _DetailAlatModel.fromJson(Map<String, dynamic> json) =
      _$DetailAlatModelImpl.fromJson;

  @override
  int get alatId;
  @override
  String get nama;
  @override
  bool get isBawa;

  /// Create a copy of DetailAlatModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DetailAlatModelImplCopyWith<_$DetailAlatModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
