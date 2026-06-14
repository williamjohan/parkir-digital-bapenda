import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class QrisImageHelper {
  /// Mengubah string Base64 menjadi file fisik .png dan mengembalikan path-nya.
  static Future<String> saveQrisBase64ToFile({
    required int jenisKendaraanId,
    required String base64String,
  }) async {
    try {
      // 1. Bersihkan prefix Base64 jika Backend mengirimnya (misal: "data:image/png;base64,")
      String cleanBase64 = base64String;
      if (cleanBase64.contains(',')) {
        cleanBase64 = cleanBase64.split(',').last;
      }

      // 2. Decode string menjadi bytes
      final bytes = base64Decode(cleanBase64);

      // 3. Dapatkan direktori aman di dalam HP (Application Documents)
      final directory = await getApplicationDocumentsDirectory();

      // 4. Rakit nama file yang unik berdasarkan ID Kendaraan
      final filePath = '${directory.path}/qris_statis_$jenisKendaraanId.png';

      // 5. Tulis bytes tersebut ke dalam file fisik
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      // 6. Kembalikan alamat file-nya saja
      return filePath;
    } catch (e) {
      throw Exception('Gagal menyimpan gambar QRIS: $e');
    }
  }
}
