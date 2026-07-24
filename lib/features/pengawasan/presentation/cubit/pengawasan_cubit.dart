import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/features/pengawasan/domain/entities/laporan_pengawasan/laporan_pengawasan_entity.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/services/camera/i_camera_service.dart';
import '../../../../core/services/location/i_app_location_service.dart';
import '../../../../core/services/permission/i_permission_service.dart';
import '../../domain/entities/jenis_pelanggaran/jenis_pelanggaran_entity.dart';
import '../../domain/usecases/pengawasan_usecase.dart';
import 'pengawasan_state.dart';

@injectable
class PengawasanCubit extends Cubit<PengawasanState> {
  final AddPengawasanUsecase _addPengawasanUsecase;
  final GetLaporanPengawasanUsecase _getLaporanPengawasanUsecase;
  final GetJenisPelanggaranUsecase _getJenisPelanggaranUsecase;
  final IPermissionService _permissionService;
  final IAppLocationService _locationService;
  final ICameraService _cameraService;

  PengawasanCubit(
    this._addPengawasanUsecase,
    this._getLaporanPengawasanUsecase,
    this._getJenisPelanggaranUsecase,
    this._permissionService,
    this._locationService,
    this._cameraService,
  ) : super(const PengawasanState());

  Future<void> initPage({File? recoveredPhoto}) async {
    // 1. Muat master data jenis pelanggaran
    await getJenisPelanggaran();

    // 2. Jika halaman dibuka hasil lemparan LMK(Low Memory Killer) dari Home bawa foto selamat:
    if (recoveredPhoto != null) {
      emit(
        state.copyWith(
          rawPhoto: recoveredPhoto,
          photoTakenAt: DateTime.now(),
          errorMessage: null,
        ),
      );
    }

    await fetchLocation();
  }

  // Langsung emit ke state.request
  void setJenisPelanggaran(int jenisPel) {
    emit(state.copyWith(request: state.request.copyWith(jenisPel: jenisPel)));
  }

