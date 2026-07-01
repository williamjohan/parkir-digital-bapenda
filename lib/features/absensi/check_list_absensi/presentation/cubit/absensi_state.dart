import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/absensi_entity.dart';

part 'absensi_state.freezed.dart';

@freezed
class AbsensiState with _$AbsensiState {
  const factory AbsensiState.initial() = _Initial;
  const factory AbsensiState.loading() = _Loading;
  const factory AbsensiState.loaded(AbsensiEntity data) = _Loaded;
  const factory AbsensiState.error(String message) = _Error;
}
