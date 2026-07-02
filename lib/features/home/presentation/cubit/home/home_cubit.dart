import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/core/utils/string_ext.dart';
import 'package:parkir_digital_bapenda/features/profile/domain/usecases/profile_usecase.dart';
import '../../../../../core/enums/app_enums.dart';
import '../../../../../core/storage/database_helper_2.dart';
import '../../../../../core/storage/secure_storage_manager.dart';
import '../../../../../core/utils/app_logger.dart';
import '../../../../transaction/domain/usecases/sync_qris_usecase.dart';
import '../../../domain/entities/dashboard_summary_non_jukir_entity.dart';
import '../../../domain/entities/dashboard_summary_pengawas.entity.dart';
import '../../../domain/usecases/home_usecase.dart';
import 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final HomeUsecase _homeUsecase;
  final ISecureStorageManager _secureStorage;
  final SyncQrisUseCase _syncQrisUseCase;
  final ProfileUseCase _profileUseCase;
  final DatabaseHelper2 _databaseHelper;

  HomeCubit(
    this._homeUsecase,
    this._secureStorage,
    this._syncQrisUseCase,
    this._databaseHelper,
    this._profileUseCase,
  ) : super(const HomeState());

  Future<void> initialize() async {
    emit(state.copyWith(status: HomeStatus.loading));

    await _loadProfileInfo();

    formatUserName();

    if (state.role == RoleLoginDigitalParkir.jukir) {
      await loadDashboarJukir();
      await _profileUseCase.getProfilePicturePath();
      await _syncQrisUseCase.execute();
    } else if (state.role == RoleLoginDigitalParkir.pengawas) {
      await loadDashboardPengawas();
    } else {
      await _ensureValidToken();
      await _loadDashboardNonJukir();
    }
  }

  Future<void> _ensureValidToken() async {
    final token = await _secureStorage.getAccessToken();
    if (token == null || token.isEmpty) {
      AppLogger.warning('Token is null or empty, attempting refresh...');
    }
  }

  Future<void> loadDashboarJukir() async {
    emit(state.copyWith(status: HomeStatus.loading));

    final profile = await _secureStorage.getJukirProfile();

    bool isFreeStatus = false;

    if (profile != null) {
      final dynamic rawPungutTarif = profile['pungutTarif'];

      isFreeStatus = rawPungutTarif == 1 || rawPungutTarif == '1';
    }

    final summaryJukirResult = await _homeUsecase.getDashboardSummaryJukir(
      nop: state.nop,
    );

    summaryJukirResult.fold(
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

    final recentResult = await _homeUsecase.getRecentTransactions(
      limit: 5,
      nop: state.nop,
    );

    recentResult.fold((_) {}, (transactions) {
      if (!isClosed) {
        emit(state.copyWith(recentTransactions: transactions));
      }
    });

    if (!isClosed) {
      emit(state.copyWith(status: HomeStatus.success));
    }
  }

  Future<void> loadDashboardPengawas() async {
    final result = await _homeUsecase.getDashboardSummaryPengawas();

    result.fold(
      (failure) {
        if (!isClosed) {
          emit(
            state.copyWith(
              status: HomeStatus.failure,
              // Reset shared metrics
              motorCount: 0,
              mobilCount: 0,
              totalPendapatan: 0,
              totalPajak: 0,
              totalBersih: 0,
              // Reset pengawas metrics
              laporanPelanggaran: 0,
              checkInOutData: const CheckInOutEntity(
                idEvent: 0,
                op: '',
                nip: '',
                tglRoster: '',
                jadwalMasuk: '',
                jadwalOut: '',
                status: 0,
                checkIn: '',
                checkInString: '',
                checkInJmlMobil: 0,
                checkInJmlMotor: 0,
                checkOut: '',
                checkOutString: '',
                checkOutJmlMobil: 0,
                checkOutJmlMotor: 0,
                latitude: '',
                longitude: '',
              ),
            ),
          );
        }
      },
      (summary) {
        if (!isClosed) {
          emit(
            state.copyWith(
              status: HomeStatus.success,
              // Map shared metrics (harus di-cast ke double jika state Anda minta double)
              motorCount: summary.data.dashboard.jumlahMotorHariIni,
              mobilCount: summary.data.dashboard.jumlahMobilHariIni,
              totalPendapatan: summary.data.dashboard.totalNominalHariIni
                  .toDouble(),
              totalPajak: summary.data.dashboard.totalNominalBersihUntukBapenda
                  .toDouble(),
              totalBersih: summary
                  .data
                  .dashboard
                  .totalNominalBersihUntukWajibPajak
                  .toDouble(),
              // Map pengawas metrics
              laporanPelanggaran: summary.data.laporanPelanggaran,
              checkInOutData: summary.data.checkInOut,
            ),
          );
        }
      },
    );
  }

  Future<void> _loadDashboardNonJukir() async {
    final result = await _homeUsecase.getDashboardSummaryNonJukir();

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
              totalBertarif: 0,
              totalNonTarif: 0,
              totalTarifTidakDiketahui: 0,
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
              detail: const DetailEntity(
                totalEdc: 0,
                totalRompiQris: 0,
                totalCctvCounting: 0,
                totalTs: 0,
                totalBebasParkir: 0,
                totalNonDigital: 0,
              ),
              berbayar: const BerbayarEntity(
                digital: 0,
                nonDigital: 0,
                total: 0,
                persentase: 0,
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
              totalBertarif: summary.totalBertarif,
              totalNonTarif: summary.totalNonTarif,
              totalTarifTidakDiketahui: summary.totalTarifTidakDiketahui,
              detail: summary.detail,
              berbayar: summary.berbayar,
            ),
          );
        }
      },
    );
  }

  Future<void> _loadProfileInfo() async {
    final roleId = await _secureStorage.getRoleId() ?? 0;
    final userRole = RoleLoginDigitalParkir.fromInt(roleId);
    emit(state.copyWith(role: userRole));

    final profile = await _secureStorage.getJukirProfile();
    final namaUser = profile?['namaUser']?.toString() ?? 'User';

    final namaUserShort = namaUser.shortName;
    if (userRole == RoleLoginDigitalParkir.jukir) {
      emit(
        state.copyWith(
          namaJukir: namaUserShort,
          nop: profile?['nop']?.toString() ?? '',
          namaOp: profile?['namaObjekPajak']?.toString() ?? '',
          namaLokasi: profile?['alamat']?.toString() ?? '',
        ),
      );
      return;
    }
    final nopList = await _databaseHelper.getNopList();

    if (nopList.isEmpty) {
      emit(state.copyWith(namaJukir: namaUser));
      return;
    }
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

  Future<void> changeObjekPajak(Map<String, dynamic> item) async {
    emit(
      state.copyWith(
        nop: item['nop']?.toString() ?? '',
        namaOp: item['nama_op']?.toString() ?? '',
        namaLokasi: item['alamat_op']?.toString() ?? '',
      ),
    );

    await loadDashboarJukir();
  }

  void formatUserName() {
    final userName = state.namaJukir;
    final upper = userName.toUpperCase();

    String formattedName;

    // Prioritas pertama
    final uptbMatch = RegExp(r'UPTB(\d+)').firstMatch(upper);
    if (uptbMatch != null) {
      formattedName = 'UPTB-${uptbMatch.group(1)}';
    }
    // Prioritas kedua
    else if (upper.startsWith('PD')) {
      formattedName = userName.substring(2);
    }
    // Default
    else {
      formattedName = userName;
    }

    AppLogger.debug("isi namaJukirFormatted : $formattedName");
    emit(state.copyWith(namaJukirFormatted: formattedName));
  }
}
