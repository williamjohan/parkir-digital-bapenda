// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$HomeState {
  HomeStatus get status => throw _privateConstructorUsedError;
  CameraPermissionStatus? get permissionActionStatus =>
      throw _privateConstructorUsedError;
  String? get selectedVehicleForCapture => throw _privateConstructorUsedError;
  int? get actionTimestamp => throw _privateConstructorUsedError;
  int get motorCount => throw _privateConstructorUsedError;
  int get mobilCount => throw _privateConstructorUsedError;
  double get totalPendapatan => throw _privateConstructorUsedError;
  double get totalPajak => throw _privateConstructorUsedError;
  double get totalBersih => throw _privateConstructorUsedError;
  int? get selectedModePlat => throw _privateConstructorUsedError;
  List<HistoryItemModel> get recentTransactions =>
      throw _privateConstructorUsedError;
  List<WeeklyChartItemModel> get weeklyChartData =>
      throw _privateConstructorUsedError;
  bool get isFree => throw _privateConstructorUsedError;
  String get nop => throw _privateConstructorUsedError;
  String get namaLokasi => throw _privateConstructorUsedError;
  String get namaJukir => throw _privateConstructorUsedError;
  String get namaOp =>
      throw _privateConstructorUsedError; // 🚀 PENGGANTI isJukir: Single Source of Truth untuk Role
  RoleLoginDigitalParkir get role => throw _privateConstructorUsedError;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HomeStateCopyWith<HomeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeStateCopyWith<$Res> {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) then) =
      _$HomeStateCopyWithImpl<$Res, HomeState>;
  @useResult
  $Res call({
    HomeStatus status,
    CameraPermissionStatus? permissionActionStatus,
    String? selectedVehicleForCapture,
    int? actionTimestamp,
    int motorCount,
    int mobilCount,
    double totalPendapatan,
    double totalPajak,
    double totalBersih,
    int? selectedModePlat,
    List<HistoryItemModel> recentTransactions,
    List<WeeklyChartItemModel> weeklyChartData,
    bool isFree,
    String nop,
    String namaLokasi,
    String namaJukir,
    String namaOp,
    RoleLoginDigitalParkir role,
  });
}

/// @nodoc
class _$HomeStateCopyWithImpl<$Res, $Val extends HomeState>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? permissionActionStatus = freezed,
    Object? selectedVehicleForCapture = freezed,
    Object? actionTimestamp = freezed,
    Object? motorCount = null,
    Object? mobilCount = null,
    Object? totalPendapatan = null,
    Object? totalPajak = null,
    Object? totalBersih = null,
    Object? selectedModePlat = freezed,
    Object? recentTransactions = null,
    Object? weeklyChartData = null,
    Object? isFree = null,
    Object? nop = null,
    Object? namaLokasi = null,
    Object? namaJukir = null,
    Object? namaOp = null,
    Object? role = freezed,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as HomeStatus,
            permissionActionStatus: freezed == permissionActionStatus
                ? _value.permissionActionStatus
                : permissionActionStatus // ignore: cast_nullable_to_non_nullable
                      as CameraPermissionStatus?,
            selectedVehicleForCapture: freezed == selectedVehicleForCapture
                ? _value.selectedVehicleForCapture
                : selectedVehicleForCapture // ignore: cast_nullable_to_non_nullable
                      as String?,
            actionTimestamp: freezed == actionTimestamp
                ? _value.actionTimestamp
                : actionTimestamp // ignore: cast_nullable_to_non_nullable
                      as int?,
            motorCount: null == motorCount
                ? _value.motorCount
                : motorCount // ignore: cast_nullable_to_non_nullable
                      as int,
            mobilCount: null == mobilCount
                ? _value.mobilCount
                : mobilCount // ignore: cast_nullable_to_non_nullable
                      as int,
            totalPendapatan: null == totalPendapatan
                ? _value.totalPendapatan
                : totalPendapatan // ignore: cast_nullable_to_non_nullable
                      as double,
            totalPajak: null == totalPajak
                ? _value.totalPajak
                : totalPajak // ignore: cast_nullable_to_non_nullable
                      as double,
            totalBersih: null == totalBersih
                ? _value.totalBersih
                : totalBersih // ignore: cast_nullable_to_non_nullable
                      as double,
            selectedModePlat: freezed == selectedModePlat
                ? _value.selectedModePlat
                : selectedModePlat // ignore: cast_nullable_to_non_nullable
                      as int?,
            recentTransactions: null == recentTransactions
                ? _value.recentTransactions
                : recentTransactions // ignore: cast_nullable_to_non_nullable
                      as List<HistoryItemModel>,
            weeklyChartData: null == weeklyChartData
                ? _value.weeklyChartData
                : weeklyChartData // ignore: cast_nullable_to_non_nullable
                      as List<WeeklyChartItemModel>,
            isFree: null == isFree
                ? _value.isFree
                : isFree // ignore: cast_nullable_to_non_nullable
                      as bool,
            nop: null == nop
                ? _value.nop
                : nop // ignore: cast_nullable_to_non_nullable
                      as String,
            namaLokasi: null == namaLokasi
                ? _value.namaLokasi
                : namaLokasi // ignore: cast_nullable_to_non_nullable
                      as String,
            namaJukir: null == namaJukir
                ? _value.namaJukir
                : namaJukir // ignore: cast_nullable_to_non_nullable
                      as String,
            namaOp: null == namaOp
                ? _value.namaOp
                : namaOp // ignore: cast_nullable_to_non_nullable
                      as String,
            role: freezed == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as RoleLoginDigitalParkir,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HomeStateImplCopyWith<$Res>
    implements $HomeStateCopyWith<$Res> {
  factory _$$HomeStateImplCopyWith(
    _$HomeStateImpl value,
    $Res Function(_$HomeStateImpl) then,
  ) = __$$HomeStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    HomeStatus status,
    CameraPermissionStatus? permissionActionStatus,
    String? selectedVehicleForCapture,
    int? actionTimestamp,
    int motorCount,
    int mobilCount,
    double totalPendapatan,
    double totalPajak,
    double totalBersih,
    int? selectedModePlat,
    List<HistoryItemModel> recentTransactions,
    List<WeeklyChartItemModel> weeklyChartData,
    bool isFree,
    String nop,
    String namaLokasi,
    String namaJukir,
    String namaOp,
    RoleLoginDigitalParkir role,
  });
}

