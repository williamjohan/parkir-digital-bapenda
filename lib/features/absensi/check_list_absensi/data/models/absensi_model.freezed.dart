// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'absensi_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AbsensiRequestModel _$AbsensiRequestModelFromJson(Map<String, dynamic> json) {
  return _AbsensiRequestModel.fromJson(json);
}

/// @nodoc
mixin _$AbsensiRequestModel {
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  int get totalMotor => throw _privateConstructorUsedError;
  int get totalMobil => throw _privateConstructorUsedError;
  List<int> get detailAlatIds => throw _privateConstructorUsedError;
  String get fotoPath =>
      throw _privateConstructorUsedError; // Ini adalah properti, bukan prefix
  bool get isCheckIn => throw _privateConstructorUsedError;

  /// Serializes this AbsensiRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AbsensiRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AbsensiRequestModelCopyWith<AbsensiRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AbsensiRequestModelCopyWith<$Res> {
  factory $AbsensiRequestModelCopyWith(
    AbsensiRequestModel value,
    $Res Function(AbsensiRequestModel) then,
  ) = _$AbsensiRequestModelCopyWithImpl<$Res, AbsensiRequestModel>;
  @useResult
  $Res call({
    double latitude,
    double longitude,
    int totalMotor,
    int totalMobil,
    List<int> detailAlatIds,
    String fotoPath,
    bool isCheckIn,
  });
}

