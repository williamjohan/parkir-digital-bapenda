import 'dart:io';

abstract class IImageService {
  Future<String?> compressAndSaveImage({
    required File originalFile,
    required String fileName,
    int maxTargetBytes = 300000,
    int minResolution = 1024,
  });

  Future<void> deleteImage(String path);
}
