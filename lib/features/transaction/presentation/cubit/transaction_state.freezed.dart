// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TransactionState {
  TransactionStatus get status => throw _privateConstructorUsedError;
  List<TarifModel> get tarifList => throw _privateConstructorUsedError;
  TarifModel? get selectedTarif => throw _privateConstructorUsedError;
  bool get isFree => throw _privateConstructorUsedError;
  Map<String, String> get qrisMap =>
      throw _privateConstructorUsedError; // 💡 Legacy/Future properties (Dipertahankan agar UI lama tidak error)
  DataJukirStatus get dataJukirStatus => throw _privateConstructorUsedError;
  List<DataJukirEntity> get dataJukirList => throw _privateConstructorUsedError;
  DataJukirEntity? get selectedJukir => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of TransactionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionStateCopyWith<TransactionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionStateCopyWith<$Res> {
  factory $TransactionStateCopyWith(
    TransactionState value,
    $Res Function(TransactionState) then,
  ) = _$TransactionStateCopyWithImpl<$Res, TransactionState>;
  @useResult
  $Res call({
    TransactionStatus status,
    List<TarifModel> tarifList,
    TarifModel? selectedTarif,
    bool isFree,
    Map<String, String> qrisMap,
    DataJukirStatus dataJukirStatus,
    List<DataJukirEntity> dataJukirList,
    DataJukirEntity? selectedJukir,
    String? errorMessage,
  });

  $DataJukirEntityCopyWith<$Res>? get selectedJukir;
}

