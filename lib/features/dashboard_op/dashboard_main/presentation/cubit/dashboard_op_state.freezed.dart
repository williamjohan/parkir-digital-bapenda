// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_op_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DashboardOpState {
  bool get loading => throw _privateConstructorUsedError;
  bool get showTSCard => throw _privateConstructorUsedError;
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
  $Res call({
    bool loading,
    bool showTSCard,
    DashboardOpEntity? data,
    String? errorMessage,
  });

  $DashboardOpEntityCopyWith<$Res>? get data;
}

/// @nodoc
class _$DashboardOpStateCopyWithImpl<$Res, $Val extends DashboardOpState>
    implements $DashboardOpStateCopyWith<$Res> {
  _$DashboardOpStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardOpState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? showTSCard = null,
    Object? data = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            loading: null == loading
                ? _value.loading
                : loading // ignore: cast_nullable_to_non_nullable
                      as bool,
            showTSCard: null == showTSCard
                ? _value.showTSCard
                : showTSCard // ignore: cast_nullable_to_non_nullable
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
  $Res call({
    bool loading,
    bool showTSCard,
    DashboardOpEntity? data,
    String? errorMessage,
  });

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
    Object? showTSCard = null,
    Object? data = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$DashboardOpStateImpl(
        loading: null == loading
            ? _value.loading
            : loading // ignore: cast_nullable_to_non_nullable
                  as bool,
        showTSCard: null == showTSCard
            ? _value.showTSCard
            : showTSCard // ignore: cast_nullable_to_non_nullable
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
    this.showTSCard = false,
    this.data,
    this.errorMessage,
  });

  @override
  @JsonKey()
  final bool loading;
  @override
  @JsonKey()
  final bool showTSCard;
  @override
  final DashboardOpEntity? data;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'DashboardOpState(loading: $loading, showTSCard: $showTSCard, data: $data, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardOpStateImpl &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.showTSCard, showTSCard) ||
                other.showTSCard == showTSCard) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, loading, showTSCard, data, errorMessage);

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
    final bool showTSCard,
    final DashboardOpEntity? data,
    final String? errorMessage,
  }) = _$DashboardOpStateImpl;

  @override
  bool get loading;
  @override
  bool get showTSCard;
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
