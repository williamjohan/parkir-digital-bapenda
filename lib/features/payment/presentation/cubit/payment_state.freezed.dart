// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PaymentState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String qrisImagePath, String kodeQris)
    localQrisReady,
    required TResult Function(String rawQrisString) demoQrisReady,
    required TResult Function(String message) error,
    required TResult Function() paymentSuccess,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String qrisImagePath, String kodeQris)? localQrisReady,
    TResult? Function(String rawQrisString)? demoQrisReady,
    TResult? Function(String message)? error,
    TResult? Function()? paymentSuccess,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String qrisImagePath, String kodeQris)? localQrisReady,
    TResult Function(String rawQrisString)? demoQrisReady,
    TResult Function(String message)? error,
    TResult Function()? paymentSuccess,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_LocalQrisReady value) localQrisReady,
    required TResult Function(_DemoQrisReady value) demoQrisReady,
    required TResult Function(_Error value) error,
    required TResult Function(_PaymentSuccess value) paymentSuccess,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_LocalQrisReady value)? localQrisReady,
    TResult? Function(_DemoQrisReady value)? demoQrisReady,
    TResult? Function(_Error value)? error,
    TResult? Function(_PaymentSuccess value)? paymentSuccess,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_LocalQrisReady value)? localQrisReady,
    TResult Function(_DemoQrisReady value)? demoQrisReady,
    TResult Function(_Error value)? error,
    TResult Function(_PaymentSuccess value)? paymentSuccess,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentStateCopyWith<$Res> {
  factory $PaymentStateCopyWith(
    PaymentState value,
    $Res Function(PaymentState) then,
  ) = _$PaymentStateCopyWithImpl<$Res, PaymentState>;
}

/// @nodoc
class _$PaymentStateCopyWithImpl<$Res, $Val extends PaymentState>
    implements $PaymentStateCopyWith<$Res> {
  _$PaymentStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
    _$InitialImpl value,
    $Res Function(_$InitialImpl) then,
  ) = __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$PaymentStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
    _$InitialImpl _value,
    $Res Function(_$InitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'PaymentState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String qrisImagePath, String kodeQris)
    localQrisReady,
    required TResult Function(String rawQrisString) demoQrisReady,
    required TResult Function(String message) error,
    required TResult Function() paymentSuccess,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String qrisImagePath, String kodeQris)? localQrisReady,
    TResult? Function(String rawQrisString)? demoQrisReady,
    TResult? Function(String message)? error,
    TResult? Function()? paymentSuccess,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String qrisImagePath, String kodeQris)? localQrisReady,
    TResult Function(String rawQrisString)? demoQrisReady,
    TResult Function(String message)? error,
    TResult Function()? paymentSuccess,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_LocalQrisReady value) localQrisReady,
    required TResult Function(_DemoQrisReady value) demoQrisReady,
    required TResult Function(_Error value) error,
    required TResult Function(_PaymentSuccess value) paymentSuccess,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_LocalQrisReady value)? localQrisReady,
    TResult? Function(_DemoQrisReady value)? demoQrisReady,
    TResult? Function(_Error value)? error,
    TResult? Function(_PaymentSuccess value)? paymentSuccess,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_LocalQrisReady value)? localQrisReady,
    TResult Function(_DemoQrisReady value)? demoQrisReady,
    TResult Function(_Error value)? error,
    TResult Function(_PaymentSuccess value)? paymentSuccess,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements PaymentState {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<$Res> {
  factory _$$LoadingImplCopyWith(
    _$LoadingImpl value,
    $Res Function(_$LoadingImpl) then,
  ) = __$$LoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<$Res>
    extends _$PaymentStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
    _$LoadingImpl _value,
    $Res Function(_$LoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingImpl implements _Loading {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'PaymentState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String qrisImagePath, String kodeQris)
    localQrisReady,
    required TResult Function(String rawQrisString) demoQrisReady,
    required TResult Function(String message) error,
    required TResult Function() paymentSuccess,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String qrisImagePath, String kodeQris)? localQrisReady,
    TResult? Function(String rawQrisString)? demoQrisReady,
    TResult? Function(String message)? error,
    TResult? Function()? paymentSuccess,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String qrisImagePath, String kodeQris)? localQrisReady,
    TResult Function(String rawQrisString)? demoQrisReady,
    TResult Function(String message)? error,
    TResult Function()? paymentSuccess,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_LocalQrisReady value) localQrisReady,
    required TResult Function(_DemoQrisReady value) demoQrisReady,
    required TResult Function(_Error value) error,
    required TResult Function(_PaymentSuccess value) paymentSuccess,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_LocalQrisReady value)? localQrisReady,
    TResult? Function(_DemoQrisReady value)? demoQrisReady,
    TResult? Function(_Error value)? error,
    TResult? Function(_PaymentSuccess value)? paymentSuccess,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_LocalQrisReady value)? localQrisReady,
    TResult Function(_DemoQrisReady value)? demoQrisReady,
    TResult Function(_Error value)? error,
    TResult Function(_PaymentSuccess value)? paymentSuccess,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading implements PaymentState {
  const factory _Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$LocalQrisReadyImplCopyWith<$Res> {
  factory _$$LocalQrisReadyImplCopyWith(
    _$LocalQrisReadyImpl value,
    $Res Function(_$LocalQrisReadyImpl) then,
  ) = __$$LocalQrisReadyImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String qrisImagePath, String kodeQris});
}

