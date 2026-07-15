// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pengawasan_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PengawasanState {
  // 🚀 2. TAMBAHKAN PROPERTI STATUS
  PengawasanStatus get status => throw _privateConstructorUsedError;
  AppPermissionType? get deniedPermissionType =>
      throw _privateConstructorUsedError;
  RequestLaporanPengawasanEntity get request =>
      throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isLoadingLaporan => throw _privateConstructorUsedError;
  bool get isSuccess => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  File? get rawPhoto => throw _privateConstructorUsedError;
  DateTime? get photoTakenAt => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  String? get placeName => throw _privateConstructorUsedError;
  String? get locationError => throw _privateConstructorUsedError;
  bool get isFetchingLocation => throw _privateConstructorUsedError;
  bool get isCapturing => throw _privateConstructorUsedError;
  String get keteranganText => throw _privateConstructorUsedError;
  List<JenisPelanggaranEntity> get jenisPelanggaran =>
      throw _privateConstructorUsedError;
  List<LaporanPengawasanEntity> get laporan =>
      throw _privateConstructorUsedError;
  List<LaporanPengawasanEntity> get laporanFake =>
      throw _privateConstructorUsedError;

  /// Create a copy of PengawasanState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PengawasanStateCopyWith<PengawasanState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PengawasanStateCopyWith<$Res> {
  factory $PengawasanStateCopyWith(
    PengawasanState value,
    $Res Function(PengawasanState) then,
  ) = _$PengawasanStateCopyWithImpl<$Res, PengawasanState>;
  @useResult
  $Res call({
    PengawasanStatus status,
    AppPermissionType? deniedPermissionType,
    RequestLaporanPengawasanEntity request,
    bool isLoading,
    bool isLoadingLaporan,
    bool isSuccess,
    String? errorMessage,
    File? rawPhoto,
    DateTime? photoTakenAt,
    double? latitude,
    double? longitude,
    String? placeName,
    String? locationError,
    bool isFetchingLocation,
    bool isCapturing,
    String keteranganText,
    List<JenisPelanggaranEntity> jenisPelanggaran,
    List<LaporanPengawasanEntity> laporan,
    List<LaporanPengawasanEntity> laporanFake,
  });

  $RequestLaporanPengawasanEntityCopyWith<$Res> get request;
}

