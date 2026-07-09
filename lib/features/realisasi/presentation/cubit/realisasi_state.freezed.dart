// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'realisasi_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$RealisasiState {
  int get selectedYear => throw _privateConstructorUsedError;
  int get currentYear => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  List<RealisasiEntity> get data => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of RealisasiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RealisasiStateCopyWith<RealisasiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RealisasiStateCopyWith<$Res> {
  factory $RealisasiStateCopyWith(
    RealisasiState value,
    $Res Function(RealisasiState) then,
  ) = _$RealisasiStateCopyWithImpl<$Res, RealisasiState>;
  @useResult
  $Res call({
    int selectedYear,
    int currentYear,
    bool isLoading,
    List<RealisasiEntity> data,
    String? errorMessage,
  });
}

/// @nodoc
class _$RealisasiStateCopyWithImpl<$Res, $Val extends RealisasiState>
    implements $RealisasiStateCopyWith<$Res> {
  _$RealisasiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RealisasiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedYear = null,
    Object? currentYear = null,
    Object? isLoading = null,
    Object? data = null,
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
            data: null == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as List<RealisasiEntity>,
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
abstract class _$$RealisasiStateImplCopyWith<$Res>
    implements $RealisasiStateCopyWith<$Res> {
  factory _$$RealisasiStateImplCopyWith(
    _$RealisasiStateImpl value,
    $Res Function(_$RealisasiStateImpl) then,
  ) = __$$RealisasiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int selectedYear,
    int currentYear,
    bool isLoading,
    List<RealisasiEntity> data,
    String? errorMessage,
  });
}

/// @nodoc
class __$$RealisasiStateImplCopyWithImpl<$Res>
    extends _$RealisasiStateCopyWithImpl<$Res, _$RealisasiStateImpl>
    implements _$$RealisasiStateImplCopyWith<$Res> {
  __$$RealisasiStateImplCopyWithImpl(
    _$RealisasiStateImpl _value,
    $Res Function(_$RealisasiStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RealisasiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedYear = null,
    Object? currentYear = null,
    Object? isLoading = null,
    Object? data = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$RealisasiStateImpl(
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
        data: null == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as List<RealisasiEntity>,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$RealisasiStateImpl extends _RealisasiState {
  const _$RealisasiStateImpl({
    required this.selectedYear,
    required this.currentYear,
    this.isLoading = false,
    final List<RealisasiEntity> data = const [],
    this.errorMessage,
  }) : _data = data,
       super._();

  @override
  final int selectedYear;
  @override
  final int currentYear;
  @override
  @JsonKey()
  final bool isLoading;
  final List<RealisasiEntity> _data;
  @override
  @JsonKey()
  List<RealisasiEntity> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'RealisasiState(selectedYear: $selectedYear, currentYear: $currentYear, isLoading: $isLoading, data: $data, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RealisasiStateImpl &&
            (identical(other.selectedYear, selectedYear) ||
                other.selectedYear == selectedYear) &&
            (identical(other.currentYear, currentYear) ||
                other.currentYear == currentYear) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    selectedYear,
    currentYear,
    isLoading,
    const DeepCollectionEquality().hash(_data),
    errorMessage,
  );

  /// Create a copy of RealisasiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RealisasiStateImplCopyWith<_$RealisasiStateImpl> get copyWith =>
      __$$RealisasiStateImplCopyWithImpl<_$RealisasiStateImpl>(
        this,
        _$identity,
      );
}

abstract class _RealisasiState extends RealisasiState {
  const factory _RealisasiState({
    required final int selectedYear,
    required final int currentYear,
    final bool isLoading,
    final List<RealisasiEntity> data,
    final String? errorMessage,
  }) = _$RealisasiStateImpl;
  const _RealisasiState._() : super._();

  @override
  int get selectedYear;
  @override
  int get currentYear;
  @override
  bool get isLoading;
  @override
  List<RealisasiEntity> get data;
  @override
  String? get errorMessage;

  /// Create a copy of RealisasiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RealisasiStateImplCopyWith<_$RealisasiStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
