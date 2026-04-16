import 'package:equatable/equatable.dart';
import '../../../../core/utils/permission_utils.dart';
import '../../../transaction_history/data/models/history_item_model.dart';
import '../../data/models/weekly_chart_item_model.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final CameraPermissionStatus? permissionActionStatus;
  final String? selectedVehicleForCapture;
  final int? actionTimestamp;
  final int motorCount;
  final int mobilCount;
  final double totalPendapatan;
  final int? selectedModePlat;
  final List<HistoryItemModel> recentTransactions;
  final List<WeeklyChartItemModel> weeklyChartData;
  final bool isFree;
  final HomeStatus status;

  const HomeState({
    this.status = HomeStatus.initial,
    this.permissionActionStatus,
    this.selectedVehicleForCapture,
    this.actionTimestamp,
    this.motorCount = 0,
    this.mobilCount = 0,
    this.totalPendapatan = 0.0,
    this.selectedModePlat,
    this.recentTransactions = const [],
    this.weeklyChartData = const [],
    this.isFree = false,
  });

  HomeState copyWith({
    HomeStatus? status,
    CameraPermissionStatus? permissionActionStatus,
    String? selectedVehicleForCapture,
    int? actionTimestamp,
    int? motorCount,
    int? mobilCount,
    double? totalPendapatan,
    int? selectedModePlat,
    List<HistoryItemModel>? recentTransactions,
    List<WeeklyChartItemModel>? weeklyChartData,
    bool? isFree,
  }) {
    return HomeState(
      status: status ?? this.status,
      permissionActionStatus:
          permissionActionStatus ?? this.permissionActionStatus,
      selectedVehicleForCapture:
          selectedVehicleForCapture ?? this.selectedVehicleForCapture,
      actionTimestamp: actionTimestamp ?? this.actionTimestamp,
      motorCount: motorCount ?? this.motorCount,
      mobilCount: mobilCount ?? this.mobilCount,
      totalPendapatan: totalPendapatan ?? this.totalPendapatan,
      selectedModePlat: selectedModePlat ?? this.selectedModePlat,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      weeklyChartData: weeklyChartData ?? this.weeklyChartData,
      isFree: isFree ?? this.isFree,
    );
  }

  @override
  List<Object?> get props => [
    status,
    permissionActionStatus,
    selectedVehicleForCapture,
    actionTimestamp,
    mobilCount,
    motorCount,
    totalPendapatan,
    selectedModePlat,
    recentTransactions,
    weeklyChartData,
    isFree,
  ];
}
