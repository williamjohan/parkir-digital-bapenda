// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'riwayat_absensi_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$RiwayatAbsensiState {
  JadwalStatus get status => throw _privateConstructorUsedError;
  List<RiwayatAbsensiEntity>? get jadwal => throw _privateConstructorUsedError;
  List<RiwayatAbsensiEntity>? get jadwalFake =>
      throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;

  /// Create a copy of RiwayatAbsensiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RiwayatAbsensiStateCopyWith<RiwayatAbsensiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RiwayatAbsensiStateCopyWith<$Res> {
  factory $RiwayatAbsensiStateCopyWith(
    RiwayatAbsensiState value,
    $Res Function(RiwayatAbsensiState) then,
  ) = _$RiwayatAbsensiStateCopyWithImpl<$Res, RiwayatAbsensiState>;
  @useResult
  $Res call({
    JadwalStatus status,
    List<RiwayatAbsensiEntity>? jadwal,
    List<RiwayatAbsensiEntity>? jadwalFake,
    String message,
  });
}

/// @nodoc
class _$RiwayatAbsensiStateCopyWithImpl<$Res, $Val extends RiwayatAbsensiState>
    implements $RiwayatAbsensiStateCopyWith<$Res> {
  _$RiwayatAbsensiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RiwayatAbsensiState
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
                      as List<RiwayatAbsensiEntity>?,
            jadwalFake: freezed == jadwalFake
                ? _value.jadwalFake
                : jadwalFake // ignore: cast_nullable_to_non_nullable
                      as List<RiwayatAbsensiEntity>?,
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
abstract class _$$RiwayatAbsensiStateImplCopyWith<$Res>
    implements $RiwayatAbsensiStateCopyWith<$Res> {
  factory _$$RiwayatAbsensiStateImplCopyWith(
    _$RiwayatAbsensiStateImpl value,
    $Res Function(_$RiwayatAbsensiStateImpl) then,
  ) = __$$RiwayatAbsensiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    JadwalStatus status,
    List<RiwayatAbsensiEntity>? jadwal,
    List<RiwayatAbsensiEntity>? jadwalFake,
    String message,
  });
}

/// @nodoc
class __$$RiwayatAbsensiStateImplCopyWithImpl<$Res>
    extends _$RiwayatAbsensiStateCopyWithImpl<$Res, _$RiwayatAbsensiStateImpl>
    implements _$$RiwayatAbsensiStateImplCopyWith<$Res> {
  __$$RiwayatAbsensiStateImplCopyWithImpl(
    _$RiwayatAbsensiStateImpl _value,
    $Res Function(_$RiwayatAbsensiStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RiwayatAbsensiState
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
      _$RiwayatAbsensiStateImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as JadwalStatus,
        jadwal: freezed == jadwal
            ? _value._jadwal
            : jadwal // ignore: cast_nullable_to_non_nullable
                  as List<RiwayatAbsensiEntity>?,
        jadwalFake: freezed == jadwalFake
            ? _value._jadwalFake
            : jadwalFake // ignore: cast_nullable_to_non_nullable
                  as List<RiwayatAbsensiEntity>?,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$RiwayatAbsensiStateImpl implements _RiwayatAbsensiState {
  const _$RiwayatAbsensiStateImpl({
    this.status = JadwalStatus.initial,
    final List<RiwayatAbsensiEntity>? jadwal,
    final List<RiwayatAbsensiEntity>? jadwalFake,
    this.message = '',
  }) : _jadwal = jadwal,
       _jadwalFake = jadwalFake;

  @override
  @JsonKey()
  final JadwalStatus status;
  final List<RiwayatAbsensiEntity>? _jadwal;
  @override
  List<RiwayatAbsensiEntity>? get jadwal {
    final value = _jadwal;
    if (value == null) return null;
    if (_jadwal is EqualUnmodifiableListView) return _jadwal;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<RiwayatAbsensiEntity>? _jadwalFake;
  @override
  List<RiwayatAbsensiEntity>? get jadwalFake {
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
    return 'RiwayatAbsensiState(status: $status, jadwal: $jadwal, jadwalFake: $jadwalFake, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RiwayatAbsensiStateImpl &&
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

  /// Create a copy of RiwayatAbsensiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RiwayatAbsensiStateImplCopyWith<_$RiwayatAbsensiStateImpl> get copyWith =>
      __$$RiwayatAbsensiStateImplCopyWithImpl<_$RiwayatAbsensiStateImpl>(
        this,
        _$identity,
      );
}

abstract class _RiwayatAbsensiState implements RiwayatAbsensiState {
  const factory _RiwayatAbsensiState({
    final JadwalStatus status,
    final List<RiwayatAbsensiEntity>? jadwal,
    final List<RiwayatAbsensiEntity>? jadwalFake,
    final String message,
  }) = _$RiwayatAbsensiStateImpl;

  @override
  JadwalStatus get status;
  @override
  List<RiwayatAbsensiEntity>? get jadwal;
  @override
  List<RiwayatAbsensiEntity>? get jadwalFake;
  @override
  String get message;

  /// Create a copy of RiwayatAbsensiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RiwayatAbsensiStateImplCopyWith<_$RiwayatAbsensiStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