  // --- LOGIC LOKASI ---
  Future<void> fetchLocation() async {
    emit(
      state.copyWith(
        isFetchingLocation: true,
        locationError: null,
        latitude: null,
        longitude: null,
        placeName: null,
      ),
    );
    try {
      // 🛡️ PERTAHANAN 1: Cek izin & sensor GPS sebelum akses hardware
      final canProceed = await _guardLocationPermissions();
      if (!canProceed || isClosed) return;

      final result = await _locationService.getCurrentLocation();
      if (isClosed) return;

      emit(
        state.copyWith(
          latitude: double.tryParse(result.latitude),
          longitude: double.tryParse(result.longitude),
          placeName: result.address,
          isFetchingLocation: false,
        ),
      );
    } catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(locationError: e.toString(), isFetchingLocation: false),
      );
    }
  }

  // --- LOGIC AMBIL FOTO  ---
  Future<void> pickAndSetPhoto() async {
    try {
      emit(
        state.copyWith(status: PengawasanStatus.initial, errorMessage: null),
      );

      final canProceed = await _guardCameraAndLocationPermissions();
      if (!canProceed || isClosed) return;

      //  Panggil lewat ICameraService dengan KTP modul Pengawasan!
      final file = await _cameraService.takePhoto(
        intent: CameraModuleIntent.pengawasan,
      );
      if (file == null) return;

      emit(state.copyWith(rawPhoto: file, photoTakenAt: DateTime.now()));

      await fetchLocation();
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(errorMessage: "Gagal mengambil foto dari kamera"));
    }
  }

  // Simpan foto yang sudah di-watermark ke dalam state.request sebelum submit
  void setWatermarkedPhoto(File watermarkedFile) {
    emit(
      state.copyWith(
        request: state.request.copyWith(buktiFoto: watermarkedFile),
      ),
    );
  }

  // Bersihkan juga properti di dalam state.request saat foto dihapus
  void removePhoto() {
    emit(
      state.copyWith(
        rawPhoto: null,
        photoTakenAt: null,
        request: state.request.copyWith(buktiFoto: null),
      ),
    );
  }

  void setCapturing(bool isCapturing) {
    emit(state.copyWith(isCapturing: isCapturing));
  }

  // Fungsi submit sekarang hanya butuh ketPel, sisanya membaca langsung dari state.request
  Future<void> submit(String ketPel) async {
    // Gabungkan keterangan terbaru ke dalam request final
    final finalRequest = state.request.copyWith(ketPel: ketPel.trim());

    // Validasi bisnis logic di Cubit
    if (finalRequest.buktiFoto == null) {
      emit(state.copyWith(errorMessage: 'Foto bukti wajib diambil.'));
      return;
    }

    if (finalRequest.jenisPel == 0) {
      emit(state.copyWith(errorMessage: 'Jenis pelanggaran wajib dipilih.'));
      return;
    }

    if (finalRequest.ketPel.isEmpty) {
      emit(state.copyWith(errorMessage: 'Keterangan wajib diisi.'));
      return;
    }

    emit(state.copyWith(isLoading: true, isSuccess: false, errorMessage: null));

    try {
      // Kirim objek request yang sudah lengkap
      await _addPengawasanUsecase(finalRequest);
      if (isClosed) return;
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> getJenisPelanggaran() async {
    emit(
      state.copyWith(
        isLoadingJenisPelanggaran: true,
        errorMessage: null,
        jenisPelanggaran: List.generate(
          5,
          (_) => const JenisPelanggaranEntity(
            id: 0,
            namaPelanggaran: 'Jenis Pelanggaran',
            jenisPelanggaran: JenisPengawasan.bapenda,
          ),
        ),
      ),
    );

    try {
      final result = await _getJenisPelanggaranUsecase();

      if (isClosed) return;

      emit(
        state.copyWith(
          isLoadingJenisPelanggaran: false,
          jenisPelanggaran: result,
        ),
      );
    } catch (e) {
      if (isClosed) return;

      emit(
        state.copyWith(
          isLoadingJenisPelanggaran: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> getLaporanPengawasan() async {
    if (!isClosed) {
      emit(
        state.copyWith(
          isLoadingLaporan: true,
          errorMessage: null,
          laporanFake: List<LaporanPengawasanEntity>.generate(
            4,
            (_) => LaporanPengawasanEntity(
              idEvent: 0,
              nip: '',
              opd: '',
              kdCamat: '',
              nmCamat: '',
              kdOp: '',
              nmOp: '',
              jenis: 0,
              shift: 0,
              tglPengawasan: DateTime(2000, 1, 1),
              seq: 0,
              jenisPel: 0,
              ketPel: '',
              insDate: DateTime(2000, 1, 1),
              insBy: '',
              fotoPelaporan: null,
            ),
          ),
        ),
      );
    }

    try {
      final result = await _getLaporanPengawasanUsecase();

      if (isClosed) return;

      emit(state.copyWith(isLoadingLaporan: false, laporan: result));
    } catch (e) {
      if (isClosed) return;

      emit(state.copyWith(isLoadingLaporan: false, errorMessage: e.toString()));
    }
  }
  // ===========================================================================
  // 🛡️ PRIVATE PERMISSION GUARDS
  // ===========================================================================

  Future<bool> _guardLocationPermissions() async {
    final locStatus = await _permissionService.requestPermission(
      AppPermissionType.location,
    );
    if (locStatus == AppPermissionStatus.permanentlyDenied) {
      emit(
        state.copyWith(
          status: PengawasanStatus.permissionDenied,
          deniedPermissionType: AppPermissionType.location,
          errorMessage:
              "Izin lokasi ditolak permanen. Aktifkan di Pengaturan agar bisa melanjutkan.",
        ),
      );
      return false;
    } else if (locStatus == AppPermissionStatus.denied) {
      emit(
        state.copyWith(
          status: PengawasanStatus.failure,
          errorMessage:
              "Izin lokasi wajib diberikan untuk mencatat koordinat pelanggaran.",
        ),
      );
      return false;
    }

    final gpsStatus = await _permissionService.requestPermission(
      AppPermissionType.locationService,
    );
    if (gpsStatus == AppPermissionStatus.permanentlyDenied) {
      emit(
        state.copyWith(
          status: PengawasanStatus.gpsOff,
          deniedPermissionType: AppPermissionType.locationService,
          errorMessage: "Sensor GPS belum aktif. Silakan nyalakan GPS HP Anda.",
        ),
      );
      return false;
    }

    return true;
  }

  Future<bool> _guardCameraAndLocationPermissions() async {
    final camStatus = await _permissionService.requestPermission(
      AppPermissionType.camera,
    );
    if (camStatus == AppPermissionStatus.permanentlyDenied) {
      emit(
        state.copyWith(
          status: PengawasanStatus.permissionDenied,
          deniedPermissionType: AppPermissionType.camera,
          errorMessage:
              "Izin kamera ditolak permanen. Aktifkan di Pengaturan OS.",
        ),
      );
      return false;
    } else if (camStatus == AppPermissionStatus.denied) {
      emit(
        state.copyWith(
          status: PengawasanStatus.failure,
          errorMessage:
              "Izin kamera wajib diberikan untuk mengambil foto bukti.",
        ),
      );
      return false;
    }
    return await _guardLocationPermissions();
  }

  Future<void> openAppSettings() async {
    await _permissionService.openSettings();
  }

  Future<void> openLocationSettings() async {
    await _permissionService.openLocationSettings();
  }

  void reset() {
    if (!isClosed) emit(const PengawasanState());
  }
}
