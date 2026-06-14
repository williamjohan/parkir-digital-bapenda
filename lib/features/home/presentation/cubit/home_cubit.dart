import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/utils/permission_utils.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../domain/usecases/get_hybrid_dashboard_sumarry_usecase.dart';
import '../../domain/usecases/get_recent_transaction_usecase.dart';
import '../../domain/usecases/get_weekly_chart_usecase.dart';
import 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final GetHybridDashboardSummaryUseCase _getHybridDashboardSummaryUseCase;
  final GetRecentTransactionsUseCase _getRecentTransactionsUseCase;
  final GetWeeklyChartUseCase _getWeeklyChartUseCase;
  final ISecureStorageManager _secureStorage;

  HomeCubit(
    this._getHybridDashboardSummaryUseCase,
    this._getRecentTransactionsUseCase,
    this._getWeeklyChartUseCase,
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

  /// Mengambil data dashboard secara lengkap dan terstruktur
  Future<void> loadDashboardData() async {
    //  1. SET LOADING
    emit(state.copyWith(status: HomeStatus.loading));

    // BONGKAR BRANKAS: Ambil status isFree dari profil Jukir
    final profile = await _secureStorage.getJukirProfile();
    bool isFreeStatus = false;

    if (profile != null) {
      final dynamic rawPungutTarif = profile['pungutTarif'];
      isFreeStatus = (rawPungutTarif == 1 || rawPungutTarif == '1');
    }

    // 2. TUGAS UTAMA: Ambil Dashboard Summary (Hybrid Logic di dalam UseCase)
    final summaryResult = await _getHybridDashboardSummaryUseCase.execute();
    summaryResult.fold(
      (failure) {
        //  Walaupun data summary gagal, kita TETEAP harus simpan isFree ke State!
        if (!isClosed) emit(state.copyWith(isFree: isFreeStatus));
      },
      (summary) {
        if (!isClosed) {
          emit(
            state.copyWith(
              // Casting ke toInt() karena model menyimpannya sebagai double
              motorCount: summary.jumlahMotorHariIni,
              mobilCount: summary.jumlahMobilHariIni,
              totalPendapatan: summary.totalNominalHariIni,
              totalPajak: summary.totalNominalBersihUntukBapenda,
              totalBersih: summary.totalNominalBersihUntukWajibPajak,
              isFree: isFreeStatus,
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

    if (!isClosed) {
      emit(state.copyWith(status: HomeStatus.success));
    }
  }
}