/// @nodoc
class __$$LocalQrisReadyImplCopyWithImpl<$Res>
    extends _$PaymentStateCopyWithImpl<$Res, _$LocalQrisReadyImpl>
    implements _$$LocalQrisReadyImplCopyWith<$Res> {
  __$$LocalQrisReadyImplCopyWithImpl(
    _$LocalQrisReadyImpl _value,
    $Res Function(_$LocalQrisReadyImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? qrisImagePath = null, Object? kodeQris = null}) {
    return _then(
      _$LocalQrisReadyImpl(
        qrisImagePath: null == qrisImagePath
            ? _value.qrisImagePath
            : qrisImagePath // ignore: cast_nullable_to_non_nullable
                  as String,
        kodeQris: null == kodeQris
            ? _value.kodeQris
            : kodeQris // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$LocalQrisReadyImpl implements _LocalQrisReady {
  const _$LocalQrisReadyImpl({
    required this.qrisImagePath,
    required this.kodeQris,
  });

  @override
  final String qrisImagePath;
  @override
  final String kodeQris;

  @override
  String toString() {
    return 'PaymentState.localQrisReady(qrisImagePath: $qrisImagePath, kodeQris: $kodeQris)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocalQrisReadyImpl &&
            (identical(other.qrisImagePath, qrisImagePath) ||
                other.qrisImagePath == qrisImagePath) &&
            (identical(other.kodeQris, kodeQris) ||
                other.kodeQris == kodeQris));
  }

  @override
  int get hashCode => Object.hash(runtimeType, qrisImagePath, kodeQris);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocalQrisReadyImplCopyWith<_$LocalQrisReadyImpl> get copyWith =>
      __$$LocalQrisReadyImplCopyWithImpl<_$LocalQrisReadyImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String qrisImagePath, String kodeQris)
    localQrisReady,
    required TResult Function(String rawQrisString) demoQrisReady,
    required TResult Function(String message) error,
    required TResult Function() paymentSuccess,
  }) {
    return localQrisReady(qrisImagePath, kodeQris);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String qrisImagePath, String kodeQris)? localQrisReady,
    TResult? Function(String rawQrisString)? demoQrisReady,
    TResult? Function(String message)? error,
    TResult? Function()? paymentSuccess,
  }) {
    return localQrisReady?.call(qrisImagePath, kodeQris);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String qrisImagePath, String kodeQris)? localQrisReady,
    TResult Function(String rawQrisString)? demoQrisReady,
    TResult Function(String message)? error,
    TResult Function()? paymentSuccess,
    required TResult orElse(),
  }) {
    if (localQrisReady != null) {
      return localQrisReady(qrisImagePath, kodeQris);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_LocalQrisReady value) localQrisReady,
    required TResult Function(_DemoQrisReady value) demoQrisReady,
    required TResult Function(_Error value) error,
    required TResult Function(_PaymentSuccess value) paymentSuccess,
  }) {
    return localQrisReady(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_LocalQrisReady value)? localQrisReady,
    TResult? Function(_DemoQrisReady value)? demoQrisReady,
    TResult? Function(_Error value)? error,
    TResult? Function(_PaymentSuccess value)? paymentSuccess,
  }) {
    return localQrisReady?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_LocalQrisReady value)? localQrisReady,
    TResult Function(_DemoQrisReady value)? demoQrisReady,
    TResult Function(_Error value)? error,
    TResult Function(_PaymentSuccess value)? paymentSuccess,
    required TResult orElse(),
  }) {
    if (localQrisReady != null) {
      return localQrisReady(this);
    }
    return orElse();
  }
}