/// @nodoc
class _$PengawasanStateCopyWithImpl<$Res, $Val extends PengawasanState>
    implements $PengawasanStateCopyWith<$Res> {
  _$PengawasanStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PengawasanState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? deniedPermissionType = freezed,
    Object? request = null,
    Object? isLoading = null,
    Object? isLoadingLaporan = null,
    Object? isSuccess = null,
    Object? errorMessage = freezed,
    Object? rawPhoto = freezed,
    Object? photoTakenAt = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? placeName = freezed,
    Object? locationError = freezed,
    Object? isFetchingLocation = null,
    Object? isCapturing = null,
    Object? keteranganText = null,
    Object? jenisPelanggaran = null,
    Object? laporan = null,
    Object? laporanFake = null,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as PengawasanStatus,
            deniedPermissionType: freezed == deniedPermissionType
                ? _value.deniedPermissionType
                : deniedPermissionType // ignore: cast_nullable_to_non_nullable
                      as AppPermissionType?,
            request: null == request
                ? _value.request
                : request // ignore: cast_nullable_to_non_nullable
                      as RequestLaporanPengawasanEntity,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            isLoadingLaporan: null == isLoadingLaporan
                ? _value.isLoadingLaporan
                : isLoadingLaporan // ignore: cast_nullable_to_non_nullable
                      as bool,
            isSuccess: null == isSuccess
                ? _value.isSuccess
                : isSuccess // ignore: cast_nullable_to_non_nullable
                      as bool,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            rawPhoto: freezed == rawPhoto
                ? _value.rawPhoto
                : rawPhoto // ignore: cast_nullable_to_non_nullable
                      as File?,
            photoTakenAt: freezed == photoTakenAt
                ? _value.photoTakenAt
                : photoTakenAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            latitude: freezed == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            longitude: freezed == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            placeName: freezed == placeName
                ? _value.placeName
                : placeName // ignore: cast_nullable_to_non_nullable
                      as String?,
            locationError: freezed == locationError
                ? _value.locationError
                : locationError // ignore: cast_nullable_to_non_nullable
                      as String?,
            isFetchingLocation: null == isFetchingLocation
                ? _value.isFetchingLocation
                : isFetchingLocation // ignore: cast_nullable_to_non_nullable
                      as bool,
            isCapturing: null == isCapturing
                ? _value.isCapturing
                : isCapturing // ignore: cast_nullable_to_non_nullable
                      as bool,
            keteranganText: null == keteranganText
                ? _value.keteranganText
                : keteranganText // ignore: cast_nullable_to_non_nullable
                      as String,
            jenisPelanggaran: null == jenisPelanggaran
                ? _value.jenisPelanggaran
                : jenisPelanggaran // ignore: cast_nullable_to_non_nullable
                      as List<JenisPelanggaranEntity>,
            laporan: null == laporan
                ? _value.laporan
                : laporan // ignore: cast_nullable_to_non_nullable
                      as List<LaporanPengawasanEntity>,
            laporanFake: null == laporanFake
                ? _value.laporanFake
                : laporanFake // ignore: cast_nullable_to_non_nullable
                      as List<LaporanPengawasanEntity>,
          )
          as $Val,
    );
  }

  /// Create a copy of PengawasanState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RequestLaporanPengawasanEntityCopyWith<$Res> get request {
    return $RequestLaporanPengawasanEntityCopyWith<$Res>(_value.request, (
      value,
    ) {
      return _then(_value.copyWith(request: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PengawasanStateImplCopyWith<$Res>
    implements $PengawasanStateCopyWith<$Res> {
  factory _$$PengawasanStateImplCopyWith(
    _$PengawasanStateImpl value,
    $Res Function(_$PengawasanStateImpl) then,
  ) = __$$PengawasanStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    PengawasanStatus status,
    AppPermissionType? deniedPermissionType,
    RequestLaporanPengawasanEntity request,
    bool isLoading,
    bool isLoadingLaporan,
    bool isSuccess,
    String? errorMessage,
    File? rawPhoto,
    DateTime? photoTakenAt,
    double? latitude,
    double? longitude,
    String? placeName,
    String? locationError,
    bool isFetchingLocation,
    bool isCapturing,
    String keteranganText,
    List<JenisPelanggaranEntity> jenisPelanggaran,
    List<LaporanPengawasanEntity> laporan,
    List<LaporanPengawasanEntity> laporanFake,
  });

  @override
  $RequestLaporanPengawasanEntityCopyWith<$Res> get request;
}

/// @nodoc
class __$$PengawasanStateImplCopyWithImpl<$Res>
    extends _$PengawasanStateCopyWithImpl<$Res, _$PengawasanStateImpl>
    implements _$$PengawasanStateImplCopyWith<$Res> {
  __$$PengawasanStateImplCopyWithImpl(
    _$PengawasanStateImpl _value,
    $Res Function(_$PengawasanStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PengawasanState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? deniedPermissionType = freezed,
    Object? request = null,
    Object? isLoading = null,
    Object? isLoadingLaporan = null,
    Object? isSuccess = null,
    Object? errorMessage = freezed,
    Object? rawPhoto = freezed,
    Object? photoTakenAt = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? placeName = freezed,
    Object? locationError = freezed,
    Object? isFetchingLocation = null,
    Object? isCapturing = null,
    Object? keteranganText = null,
    Object? jenisPelanggaran = null,
    Object? laporan = null,
    Object? laporanFake = null,
  }) {
    return _then(
      _$PengawasanStateImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as PengawasanStatus,
        deniedPermissionType: freezed == deniedPermissionType
            ? _value.deniedPermissionType
            : deniedPermissionType // ignore: cast_nullable_to_non_nullable
                  as AppPermissionType?,
        request: null == request
            ? _value.request
            : request // ignore: cast_nullable_to_non_nullable
                  as RequestLaporanPengawasanEntity,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        isLoadingLaporan: null == isLoadingLaporan
            ? _value.isLoadingLaporan
            : isLoadingLaporan // ignore: cast_nullable_to_non_nullable
                  as bool,
        isSuccess: null == isSuccess
            ? _value.isSuccess
            : isSuccess // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        rawPhoto: freezed == rawPhoto
            ? _value.rawPhoto
            : rawPhoto // ignore: cast_nullable_to_non_nullable
                  as File?,
        photoTakenAt: freezed == photoTakenAt
            ? _value.photoTakenAt
            : photoTakenAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        latitude: freezed == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        longitude: freezed == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        placeName: freezed == placeName
            ? _value.placeName
            : placeName // ignore: cast_nullable_to_non_nullable
                  as String?,
        locationError: freezed == locationError
            ? _value.locationError
            : locationError // ignore: cast_nullable_to_non_nullable
                  as String?,
        isFetchingLocation: null == isFetchingLocation
            ? _value.isFetchingLocation
            : isFetchingLocation // ignore: cast_nullable_to_non_nullable
                  as bool,
        isCapturing: null == isCapturing
            ? _value.isCapturing
            : isCapturing // ignore: cast_nullable_to_non_nullable
                  as bool,
        keteranganText: null == keteranganText
            ? _value.keteranganText
            : keteranganText // ignore: cast_nullable_to_non_nullable
                  as String,
        jenisPelanggaran: null == jenisPelanggaran
            ? _value._jenisPelanggaran
            : jenisPelanggaran // ignore: cast_nullable_to_non_nullable
                  as List<JenisPelanggaranEntity>,
        laporan: null == laporan
            ? _value._laporan
            : laporan // ignore: cast_nullable_to_non_nullable
                  as List<LaporanPengawasanEntity>,
        laporanFake: null == laporanFake
            ? _value._laporanFake
            : laporanFake // ignore: cast_nullable_to_non_nullable
                  as List<LaporanPengawasanEntity>,
      ),
    );
  }
}

/// @nodoc

class _$PengawasanStateImpl extends _PengawasanState {
  const _$PengawasanStateImpl({
    this.status = PengawasanStatus.initial,
    this.deniedPermissionType,
    this.request = const RequestLaporanPengawasanEntity(),
    this.isLoading = false,
    this.isLoadingLaporan = false,
    this.isSuccess = false,
    this.errorMessage,
    this.rawPhoto,
    this.photoTakenAt,
    this.latitude,
    this.longitude,
    this.placeName,
    this.locationError,
    this.isFetchingLocation = false,
    this.isCapturing = false,
    this.keteranganText = '',
    final List<JenisPelanggaranEntity> jenisPelanggaran = const [],
    final List<LaporanPengawasanEntity> laporan =
        const <LaporanPengawasanEntity>[],
    final List<LaporanPengawasanEntity> laporanFake =
        const <LaporanPengawasanEntity>[],
  }) : _jenisPelanggaran = jenisPelanggaran,
       _laporan = laporan,
       _laporanFake = laporanFake,
       super._();

  // 🚀 2. TAMBAHKAN PROPERTI STATUS
  @override
  @JsonKey()
  final PengawasanStatus status;
  @override
  final AppPermissionType? deniedPermissionType;
  @override
  @JsonKey()
  final RequestLaporanPengawasanEntity request;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isLoadingLaporan;
  @override
  @JsonKey()
  final bool isSuccess;
  @override
  final String? errorMessage;
  @override
  final File? rawPhoto;
  @override
  final DateTime? photoTakenAt;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final String? placeName;
  @override
  final String? locationError;
  @override
  @JsonKey()
  final bool isFetchingLocation;
  @override
  @JsonKey()
  final bool isCapturing;
  @override
  @JsonKey()
  final String keteranganText;
  final List<JenisPelanggaranEntity> _jenisPelanggaran;
  @override
  @JsonKey()
  List<JenisPelanggaranEntity> get jenisPelanggaran {
    if (_jenisPelanggaran is EqualUnmodifiableListView)
      return _jenisPelanggaran;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_jenisPelanggaran);
  }

  final List<LaporanPengawasanEntity> _laporan;
  @override
  @JsonKey()
  List<LaporanPengawasanEntity> get laporan {
    if (_laporan is EqualUnmodifiableListView) return _laporan;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_laporan);
  }

  final List<LaporanPengawasanEntity> _laporanFake;
  @override
  @JsonKey()
  List<LaporanPengawasanEntity> get laporanFake {
    if (_laporanFake is EqualUnmodifiableListView) return _laporanFake;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_laporanFake);
  }

  @override
  String toString() {
    return 'PengawasanState(status: $status, deniedPermissionType: $deniedPermissionType, request: $request, isLoading: $isLoading, isLoadingLaporan: $isLoadingLaporan, isSuccess: $isSuccess, errorMessage: $errorMessage, rawPhoto: $rawPhoto, photoTakenAt: $photoTakenAt, latitude: $latitude, longitude: $longitude, placeName: $placeName, locationError: $locationError, isFetchingLocation: $isFetchingLocation, isCapturing: $isCapturing, keteranganText: $keteranganText, jenisPelanggaran: $jenisPelanggaran, laporan: $laporan, laporanFake: $laporanFake)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PengawasanStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(
              other.deniedPermissionType,
              deniedPermissionType,
            ) &&
            (identical(other.request, request) || other.request == request) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isLoadingLaporan, isLoadingLaporan) ||
                other.isLoadingLaporan == isLoadingLaporan) &&
            (identical(other.isSuccess, isSuccess) ||
                other.isSuccess == isSuccess) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.rawPhoto, rawPhoto) ||
                other.rawPhoto == rawPhoto) &&
            (identical(other.photoTakenAt, photoTakenAt) ||
                other.photoTakenAt == photoTakenAt) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.placeName, placeName) ||
                other.placeName == placeName) &&
            (identical(other.locationError, locationError) ||
                other.locationError == locationError) &&
            (identical(other.isFetchingLocation, isFetchingLocation) ||
                other.isFetchingLocation == isFetchingLocation) &&
            (identical(other.isCapturing, isCapturing) ||
                other.isCapturing == isCapturing) &&
            (identical(other.keteranganText, keteranganText) ||
                other.keteranganText == keteranganText) &&
            const DeepCollectionEquality().equals(
              other._jenisPelanggaran,
              _jenisPelanggaran,
            ) &&
            const DeepCollectionEquality().equals(other._laporan, _laporan) &&
            const DeepCollectionEquality().equals(
              other._laporanFake,
              _laporanFake,
            ));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    status,
    const DeepCollectionEquality().hash(deniedPermissionType),
    request,
    isLoading,
    isLoadingLaporan,
    isSuccess,
    errorMessage,
    rawPhoto,
    photoTakenAt,
    latitude,
    longitude,
    placeName,
    locationError,
    isFetchingLocation,
    isCapturing,
    keteranganText,
    const DeepCollectionEquality().hash(_jenisPelanggaran),
    const DeepCollectionEquality().hash(_laporan),
    const DeepCollectionEquality().hash(_laporanFake),
  ]);

  /// Create a copy of PengawasanState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PengawasanStateImplCopyWith<_$PengawasanStateImpl> get copyWith =>
      __$$PengawasanStateImplCopyWithImpl<_$PengawasanStateImpl>(
        this,
        _$identity,
      );
}

