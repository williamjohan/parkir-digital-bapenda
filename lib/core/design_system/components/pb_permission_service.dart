import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:parkir_digital_bapenda/core/design_system/components/pb_permission_required_dialog.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> ensureCameraAndLocationPermission(
    BuildContext context,
  ) async {
    // 1. Camera
    final camera = await Permission.camera.request();

    if (!camera.isGranted) {
      await PermissionRequiredDialog.show(
        context,
        icon: Icons.photo_camera_rounded,
        title: "Izin Kamera Dibutuhkan",
        description:
            "Aplikasi memerlukan akses kamera agar Anda dapat mengambil foto absensi.",
      );
      return false;
    }

    // 2. Location Permission
    final location = await Permission.location.request();

    if (!location.isGranted) {
      await PermissionRequiredDialog.show(
        context,
        icon: Icons.location_on_rounded,
        title: "Izin Lokasi Dibutuhkan",
        description:
            "Aktifkan izin lokasi agar sistem dapat memverifikasi lokasi absensi Anda.",
      );
      return false;
    }

    // 3. GPS
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      await PermissionRequiredDialog.show(
        context,
        icon: Icons.gps_off_rounded,
        title: "GPS Belum Aktif",
        description:
            "Silakan aktifkan GPS terlebih dahulu agar lokasi dapat dideteksi.",
        onConfirm: () {
          Geolocator.openLocationSettings();
        },
      );
      return false;
    }

    return true;
  }
}
