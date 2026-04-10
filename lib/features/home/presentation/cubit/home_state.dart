import 'package:equatable/equatable.dart';
import '../../../../core/utils/permission_utils.dart';
import '../../../transaction_history/data/models/history_item_model.dart'; // [BARU]

class HomeState extends Equatable {
  final CameraPermissionStatus? permissionActionStatus;
  final String? selectedVehicleForCapture;
  final int? actionTimestamp;
  final int motorCount;
  final int mobilCount;
  final double totalPendapatan;

  // UNtuk pilih jenis mode_plat
  final int? selectedModePlat;

  // [BARU] Daftar 5 transaksi terbaru
  final List<HistoryItemModel> recentTransactions;

  const HomeState({
    this.permissionActionStatus,
    this.selectedVehicleForCapture,
    this.actionTimestamp,
    this.motorCount = 0,
    this.mobilCount = 0,
    this.totalPendapatan = 0.0,
    this.selectedModePlat,
    this.recentTransactions = const [], // [BARU]
  });

  HomeState copyWith({
    CameraPermissionStatus? permissionActionStatus,
    String? selectedVehicleForCapture,
    int? actionTimestamp,
    int? motorCount,
    int? mobilCount,
    int? selectedModePlat,
    double? totalPendapatan,
    List<HistoryItemModel>? recentTransactions, // [BARU]
  }) {
    return HomeState(
      permissionActionStatus:
          permissionActionStatus ?? this.permissionActionStatus,
      selectedVehicleForCapture:
          selectedVehicleForCapture ?? this.selectedVehicleForCapture,
      actionTimestamp: actionTimestamp ?? this.actionTimestamp,
      motorCount: motorCount ?? this.motorCount,
      mobilCount: mobilCount ?? this.mobilCount,
      totalPendapatan: totalPendapatan ?? this.totalPendapatan,
      selectedModePlat: selectedModePlat ?? this.selectedModePlat,
      recentTransactions:
          recentTransactions ?? this.recentTransactions, // [BARU]
    );
  }

  @override
  List<Object?> get props => [
    permissionActionStatus,
    selectedVehicleForCapture,
    actionTimestamp,
    mobilCount,
    motorCount,
    totalPendapatan,
    selectedModePlat,
    recentTransactions, // [BARU]
  ];
}
