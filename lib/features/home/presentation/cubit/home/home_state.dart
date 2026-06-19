import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../../core/enums/app_enums.dart';
import '../../../../../core/utils/permission_utils.dart';
import '../../../../transaction_history/data/models/history_item_model.dart';
import '../../../data/models/weekly_chart_item_model.dart';
import '../../../domain/entities/dashboard_summary_non_jukir_entity.dart';

part 'home_state.freezed.dart';

enum HomeStatus { initial, loading, success, failure }

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(HomeStatus.initial) HomeStatus status,
    CameraPermissionStatus? permissionActionStatus,
    String? selectedVehicleForCapture,
    int? actionTimestamp,
    @Default(0) int motorCount,
    @Default(0) int mobilCount,
    @Default(0.0) double totalPendapatan,
    @Default(0.0) double totalPajak,
    @Default(0.0) double totalBersih,
    int? selectedModePlat,
    @Default([]) List<HistoryItemModel> recentTransactions,
    @Default([]) List<WeeklyChartItemModel> weeklyChartData,
    @Default(false) bool isFree,
    @Default("") String nop,
    @Default("") String namaLokasi,
    @Default("") String namaJukir,
    @Default("") String namaOp,

    @Default(0) int totalOp,

    @Default([]) List<SofParkirResultEntity> sofParkirResults,
    @Default(RoleLoginDigitalParkir.tidakDiketahui) RoleLoginDigitalParkir role,
  }) = _HomeState;
}
