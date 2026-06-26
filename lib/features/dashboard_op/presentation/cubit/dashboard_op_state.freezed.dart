part of 'dashboard_op_state.dart';

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DashboardOpState {
  bool get loading => throw _privateConstructorUsedError;
  DashboardOpEntity? get data => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of DashboardOpState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardOpStateCopyWith<DashboardOpState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardOpStateCopyWith<$Res> {
  factory $DashboardOpStateCopyWith(
    DashboardOpState value,
    $Res Function(DashboardOpState) then,
  ) = _$DashboardOpStateCopyWithImpl<$Res, DashboardOpState>;
  @useResult
  $Res call({bool loading, DashboardOpEntity? data, String? errorMessage});

  $DashboardOpEntityCopyWith<$Res>? get data;
}

/// @nodoc
class _$DashboardOpStateCopyWithImpl<$Res, $Val extends DashboardOpState>
    implements $DashboardOpStateCopyWith<$Res> {
  _$DashboardOpStateCopyWithImpl(this._value, this._then);
  final $Val _value;
  final $Res Function($Val) _then;

  /// Create a copy of DashboardOpState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? data = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            loading: null == loading
                ? _value.loading
                : loading // ignore: cast_nullable_to_non_nullable
                      as bool,
            data: freezed == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as DashboardOpEntity?,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of DashboardOpState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DashboardOpEntityCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $DashboardOpEntityCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DashboardOpStateImplCopyWith<$Res>
    implements $DashboardOpStateCopyWith<$Res> {
  factory _$$DashboardOpStateImplCopyWith(
    _$DashboardOpStateImpl value,
    $Res Function(_$DashboardOpStateImpl) then,
  ) = __$$DashboardOpStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool loading, DashboardOpEntity? data, String? errorMessage});

  @override
  $DashboardOpEntityCopyWith<$Res>? get data;
}

/// @nodoc
class __$$DashboardOpStateImplCopyWithImpl<$Res>
    extends _$DashboardOpStateCopyWithImpl<$Res, _$DashboardOpStateImpl>
    implements _$$DashboardOpStateImplCopyWith<$Res> {
  __$$DashboardOpStateImplCopyWithImpl(
    _$DashboardOpStateImpl _value,
    $Res Function(_$DashboardOpStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DashboardOpState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? data = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$DashboardOpStateImpl(
        loading: null == loading
            ? _value.loading
            : loading // ignore: cast_nullable_to_non_nullable
                  as bool,
        data: freezed == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as DashboardOpEntity?,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$DashboardOpStateImpl implements _DashboardOpState {
  const _$DashboardOpStateImpl({
    this.loading = false,
    this.data,
    this.errorMessage,
  });

  @override
  @JsonKey()
  final bool loading;
  @override
  final DashboardOpEntity? data;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'DashboardOpState(loading: $loading, data: $data, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardOpStateImpl &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, loading, data, errorMessage);

  /// Create a copy of DashboardOpState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardOpStateImplCopyWith<_$DashboardOpStateImpl> get copyWith =>
      __$$DashboardOpStateImplCopyWithImpl<_$DashboardOpStateImpl>(
        this,
        _$identity,
      );
}

abstract class _DashboardOpState implements DashboardOpState {
  const factory _DashboardOpState({
    final bool loading,
    final DashboardOpEntity? data,
    final String? errorMessage,
  }) = _$DashboardOpStateImpl;

  @override
  bool get loading;
  @override
  DashboardOpEntity? get data;
  @override
  String? get errorMessage;

  /// Create a copy of DashboardOpState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardOpStateImplCopyWith<_$DashboardOpStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
