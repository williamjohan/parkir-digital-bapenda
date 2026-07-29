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
  // 🆕 Key tambahan untuk menyelamatkan konteks absensi (nop/jenis/shift)
  // dari process death, sama seperti _kCameraIntentKey.
  static const String _kCameraNopKey = 'pending_camera_nop';
  static const String _kCameraJenisKey = 'pending_camera_jenis';
  static const String _kCameraShiftKey = 'pending_camera_shift';

  CameraService(this._picker, this._prefs);

  @override
  Future<File?> takePhoto({
    required CameraModuleIntent intent,
    String? nop, // 🆕
    JenisPengawasan? jenis, // 🆕
    ShiftPengawasan? shift, // 🆕
  }) async {
    try {
      // 1. CATAT KE DISK: Simpan identitas modul sebelum buka kamera eksternal
      await _prefs.setString(_kCameraIntentKey, intent.name);

      // 🆕 Simpan juga konteks absensi kalau ada. PENTING: kalau nilainya
      // null (misal dipanggil dari modul pengawasan), key LAMA harus tetap
      // dibersihkan — supaya tidak ada nop dari sesi sebelumnya yang
      // "numpang" ke sesi baru yang sebenarnya tidak punya nop.
      await _persistOrClear(_kCameraNopKey, nop);
      await _persistOrClear(_kCameraJenisKey, jenis?.id.toString());
      await _persistOrClear(_kCameraShiftKey, shift?.id.toString());

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      // 2. BERSIHKAN DISK: Jika foto lancar (tanpa crash LMK), hapus semua tag
      await _clearPendingKeys();

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e, stackTrace) {
      // Bersihkan tag jika terjadi error pembatalan/kamera rusak
      await _clearPendingKeys();
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
      // 🆕 Baca juga konteks absensi yang sempat disimpan
      final String? savedNop = _prefs.getString(_kCameraNopKey);
      final int? savedJenisId = int.tryParse(
        _prefs.getString(_kCameraJenisKey) ?? '',
      );
      final int? savedShiftId = int.tryParse(
        _prefs.getString(_kCameraShiftKey) ?? '',
      );

      // 2. BERSIHKAN DISK: Hapus semua tag setelah bukti pembacaan diambil
      await _clearPendingKeys();

      // 3. COCOKKAN ENUM
      final intentEnum = CameraModuleIntent.values.firstWhere(
        (e) => e.name == savedIntentName,
        orElse: () => CameraModuleIntent.unknown,
      );

      JenisPengawasan? jenisEnum;
      if (savedJenisId != null) {
        for (final e in JenisPengawasan.values) {
          if (e.id == savedJenisId) {
            jenisEnum = e;
            break;
          }
        }
      }

      ShiftPengawasan? shiftEnum;
      if (savedShiftId != null) {
        for (final e in ShiftPengawasan.values) {
          if (e.id == savedShiftId) {
            shiftEnum = e;
            break;
          }
        }
      }

      AppLogger.debug(
        '>>> [LMK RECOVERY] Berhasil menyelamatkan foto untuk modul: $intentEnum '
        '(nop: "$savedNop", jenis: $jenisEnum, shift: $shiftEnum)',
      );

      return RecoveredCameraSession(
        file: File(response.file!.path),
        intent: intentEnum,
        nop: savedNop,
        jenis: jenisEnum,
        shift: shiftEnum,
      );
    } catch (e) {
      AppLogger.error('Gagal memproses retrieveLostData', e);
      return null;
    }
  }

  // 🆕 Helper: simpan kalau ada nilainya, atau hapus key lama kalau null.
  // Ini yang menjamin tidak ada data numpang antar-modul.
  Future<void> _persistOrClear(String key, String? value) async {
    if (value != null && value.isNotEmpty) {
      await _prefs.setString(key, value);
    } else {
      await _prefs.remove(key);
    }
  }

  Future<void> _clearPendingKeys() async {
    await _prefs.remove(_kCameraIntentKey);
    await _prefs.remove(_kCameraNopKey);
    await _prefs.remove(_kCameraJenisKey);
    await _prefs.remove(_kCameraShiftKey);
  }
}
