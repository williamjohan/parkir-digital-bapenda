// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'jukir_counter_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$JukirCounterState {
  JukirCounterStatus get status => throw _privateConstructorUsedError;
  int get mobilCount => throw _privateConstructorUsedError;
  int get motorCount => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of JukirCounterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JukirCounterStateCopyWith<JukirCounterState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JukirCounterStateCopyWith<$Res> {
  factory $JukirCounterStateCopyWith(
    JukirCounterState value,
    $Res Function(JukirCounterState) then,
  ) = _$JukirCounterStateCopyWithImpl<$Res, JukirCounterState>;
  @useResult
  $Res call({
    JukirCounterStatus status,
    int mobilCount,
    int motorCount,
    String? errorMessage,
  });
}

/// @nodoc
class _$JukirCounterStateCopyWithImpl<$Res, $Val extends JukirCounterState>
    implements $JukirCounterStateCopyWith<$Res> {
  _$JukirCounterStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JukirCounterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? mobilCount = null,
    Object? motorCount = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as JukirCounterStatus,
            mobilCount: null == mobilCount
                ? _value.mobilCount
                : mobilCount // ignore: cast_nullable_to_non_nullable
                      as int,
            motorCount: null == motorCount
                ? _value.motorCount
                : motorCount // ignore: cast_nullable_to_non_nullable
                      as int,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$JukirCounterStateImplCopyWith<$Res>
    implements $JukirCounterStateCopyWith<$Res> {
  factory _$$JukirCounterStateImplCopyWith(
    _$JukirCounterStateImpl value,
    $Res Function(_$JukirCounterStateImpl) then,
  ) = __$$JukirCounterStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    JukirCounterStatus status,
    int mobilCount,
    int motorCount,
    String? errorMessage,
  });
}

/// @nodoc
class __$$JukirCounterStateImplCopyWithImpl<$Res>
    extends _$JukirCounterStateCopyWithImpl<$Res, _$JukirCounterStateImpl>
    implements _$$JukirCounterStateImplCopyWith<$Res> {
  __$$JukirCounterStateImplCopyWithImpl(
    _$JukirCounterStateImpl _value,
    $Res Function(_$JukirCounterStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JukirCounterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? mobilCount = null,
    Object? motorCount = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$JukirCounterStateImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as JukirCounterStatus,
        mobilCount: null == mobilCount
            ? _value.mobilCount
            : mobilCount // ignore: cast_nullable_to_non_nullable
                  as int,
        motorCount: null == motorCount
            ? _value.motorCount
            : motorCount // ignore: cast_nullable_to_non_nullable
                  as int,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$JukirCounterStateImpl implements _JukirCounterState {
  const _$JukirCounterStateImpl({
    this.status = JukirCounterStatus.initial,
    this.mobilCount = 0,
    this.motorCount = 0,
    this.errorMessage,
  });

  @override
  @JsonKey()
  final JukirCounterStatus status;
  @override
  @JsonKey()
  final int mobilCount;
  @override
  @JsonKey()
  final int motorCount;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'JukirCounterState(status: $status, mobilCount: $mobilCount, motorCount: $motorCount, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JukirCounterStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.mobilCount, mobilCount) ||
                other.mobilCount == mobilCount) &&
            (identical(other.motorCount, motorCount) ||
                other.motorCount == motorCount) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, status, mobilCount, motorCount, errorMessage);

  /// Create a copy of JukirCounterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JukirCounterStateImplCopyWith<_$JukirCounterStateImpl> get copyWith =>
      __$$JukirCounterStateImplCopyWithImpl<_$JukirCounterStateImpl>(
        this,
        _$identity,
      );
}

abstract class _JukirCounterState implements JukirCounterState {
  const factory _JukirCounterState({
    final JukirCounterStatus status,
    final int mobilCount,
    final int motorCount,
    final String? errorMessage,
  }) = _$JukirCounterStateImpl;

  @override
  JukirCounterStatus get status;
  @override
  int get mobilCount;
  @override
  int get motorCount;
  @override
  String? get errorMessage;

  /// Create a copy of JukirCounterState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JukirCounterStateImplCopyWith<_$JukirCounterStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
