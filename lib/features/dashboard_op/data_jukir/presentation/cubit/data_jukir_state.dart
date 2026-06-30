import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/data_jukir_entity.dart';

part 'data_jukir_state.freezed.dart';

@freezed
class DataJukirState with _$DataJukirState {
  const factory DataJukirState({
    @Default(false) bool isLoading,
    @Default(<DataJukirEntity>[]) List<DataJukirEntity> data,
    String? errorMessage,
  }) = _DataJukirState;
}