/// @nodoc
class __$$HomeStateImplCopyWithImpl<$Res>
    extends _$HomeStateCopyWithImpl<$Res, _$HomeStateImpl>
    implements _$$HomeStateImplCopyWith<$Res> {
  __$$HomeStateImplCopyWithImpl(
    _$HomeStateImpl _value,
    $Res Function(_$HomeStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? permissionActionStatus = freezed,
    Object? selectedVehicleForCapture = freezed,
    Object? actionTimestamp = freezed,
    Object? motorCount = null,
    Object? mobilCount = null,
    Object? totalPendapatan = null,
    Object? totalPajak = null,
    Object? totalBersih = null,
    Object? selectedModePlat = freezed,
    Object? recentTransactions = null,
    Object? weeklyChartData = null,
    Object? isFree = null,
    Object? nop = null,
    Object? namaLokasi = null,
    Object? namaJukir = null,
    Object? namaOp = null,
    Object? role = freezed,
  }) {
    return _then(
      _$HomeStateImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as HomeStatus,
        permissionActionStatus: freezed == permissionActionStatus
            ? _value.permissionActionStatus
            : permissionActionStatus // ignore: cast_nullable_to_non_nullable
                  as CameraPermissionStatus?,
        selectedVehicleForCapture: freezed == selectedVehicleForCapture
            ? _value.selectedVehicleForCapture
            : selectedVehicleForCapture // ignore: cast_nullable_to_non_nullable
                  as String?,
        actionTimestamp: freezed == actionTimestamp
            ? _value.actionTimestamp
            : actionTimestamp // ignore: cast_nullable_to_non_nullable
                  as int?,
        motorCount: null == motorCount
            ? _value.motorCount
            : motorCount // ignore: cast_nullable_to_non_nullable
                  as int,
        mobilCount: null == mobilCount
            ? _value.mobilCount
            : mobilCount // ignore: cast_nullable_to_non_nullable
                  as int,
        totalPendapatan: null == totalPendapatan
            ? _value.totalPendapatan
            : totalPendapatan // ignore: cast_nullable_to_non_nullable
                  as double,
        totalPajak: null == totalPajak
            ? _value.totalPajak
            : totalPajak // ignore: cast_nullable_to_non_nullable
                  as double,
        totalBersih: null == totalBersih
            ? _value.totalBersih
            : totalBersih // ignore: cast_nullable_to_non_nullable
                  as double,
        selectedModePlat: freezed == selectedModePlat
            ? _value.selectedModePlat
            : selectedModePlat // ignore: cast_nullable_to_non_nullable
                  as int?,
        recentTransactions: null == recentTransactions
            ? _value._recentTransactions
            : recentTransactions // ignore: cast_nullable_to_non_nullable
                  as List<HistoryItemModel>,
        weeklyChartData: null == weeklyChartData
            ? _value._weeklyChartData
            : weeklyChartData // ignore: cast_nullable_to_non_nullable
                  as List<WeeklyChartItemModel>,
        isFree: null == isFree
            ? _value.isFree
            : isFree // ignore: cast_nullable_to_non_nullable
                  as bool,
        nop: null == nop
            ? _value.nop
            : nop // ignore: cast_nullable_to_non_nullable
                  as String,
        namaLokasi: null == namaLokasi
            ? _value.namaLokasi
            : namaLokasi // ignore: cast_nullable_to_non_nullable
                  as String,
        namaJukir: null == namaJukir
            ? _value.namaJukir
            : namaJukir // ignore: cast_nullable_to_non_nullable
                  as String,
        namaOp: null == namaOp
            ? _value.namaOp
            : namaOp // ignore: cast_nullable_to_non_nullable
                  as String,
        role: freezed == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as RoleLoginDigitalParkir,
      ),
    );
  }
}

