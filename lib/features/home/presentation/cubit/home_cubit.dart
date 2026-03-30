// lib/features/home/presentation/cubit/home_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_daily_vehicle_count_usecase.dart'; // [PERBAIKAN]
import 'home_state.dart';
import '../../../../core/utils/permission_utils.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final GetDailyVehicleCountUseCase _getDailyVehicleCountUseCase; // [PERBAIKAN]

  HomeCubit(this._getDailyVehicleCountUseCase) : super(const HomeState());

  Future<void> requestCameraAccess(String vehicleType) async {
    final result = await PermissionUtils.requestCameraPermission();
    if (isClosed) return;

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            permissionActionStatus: CameraPermissionStatus.error,
            selectedVehicleForCapture: vehicleType,
            actionTimestamp: DateTime.now().millisecondsSinceEpoch,
          ),
        );
      },
      (status) {
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

  /// Mengambil data terbaru lewat UseCase
  Future<void> loadDashboardData() async {
    // [PERBAIKAN]: Panggil eksekusi melalui UseCase, tangani dengan pola Either
    final result = await _getDailyVehicleCountUseCase.execute();

    result.fold(
      (failure) {
        // Abaikan error secara silent, atau bisa Anda tambahkan properti errorMessage di state
      },
      (counts) {
        if (!isClosed) {
          emit(
            state.copyWith(
              motorCount: counts['motor'] ?? 0,
              mobilCount: counts['mobil'] ?? 0,
            ),
          );
        }
      },
    );
  }

  void selectModePlat(int mode) {
    emit(state.copyWith(selectedModePlat: mode));
  }
}
