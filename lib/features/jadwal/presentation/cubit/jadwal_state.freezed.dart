// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'jadwal_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$JadwalState {
  JadwalStatus get status => throw _privateConstructorUsedError;
  List<JadwalEntity>? get jadwal => throw _privateConstructorUsedError;
  List<JadwalEntity>? get jadwalFake => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;

  /// Create a copy of JadwalState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JadwalStateCopyWith<JadwalState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JadwalStateCopyWith<$Res> {
  factory $JadwalStateCopyWith(
    JadwalState value,
    $Res Function(JadwalState) then,
  ) = _$JadwalStateCopyWithImpl<$Res, JadwalState>;
  @useResult
  $Res call({
    JadwalStatus status,
    List<JadwalEntity>? jadwal,
    List<JadwalEntity>? jadwalFake,
    String message,
  });
}

/// @nodoc
class _$JadwalStateCopyWithImpl<$Res, $Val extends JadwalState>
    implements $JadwalStateCopyWith<$Res> {
  _$JadwalStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JadwalState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? jadwal = freezed,
    Object? jadwalFake = freezed,
    Object? message = null,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as JadwalStatus,
            jadwal: freezed == jadwal
                ? _value.jadwal
                : jadwal // ignore: cast_nullable_to_non_nullable
                      as List<JadwalEntity>?,
            jadwalFake: freezed == jadwalFake
                ? _value.jadwalFake
                : jadwalFake // ignore: cast_nullable_to_non_nullable
                      as List<JadwalEntity>?,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$JadwalStateImplCopyWith<$Res>
    implements $JadwalStateCopyWith<$Res> {
  factory _$$JadwalStateImplCopyWith(
    _$JadwalStateImpl value,
    $Res Function(_$JadwalStateImpl) then,
  ) = __$$JadwalStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    JadwalStatus status,
    List<JadwalEntity>? jadwal,
    List<JadwalEntity>? jadwalFake,
    String message,
  });
}

/// @nodoc
class __$$JadwalStateImplCopyWithImpl<$Res>
    extends _$JadwalStateCopyWithImpl<$Res, _$JadwalStateImpl>
    implements _$$JadwalStateImplCopyWith<$Res> {
  __$$JadwalStateImplCopyWithImpl(
    _$JadwalStateImpl _value,
    $Res Function(_$JadwalStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JadwalState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? jadwal = freezed,
    Object? jadwalFake = freezed,
    Object? message = null,
  }) {
    return _then(
      _$JadwalStateImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as JadwalStatus,
        jadwal: freezed == jadwal
            ? _value._jadwal
            : jadwal // ignore: cast_nullable_to_non_nullable
                  as List<JadwalEntity>?,
        jadwalFake: freezed == jadwalFake
            ? _value._jadwalFake
            : jadwalFake // ignore: cast_nullable_to_non_nullable
                  as List<JadwalEntity>?,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$JadwalStateImpl implements _JadwalState {
  const _$JadwalStateImpl({
    this.status = JadwalStatus.initial,
    final List<JadwalEntity>? jadwal,
    final List<JadwalEntity>? jadwalFake,
    this.message = '',
  }) : _jadwal = jadwal,
       _jadwalFake = jadwalFake;

  @override
  @JsonKey()
  final JadwalStatus status;
  final List<JadwalEntity>? _jadwal;
  @override
  List<JadwalEntity>? get jadwal {
    final value = _jadwal;
    if (value == null) return null;
    if (_jadwal is EqualUnmodifiableListView) return _jadwal;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<JadwalEntity>? _jadwalFake;
  @override
  List<JadwalEntity>? get jadwalFake {
    final value = _jadwalFake;
    if (value == null) return null;
    if (_jadwalFake is EqualUnmodifiableListView) return _jadwalFake;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final String message;

  @override
  String toString() {
    return 'JadwalState(status: $status, jadwal: $jadwal, jadwalFake: $jadwalFake, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JadwalStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._jadwal, _jadwal) &&
            const DeepCollectionEquality().equals(
              other._jadwalFake,
              _jadwalFake,
            ) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    const DeepCollectionEquality().hash(_jadwal),
    const DeepCollectionEquality().hash(_jadwalFake),
    message,
  );

  /// Create a copy of JadwalState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JadwalStateImplCopyWith<_$JadwalStateImpl> get copyWith =>
      __$$JadwalStateImplCopyWithImpl<_$JadwalStateImpl>(this, _$identity);
}

abstract class _JadwalState implements JadwalState {
  const factory _JadwalState({
    final JadwalStatus status,
    final List<JadwalEntity>? jadwal,
    final List<JadwalEntity>? jadwalFake,
    final String message,
  }) = _$JadwalStateImpl;

  @override
  JadwalStatus get status;
  @override
  List<JadwalEntity>? get jadwal;
  @override
  List<JadwalEntity>? get jadwalFake;
  @override
  String get message;

  /// Create a copy of JadwalState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JadwalStateImplCopyWith<_$JadwalStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
