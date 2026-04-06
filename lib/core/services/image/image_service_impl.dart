import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:injectable/injectable.dart';
import '../../utils/app_logger.dart';
import 'i_image_service.dart';

@LazySingleton(as: IImageService)
class ImageServiceImpl implements IImageService {
  @override
  Future<String?> compressAndSaveImage({
    required File originalFile,
    required String fileName,
  }) async {
    try {
      final tempDir = await getTemporaryDirectory();

      // Amunisi Awal (Kita mulai dari kualitas lumayan)
      int currentQuality = 35;
      int currentSize = 350;
      String? bestPath;

      // 🚀 THE SMART COMPRESSION LOOP (Maksimal 4x Percobaan)
      for (int i = 1; i <= 4; i++) {
        // Buat nama file unik per percobaan agar tidak bentrok
        final targetPath = '${tempDir.path}/${fileName}_v$i.jpg';

        final compressedXFile = await FlutterImageCompress.compressAndGetFile(
          originalFile.absolute.path,
          targetPath,
          quality: currentQuality,
          minWidth: currentSize,
          minHeight: currentSize,
        );

        if (compressedXFile == null) break;

        final fileLength = await compressedXFile.length();
        bestPath = compressedXFile.path;

        AppLogger.debug(
          '>>> [COMPRESSION v$i] Ukuran: $fileLength bytes (Target: < 10000)',
        );

        // Bapenda minta 10KB (10240 bytes). Kita kasih batas aman di 10000 bytes.
        if (fileLength <= 10000) {
          AppLogger.debug(
            '>>> [COMPRESSION SUCCESS] Foto lolos sensor Bapenda!',
          );
          return bestPath;
        }

        // Jika masih gendut (> 10KB), hapus file percobaan ini agar memori tidak penuh
        if (i < 4) {
          File(bestPath).deleteSync();
        }

        // 🚀 PENGETATAN SABUK: Pangkas kualitas dan resolusi untuk putaran selanjutnya!
        currentQuality -= 10; // Kualitas turun (35 -> 25 -> 15 -> 5)
        currentSize -= 80; // Resolusi turun (350 -> 270 -> 190 -> 110)
      }

      // Jika setelah 4 kali di-press masih gagal tembus target (sangat mustahil terjadi),
      // kita kirimkan hasil perasan terakhir yang paling kecil.
      return bestPath;
    } catch (e) {
      AppLogger.error('Gagal kompresi gambar', e);
      return null;
    }
  }

  @override
  Future<void> deleteImage(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        AppLogger.debug('File cache dihapus: $path');
      }
    } catch (e) {
      AppLogger.error('Gagal hapus file cache', e);
    }
  }
}
