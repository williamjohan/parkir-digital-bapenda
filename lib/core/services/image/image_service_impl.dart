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
      final targetPath = '${tempDir.path}/$fileName.jpg';

      final compressedXFile = await FlutterImageCompress.compressAndGetFile(
        originalFile.absolute.path,
        targetPath,
        quality: 30,
        minWidth: 400,
        minHeight: 400,
      );

      if (compressedXFile != null) {
        return compressedXFile.path;
      }
      return null;
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
