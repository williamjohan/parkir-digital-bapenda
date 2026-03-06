// lib/core/utils/permission_utils.dart

import 'package:dartz/dartz.dart';
import 'package:permission_handler/permission_handler.dart';
// Asumsi: Pastikan import class Failure Anda di sini
// import '../errors/failures.dart';
import 'app_logger.dart';

enum CameraPermissionStatus { granted, denied, permanentlyDenied, error }

class PermissionUtils {
  PermissionUtils._();

  static Future<Either<dynamic, CameraPermissionStatus>>
  requestCameraPermission() async {
    try {
      final status = await Permission.camera.request();

      if (status.isGranted) return const Right(CameraPermissionStatus.granted);
      if (status.isPermanentlyDenied) {
        return const Right(CameraPermissionStatus.permanentlyDenied);
      }

      return const Right(CameraPermissionStatus.denied);
    } catch (e, stackTrace) {
      AppLogger.error('Gagal mengecek permission kamera', e, stackTrace);
      // Ganti 'dynamic' dan 'Exception' di bawah dengan class Failure Anda, misal: ServerFailure()
      return Left(Exception('Terjadi kesalahan sistem saat meminta izin: $e'));
    }
  }
}