abstract class _LocalQrisReady implements PaymentState {
  const factory _LocalQrisReady({
    required final String qrisImagePath,
    required final String kodeQris,
  }) = _$LocalQrisReadyImpl;

  String get qrisImagePath;
  String get kodeQris;

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocalQrisReadyImplCopyWith<_$LocalQrisReadyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DemoQrisReadyImplCopyWith<$Res> {
  factory _$$DemoQrisReadyImplCopyWith(
    _$DemoQrisReadyImpl value,
    $Res Function(_$DemoQrisReadyImpl) then,
  ) = __$$DemoQrisReadyImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String rawQrisString});
}

/// @nodoc
class __$$DemoQrisReadyImplCopyWithImpl<$Res>
    extends _$PaymentStateCopyWithImpl<$Res, _$DemoQrisReadyImpl>
    implements _$$DemoQrisReadyImplCopyWith<$Res> {
  __$$DemoQrisReadyImplCopyWithImpl(
    _$DemoQrisReadyImpl _value,
    $Res Function(_$DemoQrisReadyImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? rawQrisString = null}) {
    return _then(
      _$DemoQrisReadyImpl(
        rawQrisString: null == rawQrisString
            ? _value.rawQrisString
            : rawQrisString // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$DemoQrisReadyImpl implements _DemoQrisReady {
  const _$DemoQrisReadyImpl({required this.rawQrisString});

  @override
  final String rawQrisString;

  @override
  String toString() {
    return 'PaymentState.demoQrisReady(rawQrisString: $rawQrisString)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DemoQrisReadyImpl &&
            (identical(other.rawQrisString, rawQrisString) ||
                other.rawQrisString == rawQrisString));
  }

  @override
  int get hashCode => Object.hash(runtimeType, rawQrisString);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DemoQrisReadyImplCopyWith<_$DemoQrisReadyImpl> get copyWith =>
      __$$DemoQrisReadyImplCopyWithImpl<_$DemoQrisReadyImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String qrisImagePath, String kodeQris)
    localQrisReady,
    required TResult Function(String rawQrisString) demoQrisReady,
    required TResult Function(String message) error,
    required TResult Function() paymentSuccess,
  }) {
    return demoQrisReady(rawQrisString);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String qrisImagePath, String kodeQris)? localQrisReady,
    TResult? Function(String rawQrisString)? demoQrisReady,
    TResult? Function(String message)? error,
    TResult? Function()? paymentSuccess,
  }) {
    return demoQrisReady?.call(rawQrisString);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String qrisImagePath, String kodeQris)? localQrisReady,
    TResult Function(String rawQrisString)? demoQrisReady,
    TResult Function(String message)? error,
    TResult Function()? paymentSuccess,
    required TResult orElse(),
  }) {
    if (demoQrisReady != null) {
      return demoQrisReady(rawQrisString);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_LocalQrisReady value) localQrisReady,
    required TResult Function(_DemoQrisReady value) demoQrisReady,
    required TResult Function(_Error value) error,
    required TResult Function(_PaymentSuccess value) paymentSuccess,
  }) {
    return demoQrisReady(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_LocalQrisReady value)? localQrisReady,
    TResult? Function(_DemoQrisReady value)? demoQrisReady,
    TResult? Function(_Error value)? error,
    TResult? Function(_PaymentSuccess value)? paymentSuccess,
  }) {
    return demoQrisReady?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_LocalQrisReady value)? localQrisReady,
    TResult Function(_DemoQrisReady value)? demoQrisReady,
    TResult Function(_Error value)? error,
    TResult Function(_PaymentSuccess value)? paymentSuccess,
    required TResult orElse(),
  }) {
    if (demoQrisReady != null) {
      return demoQrisReady(this);
    }
    return orElse();
  }
}

abstract class _DemoQrisReady implements PaymentState {
  const factory _DemoQrisReady({required final String rawQrisString}) =
      _$DemoQrisReadyImpl;

