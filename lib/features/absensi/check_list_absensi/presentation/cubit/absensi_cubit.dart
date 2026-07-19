import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/core/services/location/i_app_location_service.dart';
import '../../../../../core/enums/app_enums.dart';
import '../../../../../core/services/camera/i_camera_service.dart';
import '../../../../../core/services/permission/i_permission_service.dart';
import '../../domain/entities/absensi_entity.dart';
import '../../domain/usecases/absensi_usecase.dart';
import 'absensi_state.dart';

const Map<String, int> kInstrumentIds = {'EDC': 1, 'QRIS': 2, 'TSpark': 3};

@injectable
class AbsensiCubit extends Cubit<AbsensiState> {
  final AbsensiUsecase _usecase;
  final IPermissionService _permissionService;
  final IAppLocationService _locationService;
  final ICameraService _cameraService;

  AbsensiCubit(
    this._usecase,
    this._permissionService,
    this._locationService,
    this._cameraService,
  ) : super(const AbsensiState());

  Future<void> initPage({File? recoveredPhoto}) async {
    if (recoveredPhoto != null) {
      emit(
        state.copyWith(
          rawPhoto: recoveredPhoto,
          photoTakenAt: DateTime.now(),
          errorMessage: '',
        ),
      );
    }
    await fetchLocation();
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
      final canProceed = await _guardLocationPermissions();
      if (!canProceed || isClosed) return;

      // 🚀 Langsung gunakan _locationService milik Cubit!
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
        state.copyWith(
          latitude: null,
          longitude: null,
          placeName: null,
          locationError: e.toString(),
          isFetchingLocation: false,
        ),
      );
    }
  }

  // --- AMBIL FOTO  ---
  Future<void> takePhoto({required bool isCheckIn}) async {
    try {
      emit(state.copyWith(status: AbsensiStatus.initial, errorMessage: ''));

      final canProceed = await _guardCameraAndLocationPermissions();
      if (!canProceed || isClosed) return;

      final intentTag = isCheckIn
          ? CameraModuleIntent.absensiCheckIn
          : CameraModuleIntent.absensiCheckOut;

      final file = await _cameraService.takePhoto(intent: intentTag);
      if (file == null) return;

      emit(state.copyWith(rawPhoto: file, photoTakenAt: DateTime.now()));

      await fetchLocation();
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(errorMessage: "Gagal mengambil foto dari kamera"));
    }
  }

  void removePhoto() {
    emit(
      state.copyWith(
        rawPhoto: null,
        watermarkedPhoto: null,
        photoTakenAt: null,
      ),
    );
  }

  void setCapturing(bool isCapturing) {
    emit(state.copyWith(isCapturing: isCapturing));
  }

  void setWatermarkedPhoto(File watermarkedFile) {
    emit(state.copyWith(watermarkedPhoto: watermarkedFile));
  }

  // --- INPUT FORM ---
  void setMotorText(String value) {
    emit(state.copyWith(motorText: value));
  }

  void setMobilText(String value) {
    emit(state.copyWith(mobilText: value));
  }

  void toggleEdc(bool value) => emit(state.copyWith(edc: value));
  void toggleQris(bool value) => emit(state.copyWith(qris: value));
  void toggleTsPark(bool value) => emit(state.copyWith(tsPark: value));

  // --- SUBMIT ---
  Future<void> submitAbsensi({required bool isCheckIn}) async {
    if (state.watermarkedPhoto == null) {
      emit(
        state.copyWith(
          status: AbsensiStatus.failure,
          errorMessage: "Foto belum diproses, coba ambil ulang",
        ),
      );
      return;
    }

    if (state.latitude == null || state.longitude == null) {
      emit(
        state.copyWith(
          status: AbsensiStatus.failure,
          errorMessage: "Lokasi belum terdeteksi, coba lagi",
        ),
      );
      return;
    }

    emit(state.copyWith(status: AbsensiStatus.loading, errorMessage: ''));

    final detailAlatIds = [
      if (state.edc) kInstrumentIds['EDC']!,
      if (state.qris) kInstrumentIds['QRIS']!,
      if (state.tsPark) kInstrumentIds['TSpark']!,
    ];

    final entity = AbsensiEntity(
      latitude: state.latitude!,
      longitude: state.longitude!,
      totalMotor: state.totalMotor,
      totalMobil: state.totalMobil,
      detailAlatIds: detailAlatIds,
      fotoPath: state.watermarkedPhoto!.path,
      isCheckIn: isCheckIn,
    );

    final result = await _usecase.postAbsensi(entity);

    result.fold(
      (failure) {
        if (!isClosed) {
          emit(
            state.copyWith(
              status: AbsensiStatus.failure,
              errorMessage: failure.message,
            ),
          );
        }
      },
      (_) {
        if (!isClosed) {
          emit(state.copyWith(status: AbsensiStatus.success));
        }
      },
    );
  }

  void reset() {
    if (!isClosed) emit(const AbsensiState());
  }

  // ===========================================================================
  // 🛡️ PRIVATE PERMISSION GUARDS (CLEAN ARCHITECTURE)
  // ===========================================================================

  Future<bool> _guardLocationPermissions() async {
    final locStatus = await _permissionService.requestPermission(
      AppPermissionType.location,
    );
    if (locStatus == AppPermissionStatus.permanentlyDenied) {
      emit(
        state.copyWith(
          status: AbsensiStatus.permissionDenied,
          deniedPermissionType: AppPermissionType.location,
          errorMessage:
              "Izin lokasi ditolak permanen. Aktifkan di Pengaturan agar bisa melanjutkan.",
        ),
      );
      return false;
    } else if (locStatus == AppPermissionStatus.denied) {
      emit(
        state.copyWith(
          status: AbsensiStatus.failure,
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
          status: AbsensiStatus.gpsOff,
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
          status: AbsensiStatus.permissionDenied,
          deniedPermissionType: AppPermissionType.camera,
          errorMessage:
              "Izin kamera ditolak permanen. Aktifkan di Pengaturan OS.",
        ),
      );
      return false;
    } else if (camStatus == AppPermissionStatus.denied) {
      emit(
        state.copyWith(
          status: AbsensiStatus.failure,
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
}
