import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/dashboard_op_entity.dart';

part 'dashboard_op_state.freezed.dart';

@freezed
class DashboardOpState with _$DashboardOpState {
  const factory DashboardOpState({
    @Default(false) bool loading,
    @Default(false) bool showTSCard,
    DashboardOpEntity? data,
    String? errorMessage,
  }) = _DashboardOpState;

  factory DashboardOpState.initial() => const DashboardOpState();
}