abstract class _PengawasanState extends PengawasanState {
  const factory _PengawasanState({
    final PengawasanStatus status,
    final AppPermissionType? deniedPermissionType,
    final RequestLaporanPengawasanEntity request,
    final bool isLoading,
    final bool isLoadingLaporan,
    final bool isSuccess,
    final String? errorMessage,
    final File? rawPhoto,
    final DateTime? photoTakenAt,
    final double? latitude,
    final double? longitude,
    final String? placeName,
    final String? locationError,
    final bool isFetchingLocation,
    final bool isCapturing,
    final String keteranganText,
    final List<JenisPelanggaranEntity> jenisPelanggaran,
    final List<LaporanPengawasanEntity> laporan,
    final List<LaporanPengawasanEntity> laporanFake,
  }) = _$PengawasanStateImpl;
  const _PengawasanState._() : super._();

  // 🚀 2. TAMBAHKAN PROPERTI STATUS
  @override
  PengawasanStatus get status;
  @override
  AppPermissionType? get deniedPermissionType;
  @override
  RequestLaporanPengawasanEntity get request;
  @override
  bool get isLoading;
  @override
  bool get isLoadingLaporan;
  @override
  bool get isSuccess;
  @override
  String? get errorMessage;
  @override
  File? get rawPhoto;
  @override
  DateTime? get photoTakenAt;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  String? get placeName;
  @override
  String? get locationError;
  @override
  bool get isFetchingLocation;
  @override
  bool get isCapturing;
  @override
  String get keteranganText;
  @override
  List<JenisPelanggaranEntity> get jenisPelanggaran;
  @override
  List<LaporanPengawasanEntity> get laporan;
  @override
  List<LaporanPengawasanEntity> get laporanFake;

  /// Create a copy of PengawasanState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PengawasanStateImplCopyWith<_$PengawasanStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