/// @nodoc
class _$AbsensiRequestModelCopyWithImpl<$Res, $Val extends AbsensiRequestModel>
    implements $AbsensiRequestModelCopyWith<$Res> {
  _$AbsensiRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AbsensiRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? totalMotor = null,
    Object? totalMobil = null,
    Object? detailAlatIds = null,
    Object? fotoPath = null,
    Object? isCheckIn = null,
  }) {
    return _then(
      _value.copyWith(
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            totalMotor: null == totalMotor
                ? _value.totalMotor
                : totalMotor // ignore: cast_nullable_to_non_nullable
                      as int,
            totalMobil: null == totalMobil
                ? _value.totalMobil
                : totalMobil // ignore: cast_nullable_to_non_nullable
                      as int,
            detailAlatIds: null == detailAlatIds
                ? _value.detailAlatIds
                : detailAlatIds // ignore: cast_nullable_to_non_nullable
                      as List<int>,
            fotoPath: null == fotoPath
                ? _value.fotoPath
                : fotoPath // ignore: cast_nullable_to_non_nullable
                      as String,
            isCheckIn: null == isCheckIn
                ? _value.isCheckIn
                : isCheckIn // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AbsensiRequestModelImplCopyWith<$Res>
    implements $AbsensiRequestModelCopyWith<$Res> {
  factory _$$AbsensiRequestModelImplCopyWith(
    _$AbsensiRequestModelImpl value,
    $Res Function(_$AbsensiRequestModelImpl) then,
  ) = __$$AbsensiRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double latitude,
    double longitude,
    int totalMotor,
    int totalMobil,
    List<int> detailAlatIds,
    String fotoPath,
    bool isCheckIn,
  });
}

/// @nodoc
class __$$AbsensiRequestModelImplCopyWithImpl<$Res>
    extends _$AbsensiRequestModelCopyWithImpl<$Res, _$AbsensiRequestModelImpl>
    implements _$$AbsensiRequestModelImplCopyWith<$Res> {
  __$$AbsensiRequestModelImplCopyWithImpl(
    _$AbsensiRequestModelImpl _value,
    $Res Function(_$AbsensiRequestModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AbsensiRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? totalMotor = null,
    Object? totalMobil = null,
    Object? detailAlatIds = null,
    Object? fotoPath = null,
    Object? isCheckIn = null,
  }) {
    return _then(
      _$AbsensiRequestModelImpl(
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        totalMotor: null == totalMotor
            ? _value.totalMotor
            : totalMotor // ignore: cast_nullable_to_non_nullable
                  as int,
        totalMobil: null == totalMobil
            ? _value.totalMobil
            : totalMobil // ignore: cast_nullable_to_non_nullable
                  as int,
        detailAlatIds: null == detailAlatIds
            ? _value._detailAlatIds
            : detailAlatIds // ignore: cast_nullable_to_non_nullable
                  as List<int>,
        fotoPath: null == fotoPath
            ? _value.fotoPath
            : fotoPath // ignore: cast_nullable_to_non_nullable
                  as String,
        isCheckIn: null == isCheckIn
            ? _value.isCheckIn
            : isCheckIn // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AbsensiRequestModelImpl implements _AbsensiRequestModel {
  const _$AbsensiRequestModelImpl({
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.totalMotor = 0,
    this.totalMobil = 0,
    final List<int> detailAlatIds = const [],
    this.fotoPath = '',
    this.isCheckIn = true,
  }) : _detailAlatIds = detailAlatIds;

  factory _$AbsensiRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AbsensiRequestModelImplFromJson(json);

  @override
  @JsonKey()
  final double latitude;
  @override
  @JsonKey()
  final double longitude;
  @override
  @JsonKey()
  final int totalMotor;
  @override
  @JsonKey()
  final int totalMobil;
  final List<int> _detailAlatIds;
  @override
  @JsonKey()
  List<int> get detailAlatIds {
    if (_detailAlatIds is EqualUnmodifiableListView) return _detailAlatIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_detailAlatIds);
  }

  @override
  @JsonKey()
  final String fotoPath;
  // Ini adalah properti, bukan prefix
  @override
  @JsonKey()
  final bool isCheckIn;

  @override
  String toString() {
    return 'AbsensiRequestModel(latitude: $latitude, longitude: $longitude, totalMotor: $totalMotor, totalMobil: $totalMobil, detailAlatIds: $detailAlatIds, fotoPath: $fotoPath, isCheckIn: $isCheckIn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AbsensiRequestModelImpl &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.totalMotor, totalMotor) ||
                other.totalMotor == totalMotor) &&
            (identical(other.totalMobil, totalMobil) ||
                other.totalMobil == totalMobil) &&
            const DeepCollectionEquality().equals(
              other._detailAlatIds,
              _detailAlatIds,
            ) &&
            (identical(other.fotoPath, fotoPath) ||
                other.fotoPath == fotoPath) &&
            (identical(other.isCheckIn, isCheckIn) ||
                other.isCheckIn == isCheckIn));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    latitude,
    longitude,
    totalMotor,
    totalMobil,
    const DeepCollectionEquality().hash(_detailAlatIds),
    fotoPath,
    isCheckIn,
  );

  /// Create a copy of AbsensiRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AbsensiRequestModelImplCopyWith<_$AbsensiRequestModelImpl> get copyWith =>
      __$$AbsensiRequestModelImplCopyWithImpl<_$AbsensiRequestModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AbsensiRequestModelImplToJson(this);
  }
}

abstract class _AbsensiRequestModel implements AbsensiRequestModel {
  const factory _AbsensiRequestModel({
    final double latitude,
    final double longitude,
    final int totalMotor,
    final int totalMobil,
    final List<int> detailAlatIds,
    final String fotoPath,
    final bool isCheckIn,
  }) = _$AbsensiRequestModelImpl;

  factory _AbsensiRequestModel.fromJson(Map<String, dynamic> json) =
      _$AbsensiRequestModelImpl.fromJson;

  @override
  double get latitude;
  @override
  double get longitude;
  @override
  int get totalMotor;
  @override
  int get totalMobil;
  @override
  List<int> get detailAlatIds;
  @override
  String get fotoPath; // Ini adalah properti, bukan prefix
  @override
  bool get isCheckIn;

  /// Create a copy of AbsensiRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AbsensiRequestModelImplCopyWith<_$AbsensiRequestModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
