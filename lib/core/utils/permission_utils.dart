import 'package:dartz/dartz.dart';
import 'package:permission_handler/permission_handler.dart';
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
      return Left(Exception('Terjadi kesalahan sistem saat meminta izin: $e'));
    }
  }

  static Future<bool> requestBluetoothPermission() async {
    try {
      final statuses = await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.locationWhenInUse,
      ].request();

      AppLogger.debug("bluetoothScan = ${statuses[Permission.bluetoothScan]}");
      AppLogger.debug(
        "bluetoothConnect = ${statuses[Permission.bluetoothConnect]}",
      );
      AppLogger.debug("location = ${statuses[Permission.locationWhenInUse]}");

      return statuses.values.every((status) => status.isGranted);
    } catch (e, stackTrace) {
      AppLogger.error('Gagal meminta permission bluetooth', e, stackTrace);
      return false;
    }
  }
}
