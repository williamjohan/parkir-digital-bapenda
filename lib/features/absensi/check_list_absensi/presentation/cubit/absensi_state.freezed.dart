// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'absensi_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AbsensiState {
  AbsensiStatus get status => throw _privateConstructorUsedError;
  String get errorMessage => throw _privateConstructorUsedError;
  AppPermissionType? get deniedPermissionType =>
      throw _privateConstructorUsedError;
  JenisPengawasan? get jenis => throw _privateConstructorUsedError;
  String? get nop => throw _privateConstructorUsedError; // 🆕
  ShiftPengawasan? get shift =>
      throw _privateConstructorUsedError; // --- STATE UNTUK UI FORM ---
  File? get rawPhoto =>
      throw _privateConstructorUsedError; // Foto asli sebelum di-watermark
  File? get watermarkedPhoto =>
      throw _privateConstructorUsedError; // Foto hasil watermark, siap dikirim
  DateTime? get photoTakenAt => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  String? get placeName => throw _privateConstructorUsedError;
  String? get locationError => throw _privateConstructorUsedError;
  bool get isFetchingLocation => throw _privateConstructorUsedError;
  bool get isCapturing =>
      throw _privateConstructorUsedError; // --- INPUT FORM ---
  String get motorText => throw _privateConstructorUsedError;
  String get mobilText => throw _privateConstructorUsedError;
  List<AlatDigitalEntity> get allInstruments =>
      throw _privateConstructorUsedError;
  List<int> get selectedInstrumentIds => throw _privateConstructorUsedError;
  bool get isLoadingInstruments => throw _privateConstructorUsedError;

  /// Create a copy of AbsensiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AbsensiStateCopyWith<AbsensiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AbsensiStateCopyWith<$Res> {
  factory $AbsensiStateCopyWith(
    AbsensiState value,
    $Res Function(AbsensiState) then,
  ) = _$AbsensiStateCopyWithImpl<$Res, AbsensiState>;
  @useResult
  $Res call({
    AbsensiStatus status,
    String errorMessage,
    AppPermissionType? deniedPermissionType,
    JenisPengawasan? jenis,
    String? nop,
    ShiftPengawasan? shift,
    File? rawPhoto,
    File? watermarkedPhoto,
    DateTime? photoTakenAt,
    double? latitude,
    double? longitude,
    String? placeName,
    String? locationError,
    bool isFetchingLocation,
    bool isCapturing,
    String motorText,
    String mobilText,
    List<AlatDigitalEntity> allInstruments,
    List<int> selectedInstrumentIds,
    bool isLoadingInstruments,
  });
}

