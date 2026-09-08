import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Base64ImageHelper {
  /// 🚀 MENGHAPUS SEMUA GAMBAR QRIS LAMA (GARBAGE COLLECTOR)
  static Future<void> clearAllQrisImages() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final dir = Directory(directory.path);

      // Ambil semua file di direktori
      final files = dir.listSync();

      for (var file in files) {
        // Hapus hanya file yang memiliki prefix 'qris_'
        if (file is File && file.path.split('/').last.startsWith('qris_')) {
          if (file.existsSync()) {
            await file.delete();
          }
        }
      }
    } catch (e) {
      // Log error (opsional), tidak perlu throw exception agar tidak memblokir alur
    }
  }

  /// Mengubah string Base64 menjadi file fisik .png dan mengembalikan path-nya.
  static Future<String> saveQrisBase64ToFile({
    required int jenisKendaraanId,
    required String base64String,
  }) async {
    try {
      String cleanBase64 = base64String;
      if (cleanBase64.contains(',')) {
        cleanBase64 = cleanBase64.split(',').last;
      }
      final bytes = base64Decode(cleanBase64);
      final directory = await getApplicationDocumentsDirectory();

      // 🚀 CACHE BUSTING: Gunakan timestamp agar Flutter UI mau merender ulang
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath =
          '${directory.path}/qris_${jenisKendaraanId}_$timestamp.png';

      final file = File(filePath);
      await file.writeAsBytes(bytes, flush: true);

      return filePath;
    } catch (e) {
      throw Exception('Gagal menyimpan gambar QRIS: $e');
    }
  }

  static Future<String> saveProfileBase64ToFile({
    required String username,
    required String base64String,
  }) async {
    try {
      String cleanBase64 = base64String;
      if (cleanBase64.contains(',')) {
        cleanBase64 = cleanBase64.split(',').last;
      }
      final bytes = base64Decode(cleanBase64);
      final directory = await getApplicationDocumentsDirectory();

      // Catatan Auditor: Jika profile picture juga butuh merender ulang instan di UI,
      // pertimbangkan untuk menambahkan timestamp di sini juga seperti QRIS.
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath =
          '${directory.path}/profile_picture_${username}_$timestamp.png';

      final file = File(filePath);
      await file.writeAsBytes(bytes, flush: true);

      return filePath;
    } catch (e) {
      throw Exception('Gagal menyimpan foto profil: $e');
    }
  }
}
