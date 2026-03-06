// lib/core/utils/permission_utils.dart

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../design_system/components/pb_status_snackbar.dart';
import '../design_system/components/pb_permission_dialog.dart';
import 'app_logger.dart';

class PermissionUtils {
  PermissionUtils._();

  /// Mengecek dan meminta izin kamera.
  /// Mengembalikan [true] jika diizinkan, [false] jika ditolak.
  static Future<bool> requestCameraPermission(BuildContext context) async {
    try {
      final status = await Permission.camera.request();

      if (status.isGranted) {
        return true;
      }

      if (status.isPermanentlyDenied) {
        // Ditolak permanen (Never Ask Again) -> Paksa buka pengaturan HP
        if (context.mounted) {
          await PbPermissionDialog.show(
            context,
            title: 'Akses Kamera Diblokir',
            description:
                'Anda telah menolak akses kamera secara permanen. Mohon izinkan melalui Pengaturan HP agar bisa memotret plat nomor.',
          );
        }
        return false;
      }

      if (status.isDenied) {
        // Ditolak biasa -> Tampilkan Top Snackbar
        if (context.mounted) {
          PbStatusSnackbar.show(
            context,
            message: 'Akses kamera dibutuhkan untuk memotret kendaraan.',
            isError: true,
          );
        }
        return false;
      }

      return false;
    } catch (e, stackTrace) {
      AppLogger.error('Gagal mengecek permission kamera', e, stackTrace);
      return false;
    }
  }
}
