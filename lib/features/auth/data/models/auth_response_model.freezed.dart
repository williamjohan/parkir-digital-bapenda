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
  String get nop => throw _privateConstructorUsedError;
  String get uuidStatic => throw _privateConstructorUsedError;
  int get roleLoginId => throw _privateConstructorUsedError;
  int get pungutTarif => throw _privateConstructorUsedError;
  List<NopModel> get nopList => throw _privateConstructorUsedError;
  OpPengawasAuthModel? get opPengawas => throw _privateConstructorUsedError;
  String get lastUpdateOp => throw _privateConstructorUsedError;

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
    String nop,
    String uuidStatic,
    int roleLoginId,
    int pungutTarif,
    List<NopModel> nopList,
    OpPengawasAuthModel? opPengawas,
    String lastUpdateOp,
  });

  $OpPengawasAuthModelCopyWith<$Res>? get opPengawas;
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
    Object? nop = null,
    Object? uuidStatic = null,
    Object? roleLoginId = null,
    Object? pungutTarif = null,
    Object? nopList = null,
    Object? opPengawas = freezed,
    Object? lastUpdateOp = null,
  }) {
    return _then(
      _value.copyWith(
            accessToken: null == accessToken
                ? _value.accessToken
                : accessToken // ignore: cast_nullable_to_non_nullable
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
            pungutTarif: null == pungutTarif
                ? _value.pungutTarif
                : pungutTarif // ignore: cast_nullable_to_non_nullable
                      as int,
            nopList: null == nopList
                ? _value.nopList
                : nopList // ignore: cast_nullable_to_non_nullable
                      as List<NopModel>,
            opPengawas: freezed == opPengawas
                ? _value.opPengawas
                : opPengawas // ignore: cast_nullable_to_non_nullable
                      as OpPengawasAuthModel?,
            lastUpdateOp: null == lastUpdateOp
                ? _value.lastUpdateOp
                : lastUpdateOp // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }

  /// Create a copy of AuthResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OpPengawasAuthModelCopyWith<$Res>? get opPengawas {
    if (_value.opPengawas == null) {
      return null;
    }

    return $OpPengawasAuthModelCopyWith<$Res>(_value.opPengawas!, (value) {
      return _then(_value.copyWith(opPengawas: value) as $Val);
    });
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
    String nop,
    String uuidStatic,
    int roleLoginId,
    int pungutTarif,
    List<NopModel> nopList,
    OpPengawasAuthModel? opPengawas,
    String lastUpdateOp,
  });

  @override
  $OpPengawasAuthModelCopyWith<$Res>? get opPengawas;
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
    Object? nop = null,
    Object? uuidStatic = null,
    Object? roleLoginId = null,
    Object? pungutTarif = null,
    Object? nopList = null,
    Object? opPengawas = freezed,
    Object? lastUpdateOp = null,
  }) {
    return _then(
      _$AuthResponseModelImpl(
        accessToken: null == accessToken
            ? _value.accessToken
            : accessToken // ignore: cast_nullable_to_non_nullable
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
        pungutTarif: null == pungutTarif
            ? _value.pungutTarif
            : pungutTarif // ignore: cast_nullable_to_non_nullable
                  as int,
        nopList: null == nopList
            ? _value._nopList
            : nopList // ignore: cast_nullable_to_non_nullable
                  as List<NopModel>,
        opPengawas: freezed == opPengawas
            ? _value.opPengawas
            : opPengawas // ignore: cast_nullable_to_non_nullable
                  as OpPengawasAuthModel?,
        lastUpdateOp: null == lastUpdateOp
            ? _value.lastUpdateOp
            : lastUpdateOp // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthResponseModelImpl implements _AuthResponseModel {
  const _$AuthResponseModelImpl({
    this.accessToken = '',
    this.nop = '',
    this.uuidStatic = '',
    this.roleLoginId = 0,
    this.pungutTarif = 0,
    final List<NopModel> nopList = const [],
    this.opPengawas,
    this.lastUpdateOp = '',
  }) : _nopList = nopList;

  factory _$AuthResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthResponseModelImplFromJson(json);

  @override
  @JsonKey()
  final String accessToken;
  @override
  @JsonKey()
  final String nop;
  @override
  @JsonKey()
  final String uuidStatic;
  @override
  @JsonKey()
  final int roleLoginId;
  @override
  @JsonKey()
  final int pungutTarif;
  final List<NopModel> _nopList;
  @override
  @JsonKey()
  List<NopModel> get nopList {
    if (_nopList is EqualUnmodifiableListView) return _nopList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nopList);
  }

  @override
  final OpPengawasAuthModel? opPengawas;
  @override
  @JsonKey()
  final String lastUpdateOp;

  @override
  String toString() {
    return 'AuthResponseModel(accessToken: $accessToken, nop: $nop, uuidStatic: $uuidStatic, roleLoginId: $roleLoginId, pungutTarif: $pungutTarif, nopList: $nopList, opPengawas: $opPengawas, lastUpdateOp: $lastUpdateOp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthResponseModelImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.nop, nop) || other.nop == nop) &&
            (identical(other.uuidStatic, uuidStatic) ||
                other.uuidStatic == uuidStatic) &&
            (identical(other.roleLoginId, roleLoginId) ||
                other.roleLoginId == roleLoginId) &&
            (identical(other.pungutTarif, pungutTarif) ||
                other.pungutTarif == pungutTarif) &&
            const DeepCollectionEquality().equals(other._nopList, _nopList) &&
            (identical(other.opPengawas, opPengawas) ||
                other.opPengawas == opPengawas) &&
            (identical(other.lastUpdateOp, lastUpdateOp) ||
                other.lastUpdateOp == lastUpdateOp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    accessToken,
    nop,
    uuidStatic,
    roleLoginId,
    pungutTarif,
    const DeepCollectionEquality().hash(_nopList),
    opPengawas,
    lastUpdateOp,
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
    final String nop,
    final String uuidStatic,
    final int roleLoginId,
    final int pungutTarif,
    final List<NopModel> nopList,
    final OpPengawasAuthModel? opPengawas,
    final String lastUpdateOp,
  }) = _$AuthResponseModelImpl;

  factory _AuthResponseModel.fromJson(Map<String, dynamic> json) =
      _$AuthResponseModelImpl.fromJson;

  @override
  String get accessToken;
  @override
  String get nop;
  @override
  String get uuidStatic;
  @override
  int get roleLoginId;
  @override
  int get pungutTarif;
  @override
  List<NopModel> get nopList;
  @override
  OpPengawasAuthModel? get opPengawas;
  @override
  String get lastUpdateOp;

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
  int get pungutTarif => throw _privateConstructorUsedError;
  int get uptb => throw _privateConstructorUsedError;
  String get kdCamat => throw _privateConstructorUsedError;
  String get nmCamat => throw _privateConstructorUsedError;
  String get kdLurah => throw _privateConstructorUsedError;
  String get nmLurah => throw _privateConstructorUsedError;
  String get statusDigitalisasi => throw _privateConstructorUsedError;

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
  $Res call({
    String nop,
    String namaOp,
    String alamatOp,
    bool isDigital,
    int pungutTarif,
    int uptb,
    String kdCamat,
    String nmCamat,
    String kdLurah,
    String nmLurah,
    String statusDigitalisasi,
  });
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
    Object? pungutTarif = null,
    Object? uptb = null,
    Object? kdCamat = null,
    Object? nmCamat = null,
    Object? kdLurah = null,
    Object? nmLurah = null,
    Object? statusDigitalisasi = null,
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
            pungutTarif: null == pungutTarif
                ? _value.pungutTarif
                : pungutTarif // ignore: cast_nullable_to_non_nullable
                      as int,
            uptb: null == uptb
                ? _value.uptb
                : uptb // ignore: cast_nullable_to_non_nullable
                      as int,
            kdCamat: null == kdCamat
                ? _value.kdCamat
                : kdCamat // ignore: cast_nullable_to_non_nullable
                      as String,
            nmCamat: null == nmCamat
                ? _value.nmCamat
                : nmCamat // ignore: cast_nullable_to_non_nullable
                      as String,
            kdLurah: null == kdLurah
                ? _value.kdLurah
                : kdLurah // ignore: cast_nullable_to_non_nullable
                      as String,
            nmLurah: null == nmLurah
                ? _value.nmLurah
                : nmLurah // ignore: cast_nullable_to_non_nullable
                      as String,
            statusDigitalisasi: null == statusDigitalisasi
                ? _value.statusDigitalisasi
                : statusDigitalisasi // ignore: cast_nullable_to_non_nullable
                      as String,
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
  $Res call({
    String nop,
    String namaOp,
    String alamatOp,
    bool isDigital,
    int pungutTarif,
    int uptb,
    String kdCamat,
    String nmCamat,
    String kdLurah,
    String nmLurah,
    String statusDigitalisasi,
  });
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
    Object? pungutTarif = null,
    Object? uptb = null,
    Object? kdCamat = null,
    Object? nmCamat = null,
    Object? kdLurah = null,
    Object? nmLurah = null,
    Object? statusDigitalisasi = null,
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
        pungutTarif: null == pungutTarif
            ? _value.pungutTarif
            : pungutTarif // ignore: cast_nullable_to_non_nullable
                  as int,
        uptb: null == uptb
            ? _value.uptb
            : uptb // ignore: cast_nullable_to_non_nullable
                  as int,
        kdCamat: null == kdCamat
            ? _value.kdCamat
            : kdCamat // ignore: cast_nullable_to_non_nullable
                  as String,
        nmCamat: null == nmCamat
            ? _value.nmCamat
            : nmCamat // ignore: cast_nullable_to_non_nullable
                  as String,
        kdLurah: null == kdLurah
            ? _value.kdLurah
            : kdLurah // ignore: cast_nullable_to_non_nullable
                  as String,
        nmLurah: null == nmLurah
            ? _value.nmLurah
            : nmLurah // ignore: cast_nullable_to_non_nullable
                  as String,
        statusDigitalisasi: null == statusDigitalisasi
            ? _value.statusDigitalisasi
            : statusDigitalisasi // ignore: cast_nullable_to_non_nullable
                  as String,
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
    this.pungutTarif = 0,
    this.uptb = 0,
    this.kdCamat = '',
    this.nmCamat = '',
    this.kdLurah = '',
    this.nmLurah = '',
    this.statusDigitalisasi = '',
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
  @JsonKey()
  final int pungutTarif;
  @override
  @JsonKey()
  final int uptb;
  @override
  @JsonKey()
  final String kdCamat;
  @override
  @JsonKey()
  final String nmCamat;
  @override
  @JsonKey()
  final String kdLurah;
  @override
  @JsonKey()
  final String nmLurah;
  @override
  @JsonKey()
  final String statusDigitalisasi;

  @override
  String toString() {
    return 'NopModel(nop: $nop, namaOp: $namaOp, alamatOp: $alamatOp, isDigital: $isDigital, pungutTarif: $pungutTarif, uptb: $uptb, kdCamat: $kdCamat, nmCamat: $nmCamat, kdLurah: $kdLurah, nmLurah: $nmLurah, statusDigitalisasi: $statusDigitalisasi)';
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
                other.isDigital == isDigital) &&
            (identical(other.pungutTarif, pungutTarif) ||
                other.pungutTarif == pungutTarif) &&
            (identical(other.uptb, uptb) || other.uptb == uptb) &&
            (identical(other.kdCamat, kdCamat) || other.kdCamat == kdCamat) &&
            (identical(other.nmCamat, nmCamat) || other.nmCamat == nmCamat) &&
            (identical(other.kdLurah, kdLurah) || other.kdLurah == kdLurah) &&
            (identical(other.nmLurah, nmLurah) || other.nmLurah == nmLurah) &&
            (identical(other.statusDigitalisasi, statusDigitalisasi) ||
                other.statusDigitalisasi == statusDigitalisasi));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    nop,
    namaOp,
    alamatOp,
    isDigital,
    pungutTarif,
    uptb,
    kdCamat,
    nmCamat,
    kdLurah,
    nmLurah,
    statusDigitalisasi,
  );

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
    final int pungutTarif,
    final int uptb,
    final String kdCamat,
    final String nmCamat,
    final String kdLurah,
    final String nmLurah,
    final String statusDigitalisasi,
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
  @override
  int get pungutTarif;
  @override
  int get uptb;
  @override
  String get kdCamat;
  @override
  String get nmCamat;
  @override
  String get kdLurah;
  @override
  String get nmLurah;
  @override
  String get statusDigitalisasi;

  /// Create a copy of NopModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NopModelImplCopyWith<_$NopModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OpPengawasAuthModel _$OpPengawasAuthModelFromJson(Map<String, dynamic> json) {
  return _OpPengawasAuthModel.fromJson(json);
}

