// lib/features/home/presentation/cubit/home_cubit.dart (versi lebih bersih)

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/core/storage/secure_storage_manager.dart';
import '../../domain/usecases/get_daily_vehicle_count_usecase.dart';
import '../../domain/usecases/get_recent_transaction_usecase.dart';
import 'home_state.dart';
import '../../../../core/utils/permission_utils.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final GetDailyVehicleCountUseCase _getDailyVehicleCountUseCase;
  final GetRecentTransactionsUseCase _getRecentTransactionsUseCase;
  final ISecureStorageManager _secureStorage;

  HomeCubit(
    this._getDailyVehicleCountUseCase,
    this._getRecentTransactionsUseCase,
    this._secureStorage,
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
    // 1. Ambil JANGKAR (Data Server Terakhir dari Secure Storage)
    final profile = await _secureStorage.getJukirProfile();
    int serverMotor = 0;
    int serverMobil = 0;
    double serverNominal = 0.0;

    if (profile != null) {
      // Ambil angka dari API BE (pastikan key-nya sesuai dengan JSON BE)
      serverMotor = (profile['jumlahMotor'] ?? 0) as int;
      serverMobil = (profile['jumlahMobil'] ?? 0) as int;

      // Hitung total uang dari server
      final nominalMotor = (profile['totalNominalMotor'] ?? 0).toDouble();
      final nominalMobil = (profile['totalNominalMobil'] ?? 0).toDouble();
      serverNominal = nominalMotor + nominalMobil;
    }

    // 2. Ambil DELTA (Data Lokal yang belum tersinkronisasi)
    // Asumsi: Nanti UseCase ini HANYA mengambil yang is_synced = 0
    final countResult = await _getDailyVehicleCountUseCase.execute();

    countResult.fold(
      (failure) {
        // Jika gagal ambil lokal, tampilkan angka server saja
        if (!isClosed) {
          emit(
            state.copyWith(
              motorCount: serverMotor,
              mobilCount: serverMobil,
              totalPendapatan: serverNominal,
            ),
          );
        }
      },
      (localCounts) {
        if (!isClosed) {
          // 3. THE HYBRID FORMULA: TOTAL = SERVER + LOKAL PENDING
          final int localMotor = localCounts['motor'] ?? 0;
          final int localMobil = localCounts['mobil'] ?? 0;

          // Asumsi localCounts juga mengembalikan nominal (kita perbarui UseCase-nya nanti)
          final double localNominalMotor = (localCounts['nominalMotor'] ?? 0)
              .toDouble();
          final double localNominalMobil = (localCounts['nominalMobil'] ?? 0)
              .toDouble();
          final double totalLocalNominal =
              localNominalMotor + localNominalMobil;

          emit(
            state.copyWith(
              motorCount: serverMotor + localMotor,
              mobilCount: serverMobil + localMobil,
              totalPendapatan: serverNominal + totalLocalNominal,
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
        if (!isClosed) {
          emit(state.copyWith(recentTransactions: transactions));
        }
      },
    );
  }

  void selectModePlat(int mode) {
    emit(state.copyWith(selectedModePlat: mode));
  }
}
