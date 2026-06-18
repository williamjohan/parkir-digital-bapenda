import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/storage/database_helper_2.dart';
import '../../../../../core/storage/secure_storage_manager.dart';
import '../../../../../core/utils/permission_utils.dart';
import '../../../../transaction/domain/usecases/sync_qris_usecase.dart';
import '../../../domain/usecases/get_hybrid_dashboard_sumarry_usecase.dart';
import '../../../domain/usecases/get_recent_transaction_usecase.dart';
import 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final GetHybridDashboardSummaryUseCase _getHybridDashboardSummaryUseCase;
  final GetRecentTransactionsUseCase _getRecentTransactionsUseCase;
  final ISecureStorageManager _secureStorage;
  final SyncQrisUseCase _syncQrisUseCase;
  final DatabaseHelper2 _databaseHelper;

  HomeCubit(
    this._getHybridDashboardSummaryUseCase,
    this._getRecentTransactionsUseCase,
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

    await _syncQrisUseCase.execute();

    await loadDashboardData();
  }

  // ==========================================================
  // CAMERA
  // ==========================================================

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

  // ==========================================================
  // PROFILE
  // ==========================================================

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
          namaOp: profile?['namaObjekPajak'] ?? '',
          namaLokasi: profile?['alamat'] ?? '',
        ),
      );

      return;
    }

    final nopList = await _databaseHelper.getNopList();

    if (nopList.isEmpty) {
      emit(
        state.copyWith(isJukir: false, namaJukir: profile?['namaUser'] ?? ''),
      );

      return;
    }

    final firstNop = nopList.first;

    emit(
      state.copyWith(
        isJukir: false,
        namaJukir: profile?['namaUser'] ?? '',
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
