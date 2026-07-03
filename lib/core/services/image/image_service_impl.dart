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
    int maxTargetBytes = 300000, // Default 300 KB
    int minResolution = 1024,
  }) async {
    try {
      final tempDir = await getTemporaryDirectory();

      // 🚀 Algoritma Step-Down yang Lebih Manusiawi & Menjaga Kualitas Visual
      int currentQuality = 85;
      int currentSize = minResolution;
      String? bestPath;

      // Maksimal 3 kali percobaan agar CPU tidak bekerja terlalu keras
      for (int i = 1; i <= 3; i++) {
        final targetPath = '${tempDir.path}/${fileName}_v$i.jpg';

        final compressedXFile = await FlutterImageCompress.compressAndGetFile(
          originalFile.absolute.path,
          targetPath,
          quality: currentQuality,
          minWidth: currentSize,
          minHeight: currentSize,
          format: CompressFormat.jpeg,
        );

        if (compressedXFile == null) break;

        final fileLength = await compressedXFile.length();
        bestPath = compressedXFile.path;

        AppLogger.debug(
          '>>> [COMPRESSION v$i] Ukuran: ${(fileLength / 1024).toStringAsFixed(2)} KB (Target: < ${(maxTargetBytes / 1024).toStringAsFixed(0)} KB)',
        );

        // Jika ukuran sudah di bawah target, langsung kembalikan path
        if (fileLength <= maxTargetBytes) {
          AppLogger.debug(
            '>>> [COMPRESSION SUCCESS] Foto tajam & lolos sensor Bapenda!',
          );
          return bestPath;
        }

        // 🚀 Asynchronous Deletion (Tidak me-lock UI Event Loop)
        if (i < 3) {
          final oldFile = File(bestPath);
          if (await oldFile.exists()) {
            await oldFile.delete();
          }
        }

        // Penurunan bertahap yang aman (misal: 85 -> 65 -> 45)
        currentQuality -= 20;
        // Resolusi sedikit diturunkan namun tidak boleh di bawah 600px
        if (currentSize > 600) {
          currentSize = (currentSize * 0.8).toInt();
        }
      }

      // Jika setelah 3 loop masih sedikit di atas target, tetap kembalikan hasil terbaik
      // daripada mengorbankan foto menjadi blur total.
      return bestPath;
    } catch (e, stackTrace) {
      AppLogger.error('Gagal kompresi gambar', e, stackTrace);
      return null;
    }
  }

  @override
  Future<void> deleteImage(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete(); // 🚀 Ganti ke async
        AppLogger.debug('File cache dihapus: $path');
      }
    } catch (e) {
      AppLogger.error('Gagal hapus file cache', e);
    }
  }
}
