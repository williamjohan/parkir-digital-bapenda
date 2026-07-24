// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'op_pengawasan_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$OpPengawasanState {
  bool get isLoading => throw _privateConstructorUsedError;
  List<OpPengawasEntity> get opPengawasanList =>
      throw _privateConstructorUsedError;
  List<OpPengawasEntity> get filteredOpPengawasanList =>
      throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of OpPengawasanState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OpPengawasanStateCopyWith<OpPengawasanState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OpPengawasanStateCopyWith<$Res> {
  factory $OpPengawasanStateCopyWith(
    OpPengawasanState value,
    $Res Function(OpPengawasanState) then,
  ) = _$OpPengawasanStateCopyWithImpl<$Res, OpPengawasanState>;
  @useResult
  $Res call({
    bool isLoading,
    List<OpPengawasEntity> opPengawasanList,
    List<OpPengawasEntity> filteredOpPengawasanList,
    String? errorMessage,
  });
}

/// @nodoc
class _$OpPengawasanStateCopyWithImpl<$Res, $Val extends OpPengawasanState>
    implements $OpPengawasanStateCopyWith<$Res> {
  _$OpPengawasanStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OpPengawasanState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? opPengawasanList = null,
    Object? filteredOpPengawasanList = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            opPengawasanList: null == opPengawasanList
                ? _value.opPengawasanList
                : opPengawasanList // ignore: cast_nullable_to_non_nullable
                      as List<OpPengawasEntity>,
            filteredOpPengawasanList: null == filteredOpPengawasanList
                ? _value.filteredOpPengawasanList
                : filteredOpPengawasanList // ignore: cast_nullable_to_non_nullable
                      as List<OpPengawasEntity>,
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
abstract class _$$OpPengawasanStateImplCopyWith<$Res>
    implements $OpPengawasanStateCopyWith<$Res> {
  factory _$$OpPengawasanStateImplCopyWith(
    _$OpPengawasanStateImpl value,
    $Res Function(_$OpPengawasanStateImpl) then,
  ) = __$$OpPengawasanStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isLoading,
    List<OpPengawasEntity> opPengawasanList,
    List<OpPengawasEntity> filteredOpPengawasanList,
    String? errorMessage,
  });
}

/// @nodoc
class __$$OpPengawasanStateImplCopyWithImpl<$Res>
    extends _$OpPengawasanStateCopyWithImpl<$Res, _$OpPengawasanStateImpl>
    implements _$$OpPengawasanStateImplCopyWith<$Res> {
  __$$OpPengawasanStateImplCopyWithImpl(
    _$OpPengawasanStateImpl _value,
    $Res Function(_$OpPengawasanStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OpPengawasanState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? opPengawasanList = null,
    Object? filteredOpPengawasanList = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$OpPengawasanStateImpl(
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        opPengawasanList: null == opPengawasanList
            ? _value._opPengawasanList
            : opPengawasanList // ignore: cast_nullable_to_non_nullable
                  as List<OpPengawasEntity>,
        filteredOpPengawasanList: null == filteredOpPengawasanList
            ? _value._filteredOpPengawasanList
            : filteredOpPengawasanList // ignore: cast_nullable_to_non_nullable
                  as List<OpPengawasEntity>,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$OpPengawasanStateImpl implements _OpPengawasanState {
  const _$OpPengawasanStateImpl({
    this.isLoading = false,
    final List<OpPengawasEntity> opPengawasanList = const [],
    final List<OpPengawasEntity> filteredOpPengawasanList = const [],
    this.errorMessage,
  }) : _opPengawasanList = opPengawasanList,
       _filteredOpPengawasanList = filteredOpPengawasanList;

  @override
  @JsonKey()
  final bool isLoading;
  final List<OpPengawasEntity> _opPengawasanList;
  @override
  @JsonKey()
  List<OpPengawasEntity> get opPengawasanList {
    if (_opPengawasanList is EqualUnmodifiableListView)
      return _opPengawasanList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_opPengawasanList);
  }

  final List<OpPengawasEntity> _filteredOpPengawasanList;
  @override
  @JsonKey()
  List<OpPengawasEntity> get filteredOpPengawasanList {
    if (_filteredOpPengawasanList is EqualUnmodifiableListView)
      return _filteredOpPengawasanList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filteredOpPengawasanList);
  }

  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'OpPengawasanState(isLoading: $isLoading, opPengawasanList: $opPengawasanList, filteredOpPengawasanList: $filteredOpPengawasanList, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OpPengawasanStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality().equals(
              other._opPengawasanList,
              _opPengawasanList,
            ) &&
            const DeepCollectionEquality().equals(
              other._filteredOpPengawasanList,
              _filteredOpPengawasanList,
            ) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isLoading,
    const DeepCollectionEquality().hash(_opPengawasanList),
    const DeepCollectionEquality().hash(_filteredOpPengawasanList),
    errorMessage,
  );

  /// Create a copy of OpPengawasanState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OpPengawasanStateImplCopyWith<_$OpPengawasanStateImpl> get copyWith =>
      __$$OpPengawasanStateImplCopyWithImpl<_$OpPengawasanStateImpl>(
        this,
        _$identity,
      );
}

abstract class _OpPengawasanState implements OpPengawasanState {
  const factory _OpPengawasanState({
    final bool isLoading,
    final List<OpPengawasEntity> opPengawasanList,
    final List<OpPengawasEntity> filteredOpPengawasanList,
    final String? errorMessage,
  }) = _$OpPengawasanStateImpl;

  @override
  bool get isLoading;
  @override
  List<OpPengawasEntity> get opPengawasanList;
  @override
  List<OpPengawasEntity> get filteredOpPengawasanList;
  @override
  String? get errorMessage;

  /// Create a copy of OpPengawasanState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OpPengawasanStateImplCopyWith<_$OpPengawasanStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