/// @nodoc
class _$AbsensiStateCopyWithImpl<$Res, $Val extends AbsensiState>
    implements $AbsensiStateCopyWith<$Res> {
  _$AbsensiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AbsensiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? errorMessage = null,
    Object? deniedPermissionType = freezed,
    Object? jenis = freezed,
    Object? nop = freezed,
    Object? shift = freezed,
    Object? rawPhoto = freezed,
    Object? watermarkedPhoto = freezed,
    Object? photoTakenAt = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? placeName = freezed,
    Object? locationError = freezed,
    Object? isFetchingLocation = null,
    Object? isCapturing = null,
    Object? motorText = null,
    Object? mobilText = null,
    Object? allInstruments = null,
    Object? selectedInstrumentIds = null,
    Object? isLoadingInstruments = null,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as AbsensiStatus,
            errorMessage: null == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String,
            deniedPermissionType: freezed == deniedPermissionType
                ? _value.deniedPermissionType
                : deniedPermissionType // ignore: cast_nullable_to_non_nullable
                      as AppPermissionType?,
            jenis: freezed == jenis
                ? _value.jenis
                : jenis // ignore: cast_nullable_to_non_nullable
                      as JenisPengawasan?,
            nop: freezed == nop
                ? _value.nop
                : nop // ignore: cast_nullable_to_non_nullable
                      as String?,
            shift: freezed == shift
                ? _value.shift
                : shift // ignore: cast_nullable_to_non_nullable
                      as ShiftPengawasan?,
            rawPhoto: freezed == rawPhoto
                ? _value.rawPhoto
                : rawPhoto // ignore: cast_nullable_to_non_nullable
                      as File?,
            watermarkedPhoto: freezed == watermarkedPhoto
                ? _value.watermarkedPhoto
                : watermarkedPhoto // ignore: cast_nullable_to_non_nullable
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
            motorText: null == motorText
                ? _value.motorText
                : motorText // ignore: cast_nullable_to_non_nullable
                      as String,
            mobilText: null == mobilText
                ? _value.mobilText
                : mobilText // ignore: cast_nullable_to_non_nullable
                      as String,
            allInstruments: null == allInstruments
                ? _value.allInstruments
                : allInstruments // ignore: cast_nullable_to_non_nullable
                      as List<AlatDigitalEntity>,
            selectedInstrumentIds: null == selectedInstrumentIds
                ? _value.selectedInstrumentIds
                : selectedInstrumentIds // ignore: cast_nullable_to_non_nullable
                      as List<int>,
            isLoadingInstruments: null == isLoadingInstruments
                ? _value.isLoadingInstruments
                : isLoadingInstruments // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AbsensiStateImplCopyWith<$Res>
    implements $AbsensiStateCopyWith<$Res> {
  factory _$$AbsensiStateImplCopyWith(
    _$AbsensiStateImpl value,
    $Res Function(_$AbsensiStateImpl) then,
  ) = __$$AbsensiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    AbsensiStatus status,
    String errorMessage,
    AppPermissionType? deniedPermissionType,
    JenisPengawasan? jenis,
    String? nop,
    ShiftPengawasan? shift,
    File? rawPhoto,
    File? watermarkedPhoto,
    DateTime? photoTakenAt,
    double? latitude,
    double? longitude,
    String? placeName,
    String? locationError,
    bool isFetchingLocation,
    bool isCapturing,
    String motorText,
    String mobilText,
    List<AlatDigitalEntity> allInstruments,
    List<int> selectedInstrumentIds,
    bool isLoadingInstruments,
  });
}

