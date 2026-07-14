import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/features/pengawasan/domain/entities/laporan_pengawasan/laporan_pengawasan_entity.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/services/location/i_app_location_service.dart';
import '../../../../core/services/permission/i_permission_service.dart';
import '../../../../core/utils/photo_utils.dart';
import '../../domain/constants/jenis_pelanggaran_dummy.dart';
import '../../domain/usecases/pengawasan_usecase.dart';
import 'pengawasan_state.dart';

@injectable
class PengawasanCubit extends Cubit<PengawasanState> {
  final AddPengawasanUsecase _addPengawasanUsecase;
  final GetLaporanPengawasanUsecase _getLaporanPengawasanUsecase;
  final IPermissionService _permissionService;
  final IAppLocationService _locationService;
  final ImagePicker _picker = ImagePicker();

  PengawasanCubit(
    this._addPengawasanUsecase,
    this._getLaporanPengawasanUsecase,
    this._permissionService,
    this._locationService,
  ) : super(const PengawasanState());

  void loadJenisPelanggaran() {
    emit(state.copyWith(jenisPelanggaran: dummyJenisPelanggaran));
  }

  // Langsung emit ke state.request
  void setJenisPelanggaran(int jenisPel) {
    emit(state.copyWith(request: state.request.copyWith(jenisPel: jenisPel)));
  }

  void setKeterangan(String value) {
    emit(state.copyWith(keteranganText: value));
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

  // --- LOGIC AMBIL FOTO MENTAH ---
  Future<void> pickAndSetPhoto() async {
    try {
      // 🛡️ PERTAHANAN 2: Cek izin kamera & GPS sebelum buka kamera
      final canProceed = await _guardCameraAndLocationPermissions();
      if (!canProceed || isClosed) return;

      final XFile? image = await PhotoUtils.pickPhoto(_picker);
      if (image == null) return;

      emit(
        state.copyWith(
          rawPhoto: File(image.path),
          photoTakenAt: DateTime.now(),
        ),
      );

      // Otomatis langsung perbarui lokasi begitu foto didapatkan
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

  // void setFoto(File foto) {
  //   emit(state.copyWith(request: state.request.copyWith(buktiFoto: foto)));
  // }

  // void removeFoto() {
  //   emit(state.copyWith(request: state.request.copyWith(buktiFoto: null)));
  // }

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
              op: "",
              nip: "",
              tglRoster: DateTime(2000, 1, 1),
              jadwalMasuk: DateTime(2000, 1, 1),
              jenisPel: 0,
              ketPel: "",
              insDate: DateTime(2000, 1, 1),
              insBy: "",
              seq: 0,
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
          errorMessage:
              "Izin lokasi ditolak permanen. Aktifkan di Pengaturan agar bisa melapor.",
        ),
      );
      return false;
    } else if (locStatus == AppPermissionStatus.denied) {
      emit(
        state.copyWith(
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
          errorMessage:
              "Izin kamera ditolak permanen. Aktifkan di Pengaturan untuk foto bukti.",
        ),
      );
      return false;
    } else if (camStatus == AppPermissionStatus.denied) {
      emit(
        state.copyWith(
          errorMessage:
              "Izin kamera wajib diberikan untuk mengambil foto bukti.",
        ),
      );
      return false;
    }

    return await _guardLocationPermissions();
  }

  void reset() {
    if (!isClosed) emit(const PengawasanState());
  }
}
