import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../enums/app_enums.dart';
import '../../utils/app_logger.dart';
import 'i_camera_service.dart';
import 'recovered_camera_session.dart';

@LazySingleton(as: ICameraService)
class CameraService implements ICameraService {
  final ImagePicker _picker;
  final SharedPreferences _prefs;

  static const String _kCameraIntentKey = 'pending_camera_intent_tag';

  CameraService(this._picker, this._prefs);

  @override
  Future<File?> takePhoto({required CameraModuleIntent intent}) async {
    try {
      // 1. CATAT KE DISK: Simpan identitas modul sebelum buka kamera eksternal
      await _prefs.setString(_kCameraIntentKey, intent.name);

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      // 2. BERSIHKAN DISK: Jika foto lancar (tanpa crash LMK), hapus tag dari disk
      await _prefs.remove(_kCameraIntentKey);

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e, stackTrace) {
      // Bersihkan tag jika terjadi error pembatalan/kamera rusak
      await _prefs.remove(_kCameraIntentKey);
      AppLogger.error('Gagal mengambil foto dari kamera', e, stackTrace);
      return null;
    }
  }

  @override
  Future<RecoveredCameraSession?> recoverLostAndroidPhoto() async {
    // Fitur retrieveLostData hanya relevan untuk OS Android
    if (defaultTargetPlatform != TargetPlatform.android) return null;

    try {
      final LostDataResponse response = await _picker.retrieveLostData();

      if (response.isEmpty || response.file == null) {
        return null;
      }

      // 1. BACA DISK: Modul apa yang menembak kamera ini sebelum OS mati?
      final String? savedIntentName = _prefs.getString(_kCameraIntentKey);

      // 2. BERSIHKAN DISK: Hapus tag setelah bukti pembacaan diambil
      await _prefs.remove(_kCameraIntentKey);

      // 3. COCOKKAN ENUM
      final intentEnum = CameraModuleIntent.values.firstWhere(
        (e) => e.name == savedIntentName,
        orElse: () => CameraModuleIntent.unknown,
      );

      AppLogger.debug(
        '>>> [LMK RECOVERY] Berhasil menyelamatkan foto untuk modul: $intentEnum',
      );

      return RecoveredCameraSession(
        file: File(response.file!.path),
        intent: intentEnum,
      );
    } catch (e) {
      AppLogger.error('Gagal memproses retrieveLostData', e);
      return null;
    }
  }
}