/// @nodoc
class __$$AbsensiStateImplCopyWithImpl<$Res>
    extends _$AbsensiStateCopyWithImpl<$Res, _$AbsensiStateImpl>
    implements _$$AbsensiStateImplCopyWith<$Res> {
  __$$AbsensiStateImplCopyWithImpl(
    _$AbsensiStateImpl _value,
    $Res Function(_$AbsensiStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AbsensiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? errorMessage = null,
    Object? deniedPermissionType = freezed,
    Object? jenis = freezed,
    Object? nop = freezed,
    Object? shift = freezed,
    Object? rawPhoto = freezed,
    Object? watermarkedPhoto = freezed,
    Object? photoTakenAt = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? placeName = freezed,
    Object? locationError = freezed,
    Object? isFetchingLocation = null,
    Object? isCapturing = null,
    Object? motorText = null,
    Object? mobilText = null,
    Object? allInstruments = null,
    Object? selectedInstrumentIds = null,
    Object? isLoadingInstruments = null,
  }) {
    return _then(
      _$AbsensiStateImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as AbsensiStatus,
        errorMessage: null == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String,
        deniedPermissionType: freezed == deniedPermissionType
            ? _value.deniedPermissionType
            : deniedPermissionType // ignore: cast_nullable_to_non_nullable
                  as AppPermissionType?,
        jenis: freezed == jenis
            ? _value.jenis
            : jenis // ignore: cast_nullable_to_non_nullable
                  as JenisPengawasan?,
        nop: freezed == nop
            ? _value.nop
            : nop // ignore: cast_nullable_to_non_nullable
                  as String?,
        shift: freezed == shift
            ? _value.shift
            : shift // ignore: cast_nullable_to_non_nullable
                  as ShiftPengawasan?,
        rawPhoto: freezed == rawPhoto
            ? _value.rawPhoto
            : rawPhoto // ignore: cast_nullable_to_non_nullable
                  as File?,
        watermarkedPhoto: freezed == watermarkedPhoto
            ? _value.watermarkedPhoto
            : watermarkedPhoto // ignore: cast_nullable_to_non_nullable
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
        motorText: null == motorText
            ? _value.motorText
            : motorText // ignore: cast_nullable_to_non_nullable
                  as String,
        mobilText: null == mobilText
            ? _value.mobilText
            : mobilText // ignore: cast_nullable_to_non_nullable
                  as String,
        allInstruments: null == allInstruments
            ? _value._allInstruments
            : allInstruments // ignore: cast_nullable_to_non_nullable
                  as List<AlatDigitalEntity>,
        selectedInstrumentIds: null == selectedInstrumentIds
            ? _value._selectedInstrumentIds
            : selectedInstrumentIds // ignore: cast_nullable_to_non_nullable
                  as List<int>,
        isLoadingInstruments: null == isLoadingInstruments
            ? _value.isLoadingInstruments
            : isLoadingInstruments // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$AbsensiStateImpl extends _AbsensiState {
  const _$AbsensiStateImpl({
    this.status = AbsensiStatus.initial,
    this.errorMessage = '',
    this.deniedPermissionType,
    this.jenis,
    this.nop,
    this.shift,
    this.rawPhoto,
    this.watermarkedPhoto,
    this.photoTakenAt,
    this.latitude,
    this.longitude,
    this.placeName,
    this.locationError,
    this.isFetchingLocation = false,
    this.isCapturing = false,
    this.motorText = '',
    this.mobilText = '',
    final List<AlatDigitalEntity> allInstruments = const [],
    final List<int> selectedInstrumentIds = const [],
    this.isLoadingInstruments = false,
  }) : _allInstruments = allInstruments,
       _selectedInstrumentIds = selectedInstrumentIds,
       super._();

  @override
  @JsonKey()
  final AbsensiStatus status;
  @override
  @JsonKey()
  final String errorMessage;
  @override
  final AppPermissionType? deniedPermissionType;
  @override
  final JenisPengawasan? jenis;
  @override
  final String? nop;
  // 🆕
  @override
  final ShiftPengawasan? shift;
  // --- STATE UNTUK UI FORM ---
  @override
  final File? rawPhoto;
  // Foto asli sebelum di-watermark
  @override
  final File? watermarkedPhoto;
  // Foto hasil watermark, siap dikirim
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
  // --- INPUT FORM ---
  @override
  @JsonKey()
  final String motorText;
  @override
  @JsonKey()
  final String mobilText;
  final List<AlatDigitalEntity> _allInstruments;
  @override
  @JsonKey()
  List<AlatDigitalEntity> get allInstruments {
    if (_allInstruments is EqualUnmodifiableListView) return _allInstruments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allInstruments);
  }

  final List<int> _selectedInstrumentIds;
  @override
  @JsonKey()
  List<int> get selectedInstrumentIds {
    if (_selectedInstrumentIds is EqualUnmodifiableListView)
      return _selectedInstrumentIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedInstrumentIds);
  }

  @override
  @JsonKey()
  final bool isLoadingInstruments;

  @override
  String toString() {
    return 'AbsensiState(status: $status, errorMessage: $errorMessage, deniedPermissionType: $deniedPermissionType, jenis: $jenis, nop: $nop, shift: $shift, rawPhoto: $rawPhoto, watermarkedPhoto: $watermarkedPhoto, photoTakenAt: $photoTakenAt, latitude: $latitude, longitude: $longitude, placeName: $placeName, locationError: $locationError, isFetchingLocation: $isFetchingLocation, isCapturing: $isCapturing, motorText: $motorText, mobilText: $mobilText, allInstruments: $allInstruments, selectedInstrumentIds: $selectedInstrumentIds, isLoadingInstruments: $isLoadingInstruments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AbsensiStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.deniedPermissionType, deniedPermissionType) ||
                other.deniedPermissionType == deniedPermissionType) &&
            (identical(other.jenis, jenis) || other.jenis == jenis) &&
            (identical(other.nop, nop) || other.nop == nop) &&
            (identical(other.shift, shift) || other.shift == shift) &&
            (identical(other.rawPhoto, rawPhoto) ||
                other.rawPhoto == rawPhoto) &&
            (identical(other.watermarkedPhoto, watermarkedPhoto) ||
                other.watermarkedPhoto == watermarkedPhoto) &&
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
            (identical(other.motorText, motorText) ||
                other.motorText == motorText) &&
            (identical(other.mobilText, mobilText) ||
                other.mobilText == mobilText) &&
            const DeepCollectionEquality().equals(
              other._allInstruments,
              _allInstruments,
            ) &&
            const DeepCollectionEquality().equals(
              other._selectedInstrumentIds,
              _selectedInstrumentIds,
            ) &&
            (identical(other.isLoadingInstruments, isLoadingInstruments) ||
                other.isLoadingInstruments == isLoadingInstruments));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    status,
    errorMessage,
    deniedPermissionType,
    jenis,
    nop,
    shift,
    rawPhoto,
    watermarkedPhoto,
    photoTakenAt,
    latitude,
    longitude,
    placeName,
    locationError,
    isFetchingLocation,
    isCapturing,
    motorText,
    mobilText,
    const DeepCollectionEquality().hash(_allInstruments),
    const DeepCollectionEquality().hash(_selectedInstrumentIds),
    isLoadingInstruments,
  ]);

  /// Create a copy of AbsensiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AbsensiStateImplCopyWith<_$AbsensiStateImpl> get copyWith =>
      __$$AbsensiStateImplCopyWithImpl<_$AbsensiStateImpl>(this, _$identity);
}

