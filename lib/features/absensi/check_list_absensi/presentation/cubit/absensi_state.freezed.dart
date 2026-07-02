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
  $Res call({AbsensiStatus status, String errorMessage});
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
  $Res call({Object? status = null, Object? errorMessage = null}) {
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
  $Res call({AbsensiStatus status, String errorMessage});
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
  $Res call({Object? status = null, Object? errorMessage = null}) {
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
      ),
    );
  }
}

/// @nodoc

class _$AbsensiStateImpl implements _AbsensiState {
  const _$AbsensiStateImpl({
    this.status = AbsensiStatus.initial,
    this.errorMessage = '',
  });

  @override
  @JsonKey()
  final AbsensiStatus status;
  @override
  @JsonKey()
  final String errorMessage;

  @override
  String toString() {
    return 'AbsensiState(status: $status, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AbsensiStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, errorMessage);

  /// Create a copy of AbsensiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AbsensiStateImplCopyWith<_$AbsensiStateImpl> get copyWith =>
      __$$AbsensiStateImplCopyWithImpl<_$AbsensiStateImpl>(this, _$identity);
}

abstract class _AbsensiState implements AbsensiState {
  const factory _AbsensiState({
    final AbsensiStatus status,
    final String errorMessage,
  }) = _$AbsensiStateImpl;

  @override
  AbsensiStatus get status;
  @override
  String get errorMessage;

  /// Create a copy of AbsensiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AbsensiStateImplCopyWith<_$AbsensiStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