/// @nodoc

class _$HomeStateImpl implements _HomeState {
  const _$HomeStateImpl({
    this.status = HomeStatus.initial,
    this.permissionActionStatus,
    this.selectedVehicleForCapture,
    this.actionTimestamp,
    this.motorCount = 0,
    this.mobilCount = 0,
    this.totalPendapatan = 0.0,
    this.totalPajak = 0.0,
    this.totalBersih = 0.0,
    this.selectedModePlat,
    final List<HistoryItemModel> recentTransactions = const [],
    final List<WeeklyChartItemModel> weeklyChartData = const [],
    this.isFree = false,
    this.nop = "",
    this.namaLokasi = "",
    this.namaJukir = "",
    this.namaOp = "",
    this.role = RoleLoginDigitalParkir.tidakDiketahui,
  }) : _recentTransactions = recentTransactions,
       _weeklyChartData = weeklyChartData;

  @override
  @JsonKey()
  final HomeStatus status;
  @override
  final CameraPermissionStatus? permissionActionStatus;
  @override
  final String? selectedVehicleForCapture;
  @override
  final int? actionTimestamp;
  @override
  @JsonKey()
  final int motorCount;
  @override
  @JsonKey()
  final int mobilCount;
  @override
  @JsonKey()
  final double totalPendapatan;
  @override
  @JsonKey()
  final double totalPajak;
  @override
  @JsonKey()
  final double totalBersih;
  @override
  final int? selectedModePlat;
  final List<HistoryItemModel> _recentTransactions;
  @override
  @JsonKey()
  List<HistoryItemModel> get recentTransactions {
    if (_recentTransactions is EqualUnmodifiableListView)
      return _recentTransactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentTransactions);
  }

  final List<WeeklyChartItemModel> _weeklyChartData;
  @override
  @JsonKey()
  List<WeeklyChartItemModel> get weeklyChartData {
    if (_weeklyChartData is EqualUnmodifiableListView) return _weeklyChartData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weeklyChartData);
  }

  @override
  @JsonKey()
  final bool isFree;
  @override
  @JsonKey()
  final String nop;
  @override
  @JsonKey()
  final String namaLokasi;
  @override
  @JsonKey()
  final String namaJukir;
  @override
  @JsonKey()
  final String namaOp;
  // 🚀 PENGGANTI isJukir: Single Source of Truth untuk Role
  @override
  @JsonKey()
  final RoleLoginDigitalParkir role;

  @override
  String toString() {
    return 'HomeState(status: $status, permissionActionStatus: $permissionActionStatus, selectedVehicleForCapture: $selectedVehicleForCapture, actionTimestamp: $actionTimestamp, motorCount: $motorCount, mobilCount: $mobilCount, totalPendapatan: $totalPendapatan, totalPajak: $totalPajak, totalBersih: $totalBersih, selectedModePlat: $selectedModePlat, recentTransactions: $recentTransactions, weeklyChartData: $weeklyChartData, isFree: $isFree, nop: $nop, namaLokasi: $namaLokasi, namaJukir: $namaJukir, namaOp: $namaOp, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.permissionActionStatus, permissionActionStatus) ||
                other.permissionActionStatus == permissionActionStatus) &&
            (identical(
                  other.selectedVehicleForCapture,
                  selectedVehicleForCapture,
                ) ||
                other.selectedVehicleForCapture == selectedVehicleForCapture) &&
            (identical(other.actionTimestamp, actionTimestamp) ||
                other.actionTimestamp == actionTimestamp) &&
            (identical(other.motorCount, motorCount) ||
                other.motorCount == motorCount) &&
            (identical(other.mobilCount, mobilCount) ||
                other.mobilCount == mobilCount) &&
            (identical(other.totalPendapatan, totalPendapatan) ||
                other.totalPendapatan == totalPendapatan) &&
            (identical(other.totalPajak, totalPajak) ||
                other.totalPajak == totalPajak) &&
            (identical(other.totalBersih, totalBersih) ||
                other.totalBersih == totalBersih) &&
            (identical(other.selectedModePlat, selectedModePlat) ||
                other.selectedModePlat == selectedModePlat) &&
            const DeepCollectionEquality().equals(
              other._recentTransactions,
              _recentTransactions,
            ) &&
            const DeepCollectionEquality().equals(
              other._weeklyChartData,
              _weeklyChartData,
            ) &&
            (identical(other.isFree, isFree) || other.isFree == isFree) &&
            (identical(other.nop, nop) || other.nop == nop) &&
            (identical(other.namaLokasi, namaLokasi) ||
                other.namaLokasi == namaLokasi) &&
            (identical(other.namaJukir, namaJukir) ||
                other.namaJukir == namaJukir) &&
            (identical(other.namaOp, namaOp) || other.namaOp == namaOp) &&
            const DeepCollectionEquality().equals(other.role, role));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    permissionActionStatus,
    selectedVehicleForCapture,
    actionTimestamp,
    motorCount,
    mobilCount,
    totalPendapatan,
    totalPajak,
    totalBersih,
    selectedModePlat,
    const DeepCollectionEquality().hash(_recentTransactions),
    const DeepCollectionEquality().hash(_weeklyChartData),
    isFree,
    nop,
    namaLokasi,
    namaJukir,
    namaOp,
    const DeepCollectionEquality().hash(role),
  );

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      __$$HomeStateImplCopyWithImpl<_$HomeStateImpl>(this, _$identity);
}

