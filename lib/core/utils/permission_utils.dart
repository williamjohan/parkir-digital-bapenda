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
      // 1. Lakukan request untuk semua permission
      final statuses = await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.locationWhenInUse,
      ].request();

      final scanStatus =
          statuses[Permission.bluetoothScan] ?? PermissionStatus.denied;
      final connectStatus =
          statuses[Permission.bluetoothConnect] ?? PermissionStatus.denied;
      final locationStatus =
          statuses[Permission.locationWhenInUse] ?? PermissionStatus.denied;

      AppLogger.debug("bluetoothScan = $scanStatus");
      AppLogger.debug("bluetoothConnect = $connectStatus");
      AppLogger.debug("location = $locationStatus");

      // 2. Jika semuanya diizinkan
      if (scanStatus.isGranted &&
          connectStatus.isGranted &&
          locationStatus.isGranted) {
        return BluetoothPermissionStatus.granted;
      }

      // 3. Pengecekan Agresif: Cek apakah ADA SALAH SATU yang ditolak permanen
      if (scanStatus.isPermanentlyDenied ||
          connectStatus.isPermanentlyDenied ||
          locationStatus.isPermanentlyDenied) {
        AppLogger.error("Izin ditolak permanen terdeteksi dari hasil request.");
        return BluetoothPermissionStatus.permanentlyDenied;
      }

      // 4. Fallback Cek Manual: Kadang OS menyembunyikan status 'permanentlyDenied'
      // di dalam status 'denied' biasa jika pop-up sudah diblokir sistem.
      if (await Permission.locationWhenInUse.isPermanentlyDenied ||
          await Permission.bluetoothScan.isPermanentlyDenied ||
          await Permission.bluetoothConnect.isPermanentlyDenied) {
        AppLogger.error("Izin ditolak permanen terdeteksi dari cek manual.");
        return BluetoothPermissionStatus.permanentlyDenied;
      }

      // 5. Jika benar-benar baru ditolak pertama kali (pop-up OS masih bisa muncul)
      return BluetoothPermissionStatus.denied;
    } catch (e, stackTrace) {
      AppLogger.error('Gagal mengecek permission bluetooth', e, stackTrace);
      return BluetoothPermissionStatus.error;
    }
  }
}
