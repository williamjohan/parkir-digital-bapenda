// lib/core/utils/file_utils.dart

import 'dart:io';
import 'app_logger.dart'; // Pastikan import logger kita

class FileUtils {
  FileUtils._(); // Private constructor agar tidak bisa di-instantiate

  /// Menghapus file secara aman berdasarkan path.
  /// Sangat berguna untuk membersihkan cache gambar kamera.
  static Future<void> deleteFile(String? path) async {
    if (path == null || path.isEmpty) return;

    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        AppLogger.info('File cache berhasil dibersihkan: $path');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Gagal membersihkan file cache', e, stackTrace);
    }
  }
}
