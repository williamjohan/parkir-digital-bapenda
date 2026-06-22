import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/features/home/domain/usecases/get_dashboard_summary_non_jukir_usecase.dart';
import '../../../../../core/enums/app_enums.dart';
import '../../../../../core/storage/database_helper_2.dart';
import '../../../../../core/storage/secure_storage_manager.dart';
import '../../../../../core/utils/app_logger.dart';
import '../../../../transaction/domain/usecases/sync_qris_usecase.dart';
import '../../../domain/entities/dashboard_summary_non_jukir_entity.dart';
import '../../../domain/usecases/get_hybrid_dashboard_sumarry_usecase.dart';
import '../../../domain/usecases/get_recent_transaction_usecase.dart';
import 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final GetHybridDashboardSummaryUseCase _getHybridDashboardSummaryUseCase;
  final GetRecentTransactionsUseCase _getRecentTransactionsUseCase;
  final GetDashboardSummaryNonJukirUseCase _getDashboardSummaryNonJukirUseCase;
  final ISecureStorageManager _secureStorage;
  final SyncQrisUseCase _syncQrisUseCase;
  final DatabaseHelper2 _databaseHelper;

  HomeCubit(
    this._getHybridDashboardSummaryUseCase,
    this._getRecentTransactionsUseCase,
    this._getDashboardSummaryNonJukirUseCase,
    this._secureStorage,
    this._syncQrisUseCase,
    this._databaseHelper,
  ) : super(const HomeState());

  // ==========================================================
  // INITIALIZE
  // ==========================================================

  Future<void> initialize() async {
    emit(state.copyWith(status: HomeStatus.loading));

    await _loadProfileInfo();

    if (state.role == RoleLoginDigitalParkir.jukir) {
      await loadDashboardData();

      await _syncQrisUseCase.execute();
    } else {
      await _ensureValidToken();
      await _loadDashboardNonJukir();
    }
  }

  Future<void> _ensureValidToken() async {
    final token = await _secureStorage.getAccessToken();
    if (token == null || token.isEmpty) {
      AppLogger.warning('Token is null or empty, attempting refresh...');
      // await _refreshTokenManually();
    }
  }

  // ==========================================================
  // DASHBOARD
  // ==========================================================

  Future<void> loadDashboardData() async {
    emit(state.copyWith(status: HomeStatus.loading));

    final profile = await _secureStorage.getJukirProfile();

    bool isFreeStatus = false;

    if (profile != null) {
      final dynamic rawPungutTarif = profile['pungutTarif'];

      isFreeStatus = rawPungutTarif == 1 || rawPungutTarif == '1';
    }

    final summaryResult = await _getHybridDashboardSummaryUseCase.execute(
      nop: state.nop,
    );

    summaryResult.fold(
      (failure) {
        if (!isClosed) {
          emit(
            state.copyWith(isFree: isFreeStatus, status: HomeStatus.failure),
          );
        }
      },
      (summary) {
        if (!isClosed) {
          emit(
            state.copyWith(
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

    final recentResult = await _getRecentTransactionsUseCase.execute(limit: 5);

    recentResult.fold((_) {}, (transactions) {
      if (!isClosed) {
        emit(state.copyWith(recentTransactions: transactions));
      }
    });

    if (!isClosed) {
      emit(state.copyWith(status: HomeStatus.success));
    }
  }

  Future<void> _loadDashboardNonJukir() async {
    final result = await _getDashboardSummaryNonJukirUseCase.execute();

    result.fold(
      (failure) {
        if (!isClosed) {
          emit(
            state.copyWith(
              status: HomeStatus.failure,
              motorCount: 0,
              mobilCount: 0,
              totalPendapatan: 0,
              totalPajak: 0,
              totalBersih: 0,
              totalOp: 0,
              totalOpDigital: 0,
              totalOpNonDigital: 0,
              digital: const OpCategoryEntity(
                total: 0,
                totalBertarif: 0,
                totalNonTarif: 0,
                totalTidakDiketahui: 0,
                persentaseBertarif: 0,
                persentaseNonTarif: 0,
                persentaseTidakDiketahui: 0,
              ),

              nonDigital: const OpCategoryEntity(
                total: 0,
                totalBertarif: 0,
                totalNonTarif: 0,
                totalTidakDiketahui: 0,
                persentaseBertarif: 0,
                persentaseNonTarif: 0,
                persentaseTidakDiketahui: 0,
              ),

              persentaseDigital: 0,
              persentaseNonDigital: 0,
              sofParkirResults: [],
            ),
          );
        }
      },
      (summary) {
        if (!isClosed) {
          emit(
            state.copyWith(
              status: HomeStatus.success,
              motorCount: summary.jumlahMotorHariIni,
              mobilCount: summary.jumlahMobilHariIni,
              totalPendapatan: summary.totalNominalHariIni,
              totalPajak: summary.totalNominalBersihUntukBapenda,
              totalBersih: summary.totalNominalBersihUntukWajibPajak,
              totalOp: summary.totalOp,
              totalOpDigital: summary.totalOpDigital,
              totalOpNonDigital: summary.totalOpNonDigital,
              digital: summary.digital,
              nonDigital: summary.nonDigital,

              persentaseDigital: summary.persentaseDigital,
              persentaseNonDigital: summary.persentaseNonDigital,
              sofParkirResults: summary.sofParkirResults,
            ),
          );
        }
      },
    );
  }

  // ==========================================================
  // PROFILE
  // ==========================================================

  Future<void> _loadProfileInfo() async {
    //  1. AMBIL ROLE DARI SECURE STORAGE
    final roleId = await _secureStorage.getRoleId() ?? 0;
    final userRole = RoleLoginDigitalParkir.fromInt(roleId);

    //  2. SIMPAN ROLE KE STATE AGAR UI BISA BACA
    emit(state.copyWith(role: userRole));

    final profile = await _secureStorage.getJukirProfile();
    final namaUser = profile?['namaUser']?.toString() ?? 'User';

    // 3. LOGIKA JUKIR (Single NOP)
    if (userRole == RoleLoginDigitalParkir.jukir) {
      emit(
        state.copyWith(
          namaJukir: namaUser,
          nop: profile?['nop']?.toString() ?? '',
          namaOp: profile?['namaObjekPajak']?.toString() ?? '',
          namaLokasi: profile?['alamat']?.toString() ?? '',
        ),
      );
      return;
    }

    //  4. LOGIKA BAPENDA / WP (Multiple NOP)
    final nopList = await _databaseHelper.getNopList();

    if (nopList.isEmpty) {
      emit(state.copyWith(namaJukir: namaUser)); // NOP Kosong
      return;
    }

    // Ambil NOP pertama sebagai default
    final firstNop = nopList.first;

    emit(
      state.copyWith(
        namaJukir: namaUser,
        nop: firstNop['nop']?.toString() ?? '',
        namaOp: firstNop['nama_op']?.toString() ?? '',
        namaLokasi: firstNop['alamat_op']?.toString() ?? '',
      ),
    );
  }
  // ==========================================================
  // CHANGE OBJEK PAJAK
  // ==========================================================

  Future<void> changeObjekPajak(Map<String, dynamic> item) async {
    emit(
      state.copyWith(
        nop: item['nop']?.toString() ?? '',
        namaOp: item['nama_op']?.toString() ?? '',
        namaLokasi: item['alamat_op']?.toString() ?? '',
      ),
    );

    await loadDashboardData();
  }
}
