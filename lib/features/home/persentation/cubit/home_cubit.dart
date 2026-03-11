// lib/features/home/presentation/cubit/home_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/storage/database_helper.dart';
import 'home_state.dart';
import '../../../../core/utils/permission_utils.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  Future<void> requestCameraAccess(String vehicleType) async {
    // 1. Panggil Util yang sekarang mengembalikan Either
    final result = await PermissionUtils.requestCameraPermission();

    if (isClosed) return;

    // 2. Functional Error Handling (Pattern Either)
    result.fold(
      (failure) {
        // Jika tertangkap Left (Failure), pancarkan state error
        emit(
          state.copyWith(
            permissionActionStatus: CameraPermissionStatus.error,
            selectedVehicleForCapture: vehicleType,
            actionTimestamp: DateTime.now().millisecondsSinceEpoch,
          ),
        );
      },
      (status) {
        // Jika tertangkap Right (Success/Status), pancarkan status OS
        emit(
          state.copyWith(
            permissionActionStatus: status,
            selectedVehicleForCapture: vehicleType,
            actionTimestamp: DateTime.now().millisecondsSinceEpoch,
          ),
        );
      },
    );
  }

  /// Mengambil data terbaru dari SQLite dan memperbarui State
  Future<void> loadDashboardData() async {
    try {
      final counts = await DatabaseHelper.instance.getDailyVehicleCount();
      emit(
        state.copyWith(
          motorCount: counts['motor'] ?? 0,
          mobilCount: counts['mobil'] ?? 0,
        ),
      );
    } catch (e) {
      // Logika error handling jika gagal akses DB lokal
    }
  }
}
