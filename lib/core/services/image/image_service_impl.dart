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
      int currentQuality = 35;
      int currentSize = 350;
      String? bestPath;
      for (int i = 1; i <= 4; i++) {
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
        if (fileLength <= 10000) {
          AppLogger.debug(
            '>>> [COMPRESSION SUCCESS] Foto lolos sensor Bapenda!',
          );
          return bestPath;
        }
        if (i < 4) {
          File(bestPath).deleteSync();
        }
        currentQuality -= 10; // Kualitas turun (35 -> 25 -> 15 -> 5)
        currentSize -= 80; // Resolusi turun (350 -> 270 -> 190 -> 110)
      }
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