/// @nodoc
mixin _$OpPengawasAuthModel {
  int get idEvent => throw _privateConstructorUsedError;
  String get op => throw _privateConstructorUsedError;
  String get nip => throw _privateConstructorUsedError;
  bool get isPresent => throw _privateConstructorUsedError;

  /// Serializes this OpPengawasAuthModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OpPengawasAuthModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OpPengawasAuthModelCopyWith<OpPengawasAuthModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OpPengawasAuthModelCopyWith<$Res> {
  factory $OpPengawasAuthModelCopyWith(
    OpPengawasAuthModel value,
    $Res Function(OpPengawasAuthModel) then,
  ) = _$OpPengawasAuthModelCopyWithImpl<$Res, OpPengawasAuthModel>;
  @useResult
  $Res call({int idEvent, String op, String nip, bool isPresent});
}

/// @nodoc
class _$OpPengawasAuthModelCopyWithImpl<$Res, $Val extends OpPengawasAuthModel>
    implements $OpPengawasAuthModelCopyWith<$Res> {
  _$OpPengawasAuthModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OpPengawasAuthModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idEvent = null,
    Object? op = null,
    Object? nip = null,
    Object? isPresent = null,
  }) {
    return _then(
      _value.copyWith(
            idEvent: null == idEvent
                ? _value.idEvent
                : idEvent // ignore: cast_nullable_to_non_nullable
                      as int,
            op: null == op
                ? _value.op
                : op // ignore: cast_nullable_to_non_nullable
                      as String,
            nip: null == nip
                ? _value.nip
                : nip // ignore: cast_nullable_to_non_nullable
                      as String,
            isPresent: null == isPresent
                ? _value.isPresent
                : isPresent // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OpPengawasAuthModelImplCopyWith<$Res>
    implements $OpPengawasAuthModelCopyWith<$Res> {
  factory _$$OpPengawasAuthModelImplCopyWith(
    _$OpPengawasAuthModelImpl value,
    $Res Function(_$OpPengawasAuthModelImpl) then,
  ) = __$$OpPengawasAuthModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int idEvent, String op, String nip, bool isPresent});
}

/// @nodoc
class __$$OpPengawasAuthModelImplCopyWithImpl<$Res>
    extends _$OpPengawasAuthModelCopyWithImpl<$Res, _$OpPengawasAuthModelImpl>
    implements _$$OpPengawasAuthModelImplCopyWith<$Res> {
  __$$OpPengawasAuthModelImplCopyWithImpl(
    _$OpPengawasAuthModelImpl _value,
    $Res Function(_$OpPengawasAuthModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OpPengawasAuthModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idEvent = null,
    Object? op = null,
    Object? nip = null,
    Object? isPresent = null,
  }) {
    return _then(
      _$OpPengawasAuthModelImpl(
        idEvent: null == idEvent
            ? _value.idEvent
            : idEvent // ignore: cast_nullable_to_non_nullable
                  as int,
        op: null == op
            ? _value.op
            : op // ignore: cast_nullable_to_non_nullable
                  as String,
        nip: null == nip
            ? _value.nip
            : nip // ignore: cast_nullable_to_non_nullable
                  as String,
        isPresent: null == isPresent
            ? _value.isPresent
            : isPresent // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OpPengawasAuthModelImpl implements _OpPengawasAuthModel {
  const _$OpPengawasAuthModelImpl({
    this.idEvent = 0,
    this.op = '',
    this.nip = '',
    this.isPresent = false,
  });

  factory _$OpPengawasAuthModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OpPengawasAuthModelImplFromJson(json);

  @override
  @JsonKey()
  final int idEvent;
  @override
  @JsonKey()
  final String op;
  @override
  @JsonKey()
  final String nip;
  @override
  @JsonKey()
  final bool isPresent;

  @override
  String toString() {
    return 'OpPengawasAuthModel(idEvent: $idEvent, op: $op, nip: $nip, isPresent: $isPresent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OpPengawasAuthModelImpl &&
            (identical(other.idEvent, idEvent) || other.idEvent == idEvent) &&
            (identical(other.op, op) || other.op == op) &&
            (identical(other.nip, nip) || other.nip == nip) &&
            (identical(other.isPresent, isPresent) ||
                other.isPresent == isPresent));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, idEvent, op, nip, isPresent);

  /// Create a copy of OpPengawasAuthModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OpPengawasAuthModelImplCopyWith<_$OpPengawasAuthModelImpl> get copyWith =>
      __$$OpPengawasAuthModelImplCopyWithImpl<_$OpPengawasAuthModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OpPengawasAuthModelImplToJson(this);
  }
}

abstract class _OpPengawasAuthModel implements OpPengawasAuthModel {
  const factory _OpPengawasAuthModel({
    final int idEvent,
    final String op,
    final String nip,
    final bool isPresent,
  }) = _$OpPengawasAuthModelImpl;

  factory _OpPengawasAuthModel.fromJson(Map<String, dynamic> json) =
      _$OpPengawasAuthModelImpl.fromJson;

  @override
  int get idEvent;
  @override
  String get op;
  @override
  String get nip;
  @override
  bool get isPresent;

  /// Create a copy of OpPengawasAuthModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OpPengawasAuthModelImplCopyWith<_$OpPengawasAuthModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
