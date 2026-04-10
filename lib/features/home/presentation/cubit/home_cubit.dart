// lib/features/home/presentation/cubit/home_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_daily_vehicle_count_usecase.dart';
import '../../domain/usecases/get_recent_transaction_usecase.dart';
import 'home_state.dart';
import '../../../../core/utils/permission_utils.dart';
import '../../../transaction_history/data/models/history_item_model.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final GetDailyVehicleCountUseCase _getDailyVehicleCountUseCase;
  final GetRecentTransactionsUseCase _getRecentTransactionsUseCase;

  HomeCubit(
    this._getDailyVehicleCountUseCase,
    this._getRecentTransactionsUseCase,
  ) : super(const HomeState());

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

  /// Mengambil data dashboard lengkap (counts + recent transactions)
  Future<void> loadDashboardData() async {
    // [BARU] Set loading true
    if (!isClosed) {
      emit(state.copyWith(isLoading: true));
    }

    // Handle daily vehicle count
    final countResult = await _getDailyVehicleCountUseCase.execute();
    countResult.fold(
      (failure) {
        // Silent error, keep existing counts
      },
      (counts) {
        if (!isClosed && counts is Map<String, int>) {
          emit(
            state.copyWith(
              motorCount: counts['motor'] ?? 0,
              mobilCount: counts['mobil'] ?? 0,
            ),
          );
        }
      },
    );

    // Handle recent transactions
    final recentResult = await _getRecentTransactionsUseCase.execute(limit: 5);
    recentResult.fold(
      (failure) {
        if (!isClosed) {
          emit(state.copyWith(recentTransactions: const []));
        }
      },
      (transactions) {
        if (!isClosed && transactions is List<HistoryItemModel>) {
          emit(state.copyWith(recentTransactions: transactions));
        }
      },
    );

    // [BARU] Set loading false setelah semua selesai
    if (!isClosed) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void selectModePlat(int mode) {
    emit(state.copyWith(selectedModePlat: mode));
  }
}
