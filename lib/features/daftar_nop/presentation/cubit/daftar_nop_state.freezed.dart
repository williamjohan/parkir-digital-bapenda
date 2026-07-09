// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daftar_nop_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DaftarNopState {
  List<DaftarNopEntity> get daftarNop => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isSaving => throw _privateConstructorUsedError;
  bool get isSuccess => throw _privateConstructorUsedError;
  String get errorMessage => throw _privateConstructorUsedError;

  /// 0.0 - 1.0
  double get progress => throw _privateConstructorUsedError;

  /// Create a copy of DaftarNopState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DaftarNopStateCopyWith<DaftarNopState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DaftarNopStateCopyWith<$Res> {
  factory $DaftarNopStateCopyWith(
    DaftarNopState value,
    $Res Function(DaftarNopState) then,
  ) = _$DaftarNopStateCopyWithImpl<$Res, DaftarNopState>;
  @useResult
  $Res call({
    List<DaftarNopEntity> daftarNop,
    bool isLoading,
    bool isSaving,
    bool isSuccess,
    String errorMessage,
    double progress,
  });
}

/// @nodoc
class _$DaftarNopStateCopyWithImpl<$Res, $Val extends DaftarNopState>
    implements $DaftarNopStateCopyWith<$Res> {
  _$DaftarNopStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DaftarNopState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? daftarNop = null,
    Object? isLoading = null,
    Object? isSaving = null,
    Object? isSuccess = null,
    Object? errorMessage = null,
    Object? progress = null,
  }) {
    return _then(
      _value.copyWith(
            daftarNop: null == daftarNop
                ? _value.daftarNop
                : daftarNop // ignore: cast_nullable_to_non_nullable
                      as List<DaftarNopEntity>,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            isSaving: null == isSaving
                ? _value.isSaving
                : isSaving // ignore: cast_nullable_to_non_nullable
                      as bool,
            isSuccess: null == isSuccess
                ? _value.isSuccess
                : isSuccess // ignore: cast_nullable_to_non_nullable
                      as bool,
            errorMessage: null == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String,
            progress: null == progress
                ? _value.progress
                : progress // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DaftarNopStateImplCopyWith<$Res>
    implements $DaftarNopStateCopyWith<$Res> {
  factory _$$DaftarNopStateImplCopyWith(
    _$DaftarNopStateImpl value,
    $Res Function(_$DaftarNopStateImpl) then,
  ) = __$$DaftarNopStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<DaftarNopEntity> daftarNop,
    bool isLoading,
    bool isSaving,
    bool isSuccess,
    String errorMessage,
    double progress,
  });
}

/// @nodoc
class __$$DaftarNopStateImplCopyWithImpl<$Res>
    extends _$DaftarNopStateCopyWithImpl<$Res, _$DaftarNopStateImpl>
    implements _$$DaftarNopStateImplCopyWith<$Res> {
  __$$DaftarNopStateImplCopyWithImpl(
    _$DaftarNopStateImpl _value,
    $Res Function(_$DaftarNopStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DaftarNopState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? daftarNop = null,
    Object? isLoading = null,
    Object? isSaving = null,
    Object? isSuccess = null,
    Object? errorMessage = null,
    Object? progress = null,
  }) {
    return _then(
      _$DaftarNopStateImpl(
        daftarNop: null == daftarNop
            ? _value._daftarNop
            : daftarNop // ignore: cast_nullable_to_non_nullable
                  as List<DaftarNopEntity>,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        isSaving: null == isSaving
            ? _value.isSaving
            : isSaving // ignore: cast_nullable_to_non_nullable
                  as bool,
        isSuccess: null == isSuccess
            ? _value.isSuccess
            : isSuccess // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: null == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String,
        progress: null == progress
            ? _value.progress
            : progress // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc

class _$DaftarNopStateImpl implements _DaftarNopState {
  const _$DaftarNopStateImpl({
    final List<DaftarNopEntity> daftarNop = const [],
    this.isLoading = false,
    this.isSaving = false,
    this.isSuccess = false,
    this.errorMessage = '',
    this.progress = 0.0,
  }) : _daftarNop = daftarNop;

  final List<DaftarNopEntity> _daftarNop;
  @override
  @JsonKey()
  List<DaftarNopEntity> get daftarNop {
    if (_daftarNop is EqualUnmodifiableListView) return _daftarNop;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_daftarNop);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isSaving;
  @override
  @JsonKey()
  final bool isSuccess;
  @override
  @JsonKey()
  final String errorMessage;

  /// 0.0 - 1.0
  @override
  @JsonKey()
  final double progress;

  @override
  String toString() {
    return 'DaftarNopState(daftarNop: $daftarNop, isLoading: $isLoading, isSaving: $isSaving, isSuccess: $isSuccess, errorMessage: $errorMessage, progress: $progress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DaftarNopStateImpl &&
            const DeepCollectionEquality().equals(
              other._daftarNop,
              _daftarNop,
            ) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.isSuccess, isSuccess) ||
                other.isSuccess == isSuccess) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.progress, progress) ||
                other.progress == progress));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_daftarNop),
    isLoading,
    isSaving,
    isSuccess,
    errorMessage,
    progress,
  );

  /// Create a copy of DaftarNopState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DaftarNopStateImplCopyWith<_$DaftarNopStateImpl> get copyWith =>
      __$$DaftarNopStateImplCopyWithImpl<_$DaftarNopStateImpl>(
        this,
        _$identity,
      );
}

abstract class _DaftarNopState implements DaftarNopState {
  const factory _DaftarNopState({
    final List<DaftarNopEntity> daftarNop,
    final bool isLoading,
    final bool isSaving,
    final bool isSuccess,
    final String errorMessage,
    final double progress,
  }) = _$DaftarNopStateImpl;

  @override
  List<DaftarNopEntity> get daftarNop;
  @override
  bool get isLoading;
  @override
  bool get isSaving;
  @override
  bool get isSuccess;
  @override
  String get errorMessage;

  /// 0.0 - 1.0
  @override
  double get progress;

  /// Create a copy of DaftarNopState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DaftarNopStateImplCopyWith<_$DaftarNopStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
