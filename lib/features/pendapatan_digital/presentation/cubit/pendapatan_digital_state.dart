import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../home/domain/entities/dashboard_summary_non_jukir_entity.dart';

part 'pendapatan_digital_state.freezed.dart';

@freezed
class PendapatanDigitalState with _$PendapatanDigitalState {
  const factory PendapatanDigitalState({
    @Default(false) bool isLoading,
    @Default(false) bool isFilterLoading,
    DashboardSummaryNonJukirEntity? summary,
    String? tglAwal,
    String? tglAkhir,
    String? errorMessage,
  }) = _PendapatanDigitalState;
}
