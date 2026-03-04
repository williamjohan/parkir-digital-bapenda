// lib/features/vehicle_capture/data/datasources/ocr_local_data_source.dart

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/utils/app_logger.dart';

abstract class IOcrLocalDataSource {
  /// Memproses gambar dan mengembalikan raw string dari ML Kit
  Future<String> recognizeText(String imagePath);
}

@LazySingleton(as: IOcrLocalDataSource)
class OcrLocalDataSourceImpl implements IOcrLocalDataSource {
  @override
  Future<String> recognizeText(String imagePath) async {
    try {
      AppLogger.info('Memulai proses OCR pada gambar: $imagePath');

      // 1. Buat instance input image dari path file
      final inputImage = InputImage.fromFilePath(imagePath);

      // 2. Inisialisasi TextRecognizer (kita pakai Latin script standar)
      final textRecognizer = TextRecognizer(
        script: TextRecognitionScript.latin,
      );

      // 3. Eksekusi proses pembacaan
      final RecognizedText recognizedText = await textRecognizer.processImage(
        inputImage,
      );

      // CATATAN ARSITEK (Mitigasi Memory Leak):
      // Engine ML Kit sangat berat. Kita WAJIB menutupnya (close) setelah selesai digunakan
      // agar tidak terjadi kebocoran memori (memory leak) yang membuat HP jukir panas/crash.
      await textRecognizer.close();

      AppLogger.debug(
        'OCR Selesai. Teks mentah ditemukan:\n${recognizedText.text}',
      );
      return recognizedText.text;
    } catch (e, stackTrace) {
      AppLogger.error('ML Kit Text Recognition Gagal', e, stackTrace);
      // Lempar Exception khusus milik kita agar ditangkap oleh Repository
      throw const OcrException(
        message: 'Gagal mengekstrak teks menggunakan ML Kit.',
      );
    }
  }
}
