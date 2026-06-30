// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'data_jukir_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DataJukirState {
  bool get isLoading => throw _privateConstructorUsedError;
  List<DataJukirEntity> get data => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of DataJukirState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DataJukirStateCopyWith<DataJukirState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DataJukirStateCopyWith<$Res> {
  factory $DataJukirStateCopyWith(
    DataJukirState value,
    $Res Function(DataJukirState) then,
  ) = _$DataJukirStateCopyWithImpl<$Res, DataJukirState>;
  @useResult
  $Res call({bool isLoading, List<DataJukirEntity> data, String? errorMessage});
}

/// @nodoc
class _$DataJukirStateCopyWithImpl<$Res, $Val extends DataJukirState>
    implements $DataJukirStateCopyWith<$Res> {
  _$DataJukirStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DataJukirState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? data = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            data: null == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as List<DataJukirEntity>,
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
abstract class _$$DataJukirStateImplCopyWith<$Res>
    implements $DataJukirStateCopyWith<$Res> {
  factory _$$DataJukirStateImplCopyWith(
    _$DataJukirStateImpl value,
    $Res Function(_$DataJukirStateImpl) then,
  ) = __$$DataJukirStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLoading, List<DataJukirEntity> data, String? errorMessage});
}

/// @nodoc
class __$$DataJukirStateImplCopyWithImpl<$Res>
    extends _$DataJukirStateCopyWithImpl<$Res, _$DataJukirStateImpl>
    implements _$$DataJukirStateImplCopyWith<$Res> {
  __$$DataJukirStateImplCopyWithImpl(
    _$DataJukirStateImpl _value,
    $Res Function(_$DataJukirStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DataJukirState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? data = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$DataJukirStateImpl(
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        data: null == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as List<DataJukirEntity>,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$DataJukirStateImpl implements _DataJukirState {
  const _$DataJukirStateImpl({
    this.isLoading = false,
    final List<DataJukirEntity> data = const <DataJukirEntity>[],
    this.errorMessage,
  }) : _data = data;

  @override
  @JsonKey()
  final bool isLoading;
  final List<DataJukirEntity> _data;
  @override
  @JsonKey()
  List<DataJukirEntity> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'DataJukirState(isLoading: $isLoading, data: $data, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DataJukirStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isLoading,
    const DeepCollectionEquality().hash(_data),
    errorMessage,
  );

  /// Create a copy of DataJukirState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DataJukirStateImplCopyWith<_$DataJukirStateImpl> get copyWith =>
      __$$DataJukirStateImplCopyWithImpl<_$DataJukirStateImpl>(
        this,
        _$identity,
      );
}

abstract class _DataJukirState implements DataJukirState {
  const factory _DataJukirState({
    final bool isLoading,
    final List<DataJukirEntity> data,
    final String? errorMessage,
  }) = _$DataJukirStateImpl;

  @override
  bool get isLoading;
  @override
  List<DataJukirEntity> get data;
  @override
  String? get errorMessage;

  /// Create a copy of DataJukirState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DataJukirStateImplCopyWith<_$DataJukirStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