/// @nodoc
class _$TransactionStateCopyWithImpl<$Res, $Val extends TransactionState>
    implements $TransactionStateCopyWith<$Res> {
  _$TransactionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? tarifList = null,
    Object? selectedTarif = freezed,
    Object? isFree = null,
    Object? qrisMap = null,
    Object? dataJukirStatus = null,
    Object? dataJukirList = null,
    Object? selectedJukir = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as TransactionStatus,
            tarifList: null == tarifList
                ? _value.tarifList
                : tarifList // ignore: cast_nullable_to_non_nullable
                      as List<TarifModel>,
            selectedTarif: freezed == selectedTarif
                ? _value.selectedTarif
                : selectedTarif // ignore: cast_nullable_to_non_nullable
                      as TarifModel?,
            isFree: null == isFree
                ? _value.isFree
                : isFree // ignore: cast_nullable_to_non_nullable
                      as bool,
            qrisMap: null == qrisMap
                ? _value.qrisMap
                : qrisMap // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
            dataJukirStatus: null == dataJukirStatus
                ? _value.dataJukirStatus
                : dataJukirStatus // ignore: cast_nullable_to_non_nullable
                      as DataJukirStatus,
            dataJukirList: null == dataJukirList
                ? _value.dataJukirList
                : dataJukirList // ignore: cast_nullable_to_non_nullable
                      as List<DataJukirEntity>,
            selectedJukir: freezed == selectedJukir
                ? _value.selectedJukir
                : selectedJukir // ignore: cast_nullable_to_non_nullable
                      as DataJukirEntity?,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of TransactionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DataJukirEntityCopyWith<$Res>? get selectedJukir {
    if (_value.selectedJukir == null) {
      return null;
    }

    return $DataJukirEntityCopyWith<$Res>(_value.selectedJukir!, (value) {
      return _then(_value.copyWith(selectedJukir: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TransactionStateImplCopyWith<$Res>
    implements $TransactionStateCopyWith<$Res> {
  factory _$$TransactionStateImplCopyWith(
    _$TransactionStateImpl value,
    $Res Function(_$TransactionStateImpl) then,
  ) = __$$TransactionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    TransactionStatus status,
    List<TarifModel> tarifList,
    TarifModel? selectedTarif,
    bool isFree,
    Map<String, String> qrisMap,
    DataJukirStatus dataJukirStatus,
    List<DataJukirEntity> dataJukirList,
    DataJukirEntity? selectedJukir,
    String? errorMessage,
  });

  @override
  $DataJukirEntityCopyWith<$Res>? get selectedJukir;
}

/// @nodoc
class __$$TransactionStateImplCopyWithImpl<$Res>
    extends _$TransactionStateCopyWithImpl<$Res, _$TransactionStateImpl>
    implements _$$TransactionStateImplCopyWith<$Res> {
  __$$TransactionStateImplCopyWithImpl(
    _$TransactionStateImpl _value,
    $Res Function(_$TransactionStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? tarifList = null,
    Object? selectedTarif = freezed,
    Object? isFree = null,
    Object? qrisMap = null,
    Object? dataJukirStatus = null,
    Object? dataJukirList = null,
    Object? selectedJukir = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$TransactionStateImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as TransactionStatus,
        tarifList: null == tarifList
            ? _value._tarifList
            : tarifList // ignore: cast_nullable_to_non_nullable
                  as List<TarifModel>,
        selectedTarif: freezed == selectedTarif
            ? _value.selectedTarif
            : selectedTarif // ignore: cast_nullable_to_non_nullable
                  as TarifModel?,
        isFree: null == isFree
            ? _value.isFree
            : isFree // ignore: cast_nullable_to_non_nullable
                  as bool,
        qrisMap: null == qrisMap
            ? _value._qrisMap
            : qrisMap // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
        dataJukirStatus: null == dataJukirStatus
            ? _value.dataJukirStatus
            : dataJukirStatus // ignore: cast_nullable_to_non_nullable
                  as DataJukirStatus,
        dataJukirList: null == dataJukirList
            ? _value._dataJukirList
            : dataJukirList // ignore: cast_nullable_to_non_nullable
                  as List<DataJukirEntity>,
        selectedJukir: freezed == selectedJukir
            ? _value.selectedJukir
            : selectedJukir // ignore: cast_nullable_to_non_nullable
                  as DataJukirEntity?,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$TransactionStateImpl extends _TransactionState {
  const _$TransactionStateImpl({
    this.status = TransactionStatus.ready,
    final List<TarifModel> tarifList = const [],
    this.selectedTarif,
    this.isFree = false,
    final Map<String, String> qrisMap = const {},
    this.dataJukirStatus = DataJukirStatus.initial,
    final List<DataJukirEntity> dataJukirList = const [],
    this.selectedJukir,
    this.errorMessage,
  }) : _tarifList = tarifList,
       _qrisMap = qrisMap,
       _dataJukirList = dataJukirList,
       super._();

  @override
  @JsonKey()
  final TransactionStatus status;
  final List<TarifModel> _tarifList;
  @override
  @JsonKey()
  List<TarifModel> get tarifList {
    if (_tarifList is EqualUnmodifiableListView) return _tarifList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tarifList);
  }

  @override
  final TarifModel? selectedTarif;
  @override
  @JsonKey()
  final bool isFree;
  final Map<String, String> _qrisMap;
  @override
  @JsonKey()
  Map<String, String> get qrisMap {
    if (_qrisMap is EqualUnmodifiableMapView) return _qrisMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_qrisMap);
  }

  // 💡 Legacy/Future properties (Dipertahankan agar UI lama tidak error)
  @override
  @JsonKey()
  final DataJukirStatus dataJukirStatus;
  final List<DataJukirEntity> _dataJukirList;
  @override
  @JsonKey()
  List<DataJukirEntity> get dataJukirList {
    if (_dataJukirList is EqualUnmodifiableListView) return _dataJukirList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dataJukirList);
  }

  @override
  final DataJukirEntity? selectedJukir;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'TransactionState(status: $status, tarifList: $tarifList, selectedTarif: $selectedTarif, isFree: $isFree, qrisMap: $qrisMap, dataJukirStatus: $dataJukirStatus, dataJukirList: $dataJukirList, selectedJukir: $selectedJukir, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(
              other._tarifList,
              _tarifList,
            ) &&
            (identical(other.selectedTarif, selectedTarif) ||
                other.selectedTarif == selectedTarif) &&
            (identical(other.isFree, isFree) || other.isFree == isFree) &&
            const DeepCollectionEquality().equals(other._qrisMap, _qrisMap) &&
            (identical(other.dataJukirStatus, dataJukirStatus) ||
                other.dataJukirStatus == dataJukirStatus) &&
            const DeepCollectionEquality().equals(
              other._dataJukirList,
              _dataJukirList,
            ) &&
            (identical(other.selectedJukir, selectedJukir) ||
                other.selectedJukir == selectedJukir) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    const DeepCollectionEquality().hash(_tarifList),
    selectedTarif,
    isFree,
    const DeepCollectionEquality().hash(_qrisMap),
    dataJukirStatus,
    const DeepCollectionEquality().hash(_dataJukirList),
    selectedJukir,
    errorMessage,
  );

  /// Create a copy of TransactionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionStateImplCopyWith<_$TransactionStateImpl> get copyWith =>
      __$$TransactionStateImplCopyWithImpl<_$TransactionStateImpl>(
        this,
        _$identity,
      );
}

abstract class _TransactionState extends TransactionState {
  const factory _TransactionState({
    final TransactionStatus status,
    final List<TarifModel> tarifList,
    final TarifModel? selectedTarif,
    final bool isFree,
    final Map<String, String> qrisMap,
    final DataJukirStatus dataJukirStatus,
    final List<DataJukirEntity> dataJukirList,
    final DataJukirEntity? selectedJukir,
    final String? errorMessage,
  }) = _$TransactionStateImpl;
  const _TransactionState._() : super._();

  @override
  TransactionStatus get status;
  @override
  List<TarifModel> get tarifList;
  @override
  TarifModel? get selectedTarif;
  @override
  bool get isFree;
  @override
  Map<String, String> get qrisMap; // 💡 Legacy/Future properties (Dipertahankan agar UI lama tidak error)
  @override
  DataJukirStatus get dataJukirStatus;
  @override
  List<DataJukirEntity> get dataJukirList;
  @override
  DataJukirEntity? get selectedJukir;
  @override
  String? get errorMessage;

  /// Create a copy of TransactionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionStateImplCopyWith<_$TransactionStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