abstract class _AbsensiState extends AbsensiState {
  const factory _AbsensiState({
    final AbsensiStatus status,
    final String errorMessage,
    final AppPermissionType? deniedPermissionType,
    final JenisPengawasan? jenis,
    final String? nop,
    final ShiftPengawasan? shift,
    final File? rawPhoto,
    final File? watermarkedPhoto,
    final DateTime? photoTakenAt,
    final double? latitude,
    final double? longitude,
    final String? placeName,
    final String? locationError,
    final bool isFetchingLocation,
    final bool isCapturing,
    final String motorText,
    final String mobilText,
    final List<AlatDigitalEntity> allInstruments,
    final List<int> selectedInstrumentIds,
    final bool isLoadingInstruments,
  }) = _$AbsensiStateImpl;
  const _AbsensiState._() : super._();

  @override
  AbsensiStatus get status;
  @override
  String get errorMessage;
  @override
  AppPermissionType? get deniedPermissionType;
  @override
  JenisPengawasan? get jenis;
  @override
  String? get nop; // 🆕
  @override
  ShiftPengawasan? get shift; // --- STATE UNTUK UI FORM ---
  @override
  File? get rawPhoto; // Foto asli sebelum di-watermark
  @override
  File? get watermarkedPhoto; // Foto hasil watermark, siap dikirim
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
  bool get isCapturing; // --- INPUT FORM ---
  @override
  String get motorText;
  @override
  String get mobilText;
  @override
  List<AlatDigitalEntity> get allInstruments;
  @override
  List<int> get selectedInstrumentIds;
  @override
  bool get isLoadingInstruments;

  /// Create a copy of AbsensiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AbsensiStateImplCopyWith<_$AbsensiStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
