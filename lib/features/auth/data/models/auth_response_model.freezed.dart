// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AuthResponseModel _$AuthResponseModelFromJson(Map<String, dynamic> json) {
  return _AuthResponseModel.fromJson(json);
}

/// @nodoc
mixin _$AuthResponseModel {
  String get accessToken => throw _privateConstructorUsedError;
  String get refreshToken => throw _privateConstructorUsedError;
  String get nop => throw _privateConstructorUsedError;
  String get uuidStatic => throw _privateConstructorUsedError;
  int get roleLoginId => throw _privateConstructorUsedError;
  List<NopModel> get nopList => throw _privateConstructorUsedError;

  /// Serializes this AuthResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthResponseModelCopyWith<AuthResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthResponseModelCopyWith<$Res> {
  factory $AuthResponseModelCopyWith(
    AuthResponseModel value,
    $Res Function(AuthResponseModel) then,
  ) = _$AuthResponseModelCopyWithImpl<$Res, AuthResponseModel>;
  @useResult
  $Res call({
    String accessToken,
    String refreshToken,
    String nop,
    String uuidStatic,
    int roleLoginId,
    List<NopModel> nopList,
  });
}

/// @nodoc
class _$AuthResponseModelCopyWithImpl<$Res, $Val extends AuthResponseModel>
    implements $AuthResponseModelCopyWith<$Res> {
  _$AuthResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? nop = null,
    Object? uuidStatic = null,
    Object? roleLoginId = null,
    Object? nopList = null,
  }) {
    return _then(
      _value.copyWith(
            accessToken: null == accessToken
                ? _value.accessToken
                : accessToken // ignore: cast_nullable_to_non_nullable
                      as String,
            refreshToken: null == refreshToken
                ? _value.refreshToken
                : refreshToken // ignore: cast_nullable_to_non_nullable
                      as String,
            nop: null == nop
                ? _value.nop
                : nop // ignore: cast_nullable_to_non_nullable
                      as String,
            uuidStatic: null == uuidStatic
                ? _value.uuidStatic
                : uuidStatic // ignore: cast_nullable_to_non_nullable
                      as String,
            roleLoginId: null == roleLoginId
                ? _value.roleLoginId
                : roleLoginId // ignore: cast_nullable_to_non_nullable
                      as int,
            nopList: null == nopList
                ? _value.nopList
                : nopList // ignore: cast_nullable_to_non_nullable
                      as List<NopModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AuthResponseModelImplCopyWith<$Res>
    implements $AuthResponseModelCopyWith<$Res> {
  factory _$$AuthResponseModelImplCopyWith(
    _$AuthResponseModelImpl value,
    $Res Function(_$AuthResponseModelImpl) then,
  ) = __$$AuthResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String accessToken,
    String refreshToken,
    String nop,
    String uuidStatic,
    int roleLoginId,
    List<NopModel> nopList,
  });
}

/// @nodoc
class __$$AuthResponseModelImplCopyWithImpl<$Res>
    extends _$AuthResponseModelCopyWithImpl<$Res, _$AuthResponseModelImpl>
    implements _$$AuthResponseModelImplCopyWith<$Res> {
  __$$AuthResponseModelImplCopyWithImpl(
    _$AuthResponseModelImpl _value,
    $Res Function(_$AuthResponseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? nop = null,
    Object? uuidStatic = null,
    Object? roleLoginId = null,
    Object? nopList = null,
  }) {
    return _then(
      _$AuthResponseModelImpl(
        accessToken: null == accessToken
            ? _value.accessToken
            : accessToken // ignore: cast_nullable_to_non_nullable
                  as String,
        refreshToken: null == refreshToken
            ? _value.refreshToken
            : refreshToken // ignore: cast_nullable_to_non_nullable
                  as String,
        nop: null == nop
            ? _value.nop
            : nop // ignore: cast_nullable_to_non_nullable
                  as String,
        uuidStatic: null == uuidStatic
            ? _value.uuidStatic
            : uuidStatic // ignore: cast_nullable_to_non_nullable
                  as String,
        roleLoginId: null == roleLoginId
            ? _value.roleLoginId
            : roleLoginId // ignore: cast_nullable_to_non_nullable
                  as int,
        nopList: null == nopList
            ? _value._nopList
            : nopList // ignore: cast_nullable_to_non_nullable
                  as List<NopModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthResponseModelImpl implements _AuthResponseModel {
  const _$AuthResponseModelImpl({
    this.accessToken = '',
    this.refreshToken = '',
    this.nop = '',
    this.uuidStatic = '',
    this.roleLoginId = 0,
    final List<NopModel> nopList = const [],
  }) : _nopList = nopList;

  factory _$AuthResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthResponseModelImplFromJson(json);

  @override
  @JsonKey()
  final String accessToken;
  @override
  @JsonKey()
  final String refreshToken;
  @override
  @JsonKey()
  final String nop;
  @override
  @JsonKey()
  final String uuidStatic;
  @override
  @JsonKey()
  final int roleLoginId;
  final List<NopModel> _nopList;
  @override
  @JsonKey()
  List<NopModel> get nopList {
    if (_nopList is EqualUnmodifiableListView) return _nopList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nopList);
  }

  @override
  String toString() {
    return 'AuthResponseModel(accessToken: $accessToken, refreshToken: $refreshToken, nop: $nop, uuidStatic: $uuidStatic, roleLoginId: $roleLoginId, nopList: $nopList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthResponseModelImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.nop, nop) || other.nop == nop) &&
            (identical(other.uuidStatic, uuidStatic) ||
                other.uuidStatic == uuidStatic) &&
            (identical(other.roleLoginId, roleLoginId) ||
                other.roleLoginId == roleLoginId) &&
            const DeepCollectionEquality().equals(other._nopList, _nopList));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    accessToken,
    refreshToken,
    nop,
    uuidStatic,
    roleLoginId,
    const DeepCollectionEquality().hash(_nopList),
  );

  /// Create a copy of AuthResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthResponseModelImplCopyWith<_$AuthResponseModelImpl> get copyWith =>
      __$$AuthResponseModelImplCopyWithImpl<_$AuthResponseModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthResponseModelImplToJson(this);
  }
}

abstract class _AuthResponseModel implements AuthResponseModel {
  const factory _AuthResponseModel({
    final String accessToken,
    final String refreshToken,
    final String nop,
    final String uuidStatic,
    final int roleLoginId,
    final List<NopModel> nopList,
  }) = _$AuthResponseModelImpl;

  factory _AuthResponseModel.fromJson(Map<String, dynamic> json) =
      _$AuthResponseModelImpl.fromJson;

  @override
  String get accessToken;
  @override
  String get refreshToken;
  @override
  String get nop;
  @override
  String get uuidStatic;
  @override
  int get roleLoginId;
  @override
  List<NopModel> get nopList;

  /// Create a copy of AuthResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthResponseModelImplCopyWith<_$AuthResponseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NopModel _$NopModelFromJson(Map<String, dynamic> json) {
  return _NopModel.fromJson(json);
}

/// @nodoc
mixin _$NopModel {
  String get nop => throw _privateConstructorUsedError;
  String get namaOp => throw _privateConstructorUsedError;
  String get alamatOp => throw _privateConstructorUsedError;
  bool get isDigital => throw _privateConstructorUsedError;

  /// Serializes this NopModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NopModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NopModelCopyWith<NopModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NopModelCopyWith<$Res> {
  factory $NopModelCopyWith(NopModel value, $Res Function(NopModel) then) =
      _$NopModelCopyWithImpl<$Res, NopModel>;
  @useResult
  $Res call({String nop, String namaOp, String alamatOp, bool isDigital});
}

/// @nodoc
class _$NopModelCopyWithImpl<$Res, $Val extends NopModel>
    implements $NopModelCopyWith<$Res> {
  _$NopModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NopModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nop = null,
    Object? namaOp = null,
    Object? alamatOp = null,
    Object? isDigital = null,
  }) {
    return _then(
      _value.copyWith(
            nop: null == nop
                ? _value.nop
                : nop // ignore: cast_nullable_to_non_nullable
                      as String,
            namaOp: null == namaOp
                ? _value.namaOp
                : namaOp // ignore: cast_nullable_to_non_nullable
                      as String,
            alamatOp: null == alamatOp
                ? _value.alamatOp
                : alamatOp // ignore: cast_nullable_to_non_nullable
                      as String,
            isDigital: null == isDigital
                ? _value.isDigital
                : isDigital // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NopModelImplCopyWith<$Res>
    implements $NopModelCopyWith<$Res> {
  factory _$$NopModelImplCopyWith(
    _$NopModelImpl value,
    $Res Function(_$NopModelImpl) then,
  ) = __$$NopModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String nop, String namaOp, String alamatOp, bool isDigital});
}

/// @nodoc
class __$$NopModelImplCopyWithImpl<$Res>
    extends _$NopModelCopyWithImpl<$Res, _$NopModelImpl>
    implements _$$NopModelImplCopyWith<$Res> {
  __$$NopModelImplCopyWithImpl(
    _$NopModelImpl _value,
    $Res Function(_$NopModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NopModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nop = null,
    Object? namaOp = null,
    Object? alamatOp = null,
    Object? isDigital = null,
  }) {
    return _then(
      _$NopModelImpl(
        nop: null == nop
            ? _value.nop
            : nop // ignore: cast_nullable_to_non_nullable
                  as String,
        namaOp: null == namaOp
            ? _value.namaOp
            : namaOp // ignore: cast_nullable_to_non_nullable
                  as String,
        alamatOp: null == alamatOp
            ? _value.alamatOp
            : alamatOp // ignore: cast_nullable_to_non_nullable
                  as String,
        isDigital: null == isDigital
            ? _value.isDigital
            : isDigital // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NopModelImpl implements _NopModel {
  const _$NopModelImpl({
    this.nop = '',
    this.namaOp = '',
    this.alamatOp = '',
    this.isDigital = false,
  });

  factory _$NopModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NopModelImplFromJson(json);

  @override
  @JsonKey()
  final String nop;
  @override
  @JsonKey()
  final String namaOp;
  @override
  @JsonKey()
  final String alamatOp;
  @override
  @JsonKey()
  final bool isDigital;

  @override
  String toString() {
    return 'NopModel(nop: $nop, namaOp: $namaOp, alamatOp: $alamatOp, isDigital: $isDigital)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NopModelImpl &&
            (identical(other.nop, nop) || other.nop == nop) &&
            (identical(other.namaOp, namaOp) || other.namaOp == namaOp) &&
            (identical(other.alamatOp, alamatOp) ||
                other.alamatOp == alamatOp) &&
            (identical(other.isDigital, isDigital) ||
                other.isDigital == isDigital));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, nop, namaOp, alamatOp, isDigital);

  /// Create a copy of NopModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NopModelImplCopyWith<_$NopModelImpl> get copyWith =>
      __$$NopModelImplCopyWithImpl<_$NopModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NopModelImplToJson(this);
  }
}

abstract class _NopModel implements NopModel {
  const factory _NopModel({
    final String nop,
    final String namaOp,
    final String alamatOp,
    final bool isDigital,
  }) = _$NopModelImpl;

  factory _NopModel.fromJson(Map<String, dynamic> json) =
      _$NopModelImpl.fromJson;

  @override
  String get nop;
  @override
  String get namaOp;
  @override
  String get alamatOp;
  @override
  bool get isDigital;

  /// Create a copy of NopModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NopModelImplCopyWith<_$NopModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
