import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/core/di/injection.dart';
import 'package:parkir_digital_bapenda/core/storage/app_preferences.dart';
import 'package:parkir_digital_bapenda/core/utils/string_ext.dart';
import 'package:parkir_digital_bapenda/features/profile/domain/usecases/profile_usecase.dart';
import 'package:parkir_digital_bapenda/features/transaction/domain/usecases/qris_usecase.dart';
import '../../../../../core/enums/app_enums.dart';
import '../../../../../core/services/camera/i_camera_service.dart';
import '../../../../../core/storage/database_helper_2.dart';
import '../../../../../core/storage/i_secure_storage_manager.dart';
import '../../../../../core/utils/app_logger.dart';
import '../../../domain/entities/dashboard_summary_non_jukir_entity.dart';
import '../../../domain/entities/dashboard_summary_pengawas.entity.dart';
import '../../../domain/usecases/home_usecase.dart';
import 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final HomeUsecase _homeUsecase;
  final ISecureStorageManager _secureStorage;
  final QrisUsecase _qrisUsecase;
  final ProfileUseCase _profileUseCase;
  final DatabaseHelper2 _databaseHelper;
  final ICameraService _cameraService;

  HomeCubit(
    this._homeUsecase,
    this._secureStorage,
    this._qrisUsecase,
    this._databaseHelper,
    this._profileUseCase,
    this._cameraService,
  ) : super(const HomeState());

  Future<void> initialize() async {
    emit(state.copyWith(status: HomeStatus.loading));
    if (kDebugMode) {
      final debugPrefs = locator<AppPreferences>();
      // Tanpa guard — sengaja selalu overwrite biar gampang gonta-ganti value pas testing
      await debugPrefs.saveNomorObjekPengawasan('357813000190704537');
      await debugPrefs.saveShiftObjekPengawasan(ShiftPengawasan.shift2);
      await debugPrefs.saveJenisObjekPengawasan(JenisPengawasan.dishub);
    }

    final recoveredSession = await _cameraService.recoverLostAndroidPhoto();
    if (recoveredSession != null && !isClosed) {
      AppLogger.debug(
        '>>> [HOME SATPAM] Menemukan sesi tertinggal untuk: ${recoveredSession.intent}',
      );
      emit(state.copyWith(recoveredSession: recoveredSession));
    }

    await _loadProfileInfo();

    formatUserName();

    if (state.role == RoleLoginDigitalParkir.jukir) {
      await loadDashboarJukir();
      await _profileUseCase.getProfilePicturePath();
    } else if (state.role == RoleLoginDigitalParkir.pengawas) {
      final activeNop = _homeUsecase.getNomorObjekPengawasan();
      final activeShift = _homeUsecase.getShiftObjekPengawasan();
      final activeJenis = _homeUsecase.getJenisObjekPengawasan();

      //  2. GUARD CLAUSE (Zero State Logic)
      // Jika salah satu data belum lengkap, hentikan eksekusi API.
      if (activeNop == null ||
          activeNop.isEmpty ||
          activeShift == null ||
          activeJenis == null) {
        emit(state.copyWith(status: HomeStatus.needsSelection));
        return; //
      }

      // 3. JIKA DATA LENGKAP: Simpan ke State agar UI merender Header Dashboard
      emit(
        state.copyWith(
          nop: activeNop,
          shiftPengawasan: activeShift,
          jenisPengawasan: activeJenis,
        ),
      );

      // 4. TEMBAK API
      // Kirim parameter tersebut ke fungsi loadDashboardPengawas
      await loadDashboardPengawas(
        nomorObjek: activeNop,
        shift: activeShift.id,
        jenis: activeJenis.id,
      );
    } else {
      await _loadDashboardNonJukir();
      await checkOpLastUpdate();
      return;
    }

    await _qrisUsecase.syncQris();
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

  Future<void> loadDashboardPengawas({
    required String nomorObjek,
    required int shift,
    required int jenis,
  }) async {
    emit(state.copyWith(status: HomeStatus.loading));

    final result = await _homeUsecase.getDashboardSummaryPengawas(
      nomorObjek: nomorObjek,
      shift: shift,
      jenis: jenis,
    );

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
                detailAlatCheckIn: [],
                detailAlatCheckOut: [],
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

    //  1. BEHAVIOR KHUSUS JUKIR (NOP Statis Menempel dari Secured Storage)
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

    //  2. BEHAVIOR KHUSUS PENGAWAS (Hanya ambil nama)
    if (userRole == RoleLoginDigitalParkir.pengawas) {
      final activeNamaLokasi = _homeUsecase.getNamaObjekPengawasan();
      final activeNop = _homeUsecase.getNomorObjekPengawasan();
      emit(
        state.copyWith(
          namaJukir: namaUserShort,
          nop: activeNop ?? '',
          namaOp: activeNamaLokasi ?? '',
        ),
      );
      return;
    }

    //  3. BEHAVIOR NON-JUKIR (WP, Bapenda, dll)
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

    String? formattedName;

    final uptbMatch = RegExp(r'UPTB(\d+)').firstMatch(upper);

    if (uptbMatch != null) {
      formattedName = 'UPTB-${uptbMatch.group(1)}';
    } else if (upper.startsWith('PD')) {
      formattedName = userName.substring(2);
    } else {
      formattedName = null;
    }

    AppLogger.debug("isi namaJukirFormatted : $formattedName");

    emit(state.copyWith(namaJukirFormatted: formattedName));
  }

  Future<void> checkOpLastUpdate() async {
    final result = await _homeUsecase.getOpLastUpdate();

    result.fold(
      (failure) {
        AppLogger.error('Gagal mengecek update OP: ${failure.message}');
      },
      (isSame) {
        emit(state.copyWith(isOpUpToDate: isSame));
      },
    );
  }

  void clearRecoveredSession() {
    if (!isClosed) {
      // Freezed langsung paham kita ingin mengosongkan field ini
      emit(state.copyWith(recoveredSession: null));
    }
  }
}
