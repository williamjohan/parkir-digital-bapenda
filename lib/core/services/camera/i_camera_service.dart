import 'dart:io';
import '../../enums/app_enums.dart';
import 'recovered_camera_session.dart';

abstract class ICameraService {
  /// Mengambil foto dengan pembatasan memori ketat dan mencatat informasi modul ke disk
  Future<File?> takePhoto({required CameraModuleIntent intent});

  /// Menyelamatkan foto sekaligus membaca KTP modul yang hilang akibat Process Death
  Future<RecoveredCameraSession?> recoverLostAndroidPhoto();
}
