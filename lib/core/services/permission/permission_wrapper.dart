import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:parkir_digital_bapenda/core/design_system/components/pb_permission_required_dialog.dart';
import 'package:parkir_digital_bapenda/core/services/permission/permission_type.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> ensure(
    BuildContext context, {
    required List<PermissionType> permissions,
  }) async {
    for (final permission in permissions) {
      switch (permission) {
        case PermissionType.camera:
          final status = await Permission.camera.request();

          if (!status.isGranted) {
            await PermissionRequiredDialog.show(
              context,
              icon: Icons.photo_camera_rounded,
              title: "Izin Kamera Dibutuhkan",
              description:
                  "Aktifkan izin kamera agar fitur ini dapat digunakan.",
            );
            return false;
          }
          break;

        case PermissionType.location:
          final status = await Permission.location.request();

          if (!status.isGranted) {
            await PermissionRequiredDialog.show(
              context,
              icon: Icons.location_on_rounded,
              title: "Izin Lokasi Dibutuhkan",
              description:
                  "Aktifkan izin lokasi agar fitur ini dapat digunakan.",
            );
            return false;
          }
          break;

        case PermissionType.locationService:
          final enabled = await Geolocator.isLocationServiceEnabled();

          if (!enabled) {
            await PermissionRequiredDialog.show(
              context,
              icon: Icons.gps_off_rounded,
              title: "GPS Belum Aktif",
              description: "Silakan aktifkan GPS terlebih dahulu.",
              onConfirm: () => Geolocator.openLocationSettings(),
            );
            return false;
          }
          break;

        case PermissionType.notification:
          final status = await Permission.notification.request();

          if (!status.isGranted) {
            await PermissionRequiredDialog.show(
              context,
              icon: Icons.notifications_active_rounded,
              title: "Izin Notifikasi Dibutuhkan",
              description:
                  "Aktifkan izin notifikasi agar aplikasi dapat mengirim pemberitahuan.",
            );
            return false;
          }
          break;

        case PermissionType.microphone:
          final status = await Permission.microphone.request();

          if (!status.isGranted) {
            await PermissionRequiredDialog.show(
              context,
              icon: Icons.mic_rounded,
              title: "Izin Mikrofon Dibutuhkan",
              description:
                  "Aktifkan izin mikrofon agar fitur ini dapat digunakan.",
            );
            return false;
          }
          break;

        case PermissionType.storage:
          final status = await Permission.storage.request();

          if (!status.isGranted) {
            await PermissionRequiredDialog.show(
              context,
              icon: Icons.folder_rounded,
              title: "Izin Penyimpanan Dibutuhkan",
              description:
                  "Aktifkan izin penyimpanan agar fitur ini dapat digunakan.",
            );
            return false;
          }
          break;

        case PermissionType.photos:
          final status = await Permission.photos.request();

          if (!status.isGranted) {
            await PermissionRequiredDialog.show(
              context,
              icon: Icons.photo_library_rounded,
              title: "Izin Galeri Dibutuhkan",
              description:
                  "Aktifkan izin galeri agar fitur ini dapat digunakan.",
            );
            return false;
          }
          break;

        case PermissionType.bluetooth:
          final status = await Permission.bluetoothConnect.request();

          if (!status.isGranted) {
            await PermissionRequiredDialog.show(
              context,
              icon: Icons.bluetooth_rounded,
              title: "Izin Bluetooth Dibutuhkan",
              description:
                  "Aktifkan izin Bluetooth agar fitur ini dapat digunakan.",
            );
            return false;
          }
          break;
      }
    }

    return true;
  }
}
