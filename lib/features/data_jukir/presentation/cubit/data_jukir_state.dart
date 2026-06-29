import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/data_jukir_entity.dart';

part 'data_jukir_state.freezed.dart';

@freezed
class DataJukirState with _$DataJukirState {
  const factory DataJukirState.initial() = _Initial;

  const factory DataJukirState.loading() = _Loading;

  const factory DataJukirState.success(List<DataJukirEntity> data) = _Success;

  const factory DataJukirState.error(String message) = _Error;
}