  String get rawQrisString;

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DemoQrisReadyImplCopyWith<_$DemoQrisReadyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
    _$ErrorImpl value,
    $Res Function(_$ErrorImpl) then,
  ) = __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$PaymentStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
    _$ErrorImpl _value,
    $Res Function(_$ErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$ErrorImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ErrorImpl implements _Error {
  const _$ErrorImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'PaymentState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String qrisImagePath, String kodeQris)
    localQrisReady,
    required TResult Function(String rawQrisString) demoQrisReady,
    required TResult Function(String message) error,
    required TResult Function() paymentSuccess,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String qrisImagePath, String kodeQris)? localQrisReady,
    TResult? Function(String rawQrisString)? demoQrisReady,
    TResult? Function(String message)? error,
    TResult? Function()? paymentSuccess,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String qrisImagePath, String kodeQris)? localQrisReady,
    TResult Function(String rawQrisString)? demoQrisReady,
    TResult Function(String message)? error,
    TResult Function()? paymentSuccess,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_LocalQrisReady value) localQrisReady,
    required TResult Function(_DemoQrisReady value) demoQrisReady,
    required TResult Function(_Error value) error,
    required TResult Function(_PaymentSuccess value) paymentSuccess,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_LocalQrisReady value)? localQrisReady,
    TResult? Function(_DemoQrisReady value)? demoQrisReady,
    TResult? Function(_Error value)? error,
    TResult? Function(_PaymentSuccess value)? paymentSuccess,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_LocalQrisReady value)? localQrisReady,
    TResult Function(_DemoQrisReady value)? demoQrisReady,
    TResult Function(_Error value)? error,
    TResult Function(_PaymentSuccess value)? paymentSuccess,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements PaymentState {
  const factory _Error({required final String message}) = _$ErrorImpl;

  String get message;

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PaymentSuccessImplCopyWith<$Res> {
  factory _$$PaymentSuccessImplCopyWith(
    _$PaymentSuccessImpl value,
    $Res Function(_$PaymentSuccessImpl) then,
  ) = __$$PaymentSuccessImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PaymentSuccessImplCopyWithImpl<$Res>
    extends _$PaymentStateCopyWithImpl<$Res, _$PaymentSuccessImpl>
    implements _$$PaymentSuccessImplCopyWith<$Res> {
  __$$PaymentSuccessImplCopyWithImpl(
    _$PaymentSuccessImpl _value,
    $Res Function(_$PaymentSuccessImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PaymentSuccessImpl implements _PaymentSuccess {
  const _$PaymentSuccessImpl();

  @override
  String toString() {
    return 'PaymentState.paymentSuccess()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$PaymentSuccessImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String qrisImagePath, String kodeQris)
    localQrisReady,
    required TResult Function(String rawQrisString) demoQrisReady,
    required TResult Function(String message) error,
    required TResult Function() paymentSuccess,
  }) {
    return paymentSuccess();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String qrisImagePath, String kodeQris)? localQrisReady,
    TResult? Function(String rawQrisString)? demoQrisReady,
    TResult? Function(String message)? error,
    TResult? Function()? paymentSuccess,
  }) {
    return paymentSuccess?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String qrisImagePath, String kodeQris)? localQrisReady,
    TResult Function(String rawQrisString)? demoQrisReady,
    TResult Function(String message)? error,
    TResult Function()? paymentSuccess,
    required TResult orElse(),
  }) {
    if (paymentSuccess != null) {
      return paymentSuccess();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_LocalQrisReady value) localQrisReady,
    required TResult Function(_DemoQrisReady value) demoQrisReady,
    required TResult Function(_Error value) error,
    required TResult Function(_PaymentSuccess value) paymentSuccess,
  }) {
    return paymentSuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_LocalQrisReady value)? localQrisReady,
    TResult? Function(_DemoQrisReady value)? demoQrisReady,
    TResult? Function(_Error value)? error,
    TResult? Function(_PaymentSuccess value)? paymentSuccess,
  }) {
    return paymentSuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_LocalQrisReady value)? localQrisReady,
    TResult Function(_DemoQrisReady value)? demoQrisReady,
    TResult Function(_Error value)? error,
    TResult Function(_PaymentSuccess value)? paymentSuccess,
    required TResult orElse(),
  }) {
    if (paymentSuccess != null) {
      return paymentSuccess(this);
    }
    return orElse();
  }
}

abstract class _PaymentSuccess implements PaymentState {
  const factory _PaymentSuccess() = _$PaymentSuccessImpl;
}
