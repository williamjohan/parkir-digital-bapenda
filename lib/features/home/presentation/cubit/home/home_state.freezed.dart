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
  String get namaOp => throw _privateConstructorUsedError;
  int get totalOp => throw _privateConstructorUsedError;
  int get totalOpDigital => throw _privateConstructorUsedError;
  int get totalOpNonDigital => throw _privateConstructorUsedError;
  OpCategoryEntity get digital => throw _privateConstructorUsedError;
  int get totalBertarif => throw _privateConstructorUsedError;
  int get totalNonTarif => throw _privateConstructorUsedError;
  int get totalTarifTidakDiketahui => throw _privateConstructorUsedError;
  DetailEntity get detail => throw _privateConstructorUsedError;
  BerbayarEntity get berbayar => throw _privateConstructorUsedError;
  OpCategoryEntity get nonDigital => throw _privateConstructorUsedError;
  double get persentaseDigital => throw _privateConstructorUsedError;
  double get persentaseNonDigital => throw _privateConstructorUsedError;
  List<SofParkirResultEntity> get sofParkirResults =>
      throw _privateConstructorUsedError;
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
    int totalOp,
    int totalOpDigital,
    int totalOpNonDigital,
    OpCategoryEntity digital,
    int totalBertarif,
    int totalNonTarif,
    int totalTarifTidakDiketahui,
    DetailEntity detail,
    BerbayarEntity berbayar,
    OpCategoryEntity nonDigital,
    double persentaseDigital,
    double persentaseNonDigital,
    List<SofParkirResultEntity> sofParkirResults,
    RoleLoginDigitalParkir role,
  });

  $OpCategoryEntityCopyWith<$Res> get digital;
  $DetailEntityCopyWith<$Res> get detail;
  $BerbayarEntityCopyWith<$Res> get berbayar;
  $OpCategoryEntityCopyWith<$Res> get nonDigital;
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
    Object? totalOp = null,
    Object? totalOpDigital = null,
    Object? totalOpNonDigital = null,
    Object? digital = null,
    Object? totalBertarif = null,
    Object? totalNonTarif = null,
    Object? totalTarifTidakDiketahui = null,
    Object? detail = null,
    Object? berbayar = null,
    Object? nonDigital = null,
    Object? persentaseDigital = null,
    Object? persentaseNonDigital = null,
    Object? sofParkirResults = null,
    Object? role = null,
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
            totalOp: null == totalOp
                ? _value.totalOp
                : totalOp // ignore: cast_nullable_to_non_nullable
                      as int,
            totalOpDigital: null == totalOpDigital
                ? _value.totalOpDigital
                : totalOpDigital // ignore: cast_nullable_to_non_nullable
                      as int,
            totalOpNonDigital: null == totalOpNonDigital
                ? _value.totalOpNonDigital
                : totalOpNonDigital // ignore: cast_nullable_to_non_nullable
                      as int,
            digital: null == digital
                ? _value.digital
                : digital // ignore: cast_nullable_to_non_nullable
                      as OpCategoryEntity,
            totalBertarif: null == totalBertarif
                ? _value.totalBertarif
                : totalBertarif // ignore: cast_nullable_to_non_nullable
                      as int,
            totalNonTarif: null == totalNonTarif
                ? _value.totalNonTarif
                : totalNonTarif // ignore: cast_nullable_to_non_nullable
                      as int,
            totalTarifTidakDiketahui: null == totalTarifTidakDiketahui
                ? _value.totalTarifTidakDiketahui
                : totalTarifTidakDiketahui // ignore: cast_nullable_to_non_nullable
                      as int,
            detail: null == detail
                ? _value.detail
                : detail // ignore: cast_nullable_to_non_nullable
                      as DetailEntity,
            berbayar: null == berbayar
                ? _value.berbayar
                : berbayar // ignore: cast_nullable_to_non_nullable
                      as BerbayarEntity,
            nonDigital: null == nonDigital
                ? _value.nonDigital
                : nonDigital // ignore: cast_nullable_to_non_nullable
                      as OpCategoryEntity,
            persentaseDigital: null == persentaseDigital
                ? _value.persentaseDigital
                : persentaseDigital // ignore: cast_nullable_to_non_nullable
                      as double,
            persentaseNonDigital: null == persentaseNonDigital
                ? _value.persentaseNonDigital
                : persentaseNonDigital // ignore: cast_nullable_to_non_nullable
                      as double,
            sofParkirResults: null == sofParkirResults
                ? _value.sofParkirResults
                : sofParkirResults // ignore: cast_nullable_to_non_nullable
                      as List<SofParkirResultEntity>,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as RoleLoginDigitalParkir,
          )
          as $Val,
    );
  }

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OpCategoryEntityCopyWith<$Res> get digital {
    return $OpCategoryEntityCopyWith<$Res>(_value.digital, (value) {
      return _then(_value.copyWith(digital: value) as $Val);
    });
  }

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DetailEntityCopyWith<$Res> get detail {
    return $DetailEntityCopyWith<$Res>(_value.detail, (value) {
      return _then(_value.copyWith(detail: value) as $Val);
    });
  }

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BerbayarEntityCopyWith<$Res> get berbayar {
    return $BerbayarEntityCopyWith<$Res>(_value.berbayar, (value) {
      return _then(_value.copyWith(berbayar: value) as $Val);
    });
  }

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OpCategoryEntityCopyWith<$Res> get nonDigital {
    return $OpCategoryEntityCopyWith<$Res>(_value.nonDigital, (value) {
      return _then(_value.copyWith(nonDigital: value) as $Val);
    });
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
    int totalOp,
    int totalOpDigital,
    int totalOpNonDigital,
    OpCategoryEntity digital,
    int totalBertarif,
    int totalNonTarif,
    int totalTarifTidakDiketahui,
    DetailEntity detail,
    BerbayarEntity berbayar,
    OpCategoryEntity nonDigital,
    double persentaseDigital,
    double persentaseNonDigital,
    List<SofParkirResultEntity> sofParkirResults,
    RoleLoginDigitalParkir role,
  });

  @override
  $OpCategoryEntityCopyWith<$Res> get digital;
  @override
  $DetailEntityCopyWith<$Res> get detail;
  @override
  $BerbayarEntityCopyWith<$Res> get berbayar;
  @override
  $OpCategoryEntityCopyWith<$Res> get nonDigital;
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
    Object? totalOp = null,
    Object? totalOpDigital = null,
    Object? totalOpNonDigital = null,
    Object? digital = null,
    Object? totalBertarif = null,
    Object? totalNonTarif = null,
    Object? totalTarifTidakDiketahui = null,
    Object? detail = null,
    Object? berbayar = null,
    Object? nonDigital = null,
    Object? persentaseDigital = null,
    Object? persentaseNonDigital = null,
    Object? sofParkirResults = null,
    Object? role = null,
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
        totalOp: null == totalOp
            ? _value.totalOp
            : totalOp // ignore: cast_nullable_to_non_nullable
                  as int,
        totalOpDigital: null == totalOpDigital
            ? _value.totalOpDigital
            : totalOpDigital // ignore: cast_nullable_to_non_nullable
                  as int,
        totalOpNonDigital: null == totalOpNonDigital
            ? _value.totalOpNonDigital
            : totalOpNonDigital // ignore: cast_nullable_to_non_nullable
                  as int,
        digital: null == digital
            ? _value.digital
            : digital // ignore: cast_nullable_to_non_nullable
                  as OpCategoryEntity,
        totalBertarif: null == totalBertarif
            ? _value.totalBertarif
            : totalBertarif // ignore: cast_nullable_to_non_nullable
                  as int,
        totalNonTarif: null == totalNonTarif
            ? _value.totalNonTarif
            : totalNonTarif // ignore: cast_nullable_to_non_nullable
                  as int,
        totalTarifTidakDiketahui: null == totalTarifTidakDiketahui
            ? _value.totalTarifTidakDiketahui
            : totalTarifTidakDiketahui // ignore: cast_nullable_to_non_nullable
                  as int,
        detail: null == detail
            ? _value.detail
            : detail // ignore: cast_nullable_to_non_nullable
                  as DetailEntity,
        berbayar: null == berbayar
            ? _value.berbayar
            : berbayar // ignore: cast_nullable_to_non_nullable
                  as BerbayarEntity,
        nonDigital: null == nonDigital
            ? _value.nonDigital
            : nonDigital // ignore: cast_nullable_to_non_nullable
                  as OpCategoryEntity,
        persentaseDigital: null == persentaseDigital
            ? _value.persentaseDigital
            : persentaseDigital // ignore: cast_nullable_to_non_nullable
                  as double,
        persentaseNonDigital: null == persentaseNonDigital
            ? _value.persentaseNonDigital
            : persentaseNonDigital // ignore: cast_nullable_to_non_nullable
                  as double,
        sofParkirResults: null == sofParkirResults
            ? _value._sofParkirResults
            : sofParkirResults // ignore: cast_nullable_to_non_nullable
                  as List<SofParkirResultEntity>,
        role: null == role
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
    this.totalOp = 0,
    this.totalOpDigital = 0,
    this.totalOpNonDigital = 0,
    this.digital = const OpCategoryEntity(
      total: 0,
      totalBertarif: 0,
      totalNonTarif: 0,
      totalTidakDiketahui: 0,
      persentaseBertarif: 0,
      persentaseNonTarif: 0,
      persentaseTidakDiketahui: 0,
    ),
    this.totalBertarif = 0,
    this.totalNonTarif = 0,
    this.totalTarifTidakDiketahui = 0,
    this.detail = const DetailEntity(
      totalEdc: 0,
      totalRompiQris: 0,
      totalCctvCounting: 0,
      totalTs: 0,
      totalBebasParkir: 0,
      totalNonDigital: 0,
    ),
    this.berbayar = const BerbayarEntity(
      digital: 0,
      nonDigital: 0,
      total: 0,
      persentase: 0,
    ),
    this.nonDigital = const OpCategoryEntity(
      total: 0,
      totalBertarif: 0,
      totalNonTarif: 0,
      totalTidakDiketahui: 0,
      persentaseBertarif: 0,
      persentaseNonTarif: 0,
      persentaseTidakDiketahui: 0,
    ),
    this.persentaseDigital = 0,
    this.persentaseNonDigital = 0,
    final List<SofParkirResultEntity> sofParkirResults = const [],
    this.role = RoleLoginDigitalParkir.tidakDiketahui,
  }) : _recentTransactions = recentTransactions,
       _weeklyChartData = weeklyChartData,
       _sofParkirResults = sofParkirResults;

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
  @override
  @JsonKey()
  final int totalOp;
  @override
  @JsonKey()
  final int totalOpDigital;
  @override
  @JsonKey()
  final int totalOpNonDigital;
  @override
  @JsonKey()
  final OpCategoryEntity digital;
  @override
  @JsonKey()
  final int totalBertarif;
  @override
  @JsonKey()
  final int totalNonTarif;
  @override
  @JsonKey()
  final int totalTarifTidakDiketahui;
  @override
  @JsonKey()
  final DetailEntity detail;
  @override
  @JsonKey()
  final BerbayarEntity berbayar;
  @override
  @JsonKey()
  final OpCategoryEntity nonDigital;
  @override
  @JsonKey()
  final double persentaseDigital;
  @override
  @JsonKey()
  final double persentaseNonDigital;
  final List<SofParkirResultEntity> _sofParkirResults;
  @override
  @JsonKey()
  List<SofParkirResultEntity> get sofParkirResults {
    if (_sofParkirResults is EqualUnmodifiableListView)
      return _sofParkirResults;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sofParkirResults);
  }

  @override
  @JsonKey()
  final RoleLoginDigitalParkir role;

  @override
  String toString() {
    return 'HomeState(status: $status, permissionActionStatus: $permissionActionStatus, selectedVehicleForCapture: $selectedVehicleForCapture, actionTimestamp: $actionTimestamp, motorCount: $motorCount, mobilCount: $mobilCount, totalPendapatan: $totalPendapatan, totalPajak: $totalPajak, totalBersih: $totalBersih, selectedModePlat: $selectedModePlat, recentTransactions: $recentTransactions, weeklyChartData: $weeklyChartData, isFree: $isFree, nop: $nop, namaLokasi: $namaLokasi, namaJukir: $namaJukir, namaOp: $namaOp, totalOp: $totalOp, totalOpDigital: $totalOpDigital, totalOpNonDigital: $totalOpNonDigital, digital: $digital, totalBertarif: $totalBertarif, totalNonTarif: $totalNonTarif, totalTarifTidakDiketahui: $totalTarifTidakDiketahui, detail: $detail, berbayar: $berbayar, nonDigital: $nonDigital, persentaseDigital: $persentaseDigital, persentaseNonDigital: $persentaseNonDigital, sofParkirResults: $sofParkirResults, role: $role)';
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
            (identical(other.totalOp, totalOp) || other.totalOp == totalOp) &&
            (identical(other.totalOpDigital, totalOpDigital) ||
                other.totalOpDigital == totalOpDigital) &&
            (identical(other.totalOpNonDigital, totalOpNonDigital) ||
                other.totalOpNonDigital == totalOpNonDigital) &&
            (identical(other.digital, digital) || other.digital == digital) &&
            (identical(other.totalBertarif, totalBertarif) ||
                other.totalBertarif == totalBertarif) &&
            (identical(other.totalNonTarif, totalNonTarif) ||
                other.totalNonTarif == totalNonTarif) &&
            (identical(
                  other.totalTarifTidakDiketahui,
                  totalTarifTidakDiketahui,
                ) ||
                other.totalTarifTidakDiketahui == totalTarifTidakDiketahui) &&
            (identical(other.detail, detail) || other.detail == detail) &&
            (identical(other.berbayar, berbayar) ||
                other.berbayar == berbayar) &&
            (identical(other.nonDigital, nonDigital) ||
                other.nonDigital == nonDigital) &&
            (identical(other.persentaseDigital, persentaseDigital) ||
                other.persentaseDigital == persentaseDigital) &&
            (identical(other.persentaseNonDigital, persentaseNonDigital) ||
                other.persentaseNonDigital == persentaseNonDigital) &&
            const DeepCollectionEquality().equals(
              other._sofParkirResults,
              _sofParkirResults,
            ) &&
            (identical(other.role, role) || other.role == role));
  }

  @override
  int get hashCode => Object.hashAll([
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
    totalOp,
    totalOpDigital,
    totalOpNonDigital,
    digital,
    totalBertarif,
    totalNonTarif,
    totalTarifTidakDiketahui,
    detail,
    berbayar,
    nonDigital,
    persentaseDigital,
    persentaseNonDigital,
    const DeepCollectionEquality().hash(_sofParkirResults),
    role,
  ]);

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
    final int totalOp,
    final int totalOpDigital,
    final int totalOpNonDigital,
    final OpCategoryEntity digital,
    final int totalBertarif,
    final int totalNonTarif,
    final int totalTarifTidakDiketahui,
    final DetailEntity detail,
    final BerbayarEntity berbayar,
    final OpCategoryEntity nonDigital,
    final double persentaseDigital,
    final double persentaseNonDigital,
    final List<SofParkirResultEntity> sofParkirResults,
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
  String get namaOp;
  @override
  int get totalOp;
  @override
  int get totalOpDigital;
  @override
  int get totalOpNonDigital;
  @override
  OpCategoryEntity get digital;
  @override
  int get totalBertarif;
  @override
  int get totalNonTarif;
  @override
  int get totalTarifTidakDiketahui;
  @override
  DetailEntity get detail;
  @override
  BerbayarEntity get berbayar;
  @override
  OpCategoryEntity get nonDigital;
  @override
  double get persentaseDigital;
  @override
  double get persentaseNonDigital;
  @override
  List<SofParkirResultEntity> get sofParkirResults;
  @override
  RoleLoginDigitalParkir get role;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
