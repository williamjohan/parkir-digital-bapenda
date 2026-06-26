part of 'detail_realisasi_op_state.dart';

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DetailRealisasiOpState {
  int get selectedYear => throw _privateConstructorUsedError;
  int get currentYear => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  DetailRealisasiOpEntity? get data => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of DetailRealisasiOpState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DetailRealisasiOpStateCopyWith<DetailRealisasiOpState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DetailRealisasiOpStateCopyWith<$Res> {
  factory $DetailRealisasiOpStateCopyWith(
    DetailRealisasiOpState value,
    $Res Function(DetailRealisasiOpState) then,
  ) = _$DetailRealisasiOpStateCopyWithImpl<$Res, DetailRealisasiOpState>;
  @useResult
  $Res call({
    int selectedYear,
    int currentYear,
    bool isLoading,
    DetailRealisasiOpEntity? data,
    String? errorMessage,
  });

  $DetailRealisasiOpEntityCopyWith<$Res>? get data;
}

/// @nodoc
class _$DetailRealisasiOpStateCopyWithImpl<
  $Res,
  $Val extends DetailRealisasiOpState
>
    implements $DetailRealisasiOpStateCopyWith<$Res> {
  _$DetailRealisasiOpStateCopyWithImpl(this._value, this._then);
  final $Val _value;
  final $Res Function($Val) _then;

  /// Create a copy of DetailRealisasiOpState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedYear = null,
    Object? currentYear = null,
    Object? isLoading = null,
    Object? data = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            selectedYear: null == selectedYear
                ? _value.selectedYear
                : selectedYear // ignore: cast_nullable_to_non_nullable
                      as int,
            currentYear: null == currentYear
                ? _value.currentYear
                : currentYear // ignore: cast_nullable_to_non_nullable
                      as int,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            data: freezed == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as DetailRealisasiOpEntity?,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of DetailRealisasiOpState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DetailRealisasiOpEntityCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $DetailRealisasiOpEntityCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DetailRealisasiOpStateImplCopyWith<$Res>
    implements $DetailRealisasiOpStateCopyWith<$Res> {
  factory _$$DetailRealisasiOpStateImplCopyWith(
    _$DetailRealisasiOpStateImpl value,
    $Res Function(_$DetailRealisasiOpStateImpl) then,
  ) = __$$DetailRealisasiOpStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int selectedYear,
    int currentYear,
    bool isLoading,
    DetailRealisasiOpEntity? data,
    String? errorMessage,
  });

  @override
  $DetailRealisasiOpEntityCopyWith<$Res>? get data;
}

/// @nodoc
class __$$DetailRealisasiOpStateImplCopyWithImpl<$Res>
    extends
        _$DetailRealisasiOpStateCopyWithImpl<$Res, _$DetailRealisasiOpStateImpl>
    implements _$$DetailRealisasiOpStateImplCopyWith<$Res> {
  __$$DetailRealisasiOpStateImplCopyWithImpl(
    _$DetailRealisasiOpStateImpl _value,
    $Res Function(_$DetailRealisasiOpStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DetailRealisasiOpState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedYear = null,
    Object? currentYear = null,
    Object? isLoading = null,
    Object? data = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$DetailRealisasiOpStateImpl(
        selectedYear: null == selectedYear
            ? _value.selectedYear
            : selectedYear // ignore: cast_nullable_to_non_nullable
                  as int,
        currentYear: null == currentYear
            ? _value.currentYear
            : currentYear // ignore: cast_nullable_to_non_nullable
                  as int,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        data: freezed == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as DetailRealisasiOpEntity?,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$DetailRealisasiOpStateImpl extends _DetailRealisasiOpState {
  const _$DetailRealisasiOpStateImpl({
    required this.selectedYear,
    required this.currentYear,
    this.isLoading = false,
    this.data,
    this.errorMessage,
  }) : super._();

  @override
  final int selectedYear;
  @override
  final int currentYear;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final DetailRealisasiOpEntity? data;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'DetailRealisasiOpState(selectedYear: $selectedYear, currentYear: $currentYear, isLoading: $isLoading, data: $data, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DetailRealisasiOpStateImpl &&
            (identical(other.selectedYear, selectedYear) ||
                other.selectedYear == selectedYear) &&
            (identical(other.currentYear, currentYear) ||
                other.currentYear == currentYear) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    selectedYear,
    currentYear,
    isLoading,
    data,
    errorMessage,
  );

  /// Create a copy of DetailRealisasiOpState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DetailRealisasiOpStateImplCopyWith<_$DetailRealisasiOpStateImpl>
  get copyWith =>
      __$$DetailRealisasiOpStateImplCopyWithImpl<_$DetailRealisasiOpStateImpl>(
        this,
        _$identity,
      );
}

abstract class _DetailRealisasiOpState extends DetailRealisasiOpState {
  const factory _DetailRealisasiOpState({
    required final int selectedYear,
    required final int currentYear,
    final bool isLoading,
    final DetailRealisasiOpEntity? data,
    final String? errorMessage,
  }) = _$DetailRealisasiOpStateImpl;
  const _DetailRealisasiOpState._() : super._();

  @override
  int get selectedYear;
  @override
  int get currentYear;
  @override
  bool get isLoading;
  @override
  DetailRealisasiOpEntity? get data;
  @override
  String? get errorMessage;

  /// Create a copy of DetailRealisasiOpState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DetailRealisasiOpStateImplCopyWith<_$DetailRealisasiOpStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}
