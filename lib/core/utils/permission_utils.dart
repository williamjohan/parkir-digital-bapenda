import 'package:dartz/dartz.dart';
import 'package:permission_handler/permission_handler.dart';
import 'app_logger.dart';

enum CameraPermissionStatus { granted, denied, permanentlyDenied, error }

// 🚀 TAMBAHKAN ENUM BARU UNTUK BLUETOOTH
enum BluetoothPermissionStatus { granted, denied, permanentlyDenied, error }

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

  // 🚀 PERBAIKAN: Hapus BuildContext, ubah tipe kembalian menjadi BluetoothPermissionStatus
  static Future<BluetoothPermissionStatus> requestBluetoothPermission() async {
    try {
      final statuses = await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.locationWhenInUse,
      ].request();

      final scanStatus = statuses[Permission.bluetoothScan];
      final connectStatus = statuses[Permission.bluetoothConnect];
      final locationStatus = statuses[Permission.locationWhenInUse];

      AppLogger.debug("bluetoothScan = $scanStatus");
      AppLogger.debug("bluetoothConnect = $connectStatus");
      AppLogger.debug("location = $locationStatus");

      // 🔍 JIKA USER PILIH "JANGAN IZINKAN" / PERMANENTLY DENIED
      if (scanStatus == PermissionStatus.permanentlyDenied ||
          connectStatus == PermissionStatus.permanentlyDenied ||
          locationStatus == PermissionStatus.permanentlyDenied) {
        AppLogger.error("Izin Bluetooth/Lokasi ditolak permanen.");
        return BluetoothPermissionStatus.permanentlyDenied; // Kembalikan status
      }

      final isGranted = statuses.values.every((status) => status.isGranted);

      if (isGranted) {
        return BluetoothPermissionStatus.granted;
      } else {
        return BluetoothPermissionStatus.denied;
      }
    } catch (e, stackTrace) {
      AppLogger.error('Gagal mengecek permission bluetooth', e, stackTrace);
      return BluetoothPermissionStatus.error;
    }
  }
}