abstract class _HomeState implements HomeState {
  const factory _HomeState({
    final HomeStatus status,
    final CameraPermissionStatus? permissionActionStatus,
    final String? selectedVehicleForCapture,
    final int? actionTimestamp,
    final int motorCount,
    final int mobilCount,
    final double totalPendapatan,
    final double totalPajak,
    final double totalBersih,
    final int? selectedModePlat,
    final List<HistoryItemModel> recentTransactions,
    final List<WeeklyChartItemModel> weeklyChartData,
    final bool isFree,
    final String nop,
    final String namaLokasi,
    final String namaJukir,
    final String namaOp,
    final RoleLoginDigitalParkir role,
  }) = _$HomeStateImpl;

  @override
  HomeStatus get status;
  @override
  CameraPermissionStatus? get permissionActionStatus;
  @override
  String? get selectedVehicleForCapture;
  @override
  int? get actionTimestamp;
  @override
  int get motorCount;
  @override
  int get mobilCount;
  @override
  double get totalPendapatan;
  @override
  double get totalPajak;
  @override
  double get totalBersih;
  @override
  int? get selectedModePlat;
  @override
  List<HistoryItemModel> get recentTransactions;
  @override
  List<WeeklyChartItemModel> get weeklyChartData;
  @override
  bool get isFree;
  @override
  String get nop;
  @override
  String get namaLokasi;
  @override
  String get namaJukir;
  @override
  String get namaOp; // 🚀 PENGGANTI isJukir: Single Source of Truth untuk Role
  @override
  RoleLoginDigitalParkir get role;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
