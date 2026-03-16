import 'dart:io';

abstract class IImageService {
  /// Mengompres gambar dan menyimpannya ke folder temporary/cache.
  /// Mengembalikan path lokasi file hasil kompresi.
  Future<String?> compressAndSaveImage({
    required File originalFile,
    required String fileName,
  });

  /// Menghapus file fisik dari memori
  Future<void> deleteImage(String path);
}
