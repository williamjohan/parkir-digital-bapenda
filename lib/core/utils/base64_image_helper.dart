import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Base64ImageHelper {
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
      final filePath = '${directory.path}/qris_statis_$jenisKendaraanId.png';
      final file = File(filePath);
      await file.writeAsBytes(bytes);
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

      // 🚀 Nama file dibuat spesifik per-user
      final filePath = '${directory.path}/profile_picture_$username.png';

      final file = File(filePath);
      await file.writeAsBytes(bytes);

      return filePath;
    } catch (e) {
      throw Exception('Gagal menyimpan foto profil: $e');
    }
  }
}
