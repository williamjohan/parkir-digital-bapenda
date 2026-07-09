import 'package:flutter/material.dart'; // 🚀 TAMBAHKAN INI UNTUK SHOWDIALOG
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

  // 🚀 PERBAIKAN: Tambahkan parameter BuildContext context
  static Future<bool> requestBluetoothPermission(BuildContext context) async {
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
        AppLogger.error(
          "Izin Bluetooth/Lokasi ditolak permanen. Menampilkan dialog...",
        );

        if (context.mounted) {
          await _showPermissionDialog(context);
        }
        return false;
      }

      return statuses.values.every((status) => status.isGranted);
    } catch (e, stackTrace) {
      AppLogger.error('Gagal mengecek permission bluetooth', e, stackTrace);
      return false;
    }
  }

  // 🚀 TAMBAHKAN: Fungsi internal kustom untuk menampilkan pop-up dialog
  static Future<void> _showPermissionDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User wajib berinteraksi dengan tombol
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.gpp_maybe_rounded, color: Colors.amber, size: 28),
              SizedBox(width: 8),
              Text(
                'Akses Izin Diperlukan',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          content: const Text(
            'Anda telah menolak izin Perangkat Sekitar (Bluetooth) atau Lokasi aplikasi ini.\n\n'
            'Mohon aktifkan izin tersebut secara manual melalui pengaturan aplikasi agar fitur printer dapat digunakan kembali.',
            style: TextStyle(fontSize: 14, height: 1.4),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Batal',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Buka Pengaturan',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await openAppSettings(); // 🚀 Buka halaman pengaturan HP otomatis
              },
            ),
          ],
        );
      },
    );
  }
}
