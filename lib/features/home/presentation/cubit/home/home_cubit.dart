import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/storage/database_helper_2.dart';
import '../../../../../core/utils/permission_utils.dart';
import '../../../../../core/storage/secure_storage_manager.dart';
import '../../../../transaction/domain/usecases/sync_qris_usecase.dart';
import '../../../domain/usecases/get_hybrid_dashboard_sumarry_usecase.dart';
import '../../../domain/usecases/get_recent_transaction_usecase.dart';
import 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final GetHybridDashboardSummaryUseCase _getHybridDashboardSummaryUseCase;
  final GetRecentTransactionsUseCase _getRecentTransactionsUseCase;
  // final GetWeeklyChartUseCase _getWeeklyChartUseCase;
  final ISecureStorageManager _secureStorage;
  final SyncQrisUseCase _syncQrisUseCase;
  final DatabaseHelper2 _databaseHelper;

  HomeCubit(
    this._getHybridDashboardSummaryUseCase,
    this._getRecentTransactionsUseCase,
    // this._getWeeklyChartUseCase,
    this._secureStorage,
    this._syncQrisUseCase, // 🚀 [BARU] Daftarkan di konstruktor
    this._databaseHelper,
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

    await _loadProfileInfo();

    // ==========================================
    // 🚀 TUGAS 0: BACKGROUND PRE-FETCHING QRIS
    // ==========================================
    // Kita jalankan proses sinkronisasi API -> Base64 -> File Local -> Brankas.
    // Sengaja kita await agar file fisik benar-benar selesai ditulis ke dalam HP
    // sebelum Jukir sempat menekan tombol tambah transaksi (+).
    // Kita tidak perlu menggunakan result.fold() karena error handling
    // (Zero-State Offline) akan ditangani penuh oleh TransactionCubit nantinya.
    await _syncQrisUseCase.execute();

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
    // final chartResult = await _getWeeklyChartUseCase.execute();
    // chartResult.fold((failure) => null, (chartData) {
    //   if (!isClosed) {
    //     emit(state.copyWith(weeklyChartData: chartData));
    //   }
    // });

    if (!isClosed) {
      emit(state.copyWith(status: HomeStatus.success));
    }
  }

  Future<void> _loadProfileInfo() async {
    final isJukir = await _secureStorage.getIsJukir();
    final profile = await _secureStorage.getJukirProfile();

    print('IS JUKIR = $isJukir');
    print('PROFILE = $profile');

    if (isJukir) {
      emit(
        state.copyWith(
          isJukir: true,
          namaJukir: profile?['namaUser'] ?? '',
          nop: profile?['nop'] ?? '',
          namaLokasi: profile?['namaObjekPajak'] ?? '',
        ),
      );

      return;
    } else {
      final nopList = await _databaseHelper.getNopList();

      if (nopList.isNotEmpty) {
        final firstNop = nopList.first;

        emit(
          state.copyWith(
            isJukir: false,
            namaJukir: profile?['namaUser'] ?? '',
            nop: firstNop['nop']?.toString() ?? '',
            namaLokasi: firstNop['alamat_op']?.toString() ?? '',
          ),
        );
      }
    }
  }
}
