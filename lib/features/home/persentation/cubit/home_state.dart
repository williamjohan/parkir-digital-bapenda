import 'package:equatable/equatable.dart';
import '../../../../core/utils/permission_utils.dart'; // Sesuaikan path

class HomeState extends Equatable {
  final CameraPermissionStatus? permissionActionStatus;
  final String? selectedVehicleForCapture;

  // Timestamp ini adalah "Hack" arsitektur yang elegan agar Listener selalu terpicu
  // setiap kali aksi ditekan, meskipun status permission-nya tidak berubah.
  final int? actionTimestamp;

  const HomeState({
    this.permissionActionStatus,
    this.selectedVehicleForCapture,
    this.actionTimestamp,
  });

  HomeState copyWith({
    CameraPermissionStatus? permissionActionStatus,
    String? selectedVehicleForCapture,
    int? actionTimestamp,
  }) {
    return HomeState(
      permissionActionStatus:
          permissionActionStatus ?? this.permissionActionStatus,
      selectedVehicleForCapture:
          selectedVehicleForCapture ?? this.selectedVehicleForCapture,
      actionTimestamp: actionTimestamp ?? this.actionTimestamp,
    );
  }

  @override
  List<Object?> get props => [
    permissionActionStatus,
    selectedVehicleForCapture,
    actionTimestamp,
  ];
}
