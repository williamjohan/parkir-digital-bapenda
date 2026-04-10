import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/utils/permission_utils.dart';
import '../../domain/usecases/get_hybrid_dashboard_sumarry_usecase.dart';
import '../../domain/usecases/get_recent_transaction_usecase.dart';
import '../../domain/usecases/get_weekly_chart_usecase.dart';
import '../../domain/usecases/sync_tarif_usecase.dart';
import 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  // 🚀 [BARU] Suntikkan 4 Senjata Baru Kita
  final GetHybridDashboardSummaryUseCase _getHybridDashboardSummaryUseCase;
  final GetRecentTransactionsUseCase _getRecentTransactionsUseCase;
  final GetWeeklyChartUseCase _getWeeklyChartUseCase;
  final SyncTarifUseCase _syncTarifUseCase;

  HomeCubit(
    this._getHybridDashboardSummaryUseCase,
    this._getRecentTransactionsUseCase,
    this._getWeeklyChartUseCase,
    this._syncTarifUseCase,
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

  /// Mengambil data dashboard secara lengkap dan terstruktur
  Future<void> loadDashboardData() async {
    // 1. TUGAS BAYANGAN (SILENT SYNC): Ambil Master Tarif dan simpan ke SQLite/Brankas
    // Kita panggil tanpa "await" agar UI Dashboard tidak perlu menunggunya selesai.
    _syncTarifUseCase.execute();

    // 2. TUGAS UTAMA: Ambil Dashboard Summary (Hybrid Logic di dalam UseCase)
    final summaryResult = await _getHybridDashboardSummaryUseCase.execute();
    summaryResult.fold(
      (failure) => null, // Jika gagal mutlak, biarkan state memakai angka 0
      (summary) {
        if (!isClosed) {
          emit(
            state.copyWith(
              motorCount: summary.jumlahMotorHariIni,
              mobilCount: summary.jumlahMobilHariIni,
              totalPendapatan: summary.totalNominalHariIni,
            ),
          );
        }
      },
    );

    // 3. TUGAS KEDUA: Ambil 5 Transaksi Terakhir (Smart Proxy Logic di dalam UseCase)
    final recentResult = await _getRecentTransactionsUseCase.execute(limit: 5);
    recentResult.fold((failure) => null, (transactions) {
      if (!isClosed) {
        emit(state.copyWith(recentTransactions: transactions));
      }
    });

    // 4. TUGAS KETIGA: Ambil Data Grafik Mingguan (Option A / API)
    final chartResult = await _getWeeklyChartUseCase.execute();
    chartResult.fold((failure) => null, (chartData) {
      if (!isClosed) {
        emit(state.copyWith(weeklyChartData: chartData));
      }
    });
  }

  void selectModePlat(int mode) {
    emit(state.copyWith(selectedModePlat: mode));
  }
}
