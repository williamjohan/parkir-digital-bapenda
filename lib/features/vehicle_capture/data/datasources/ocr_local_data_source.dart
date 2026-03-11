import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/utils/app_logger.dart';

abstract class IOcrLocalDataSource {
  Future<String> recognizeText(String imagePath);
}

@LazySingleton(as: IOcrLocalDataSource)
class OcrLocalDataSourceImpl implements IOcrLocalDataSource {
  @override
  Future<String> recognizeText(String imagePath) async {
    // Inisialisasi di luar try agar bisa diakses oleh blok finally
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    try {
      AppLogger.info('Memulai proses OCR pada gambar: $imagePath');
      final inputImage = InputImage.fromFilePath(imagePath);

      final RecognizedText recognizedText = await textRecognizer.processImage(
        inputImage,
      );

      List<TextLine> allLines = [];
      for (TextBlock block in recognizedText.blocks) {
        allLines.addAll(
          block.lines,
        ); // Cara Dart yang lebih elegan dari for-loop
      }

      if (allLines.isEmpty) {
        AppLogger.warning('OCR tidak menemukan teks sama sekali.');
        return ''; // Aman, kita kembalikan string kosong
      }

      double maxHeight = 0;
      for (var line in allLines) {
        if (line.boundingBox.height > maxHeight) {
          maxHeight = line.boundingBox.height;
        }
      }

      List<String> validTextLines = [];
      final double heightThreshold = maxHeight * 0.35;

      for (var line in allLines) {
        if (line.boundingBox.height >= heightThreshold) {
          validTextLines.add(line.text);
        } else {
          AppLogger.debug(
            'Teks dibuang karena terlalu kecil (Noise): ${line.text}',
          );
        }
      }

      final String filteredRawText = validTextLines.join('\n');
      AppLogger.debug('Teks hasil Spatial Filter:\n$filteredRawText');
      return filteredRawText;
    } catch (e, stackTrace) {
      AppLogger.error('ML Kit Text Recognition Gagal', e, stackTrace);
      throw const OcrException(
        message: 'Gagal mengekstrak teks menggunakan ML Kit.',
      );
    } finally {
      // [PERBAIKAN ARSITEKTUR MEMORI]
      // Blok finally ini HARGA MATI. textRecognizer akan selalu ditutup
      // meskipun teks kosong (return '') atau terjadi error (catch).
      await textRecognizer.close();
      AppLogger.info(
        'ML Kit TextRecognizer berhasil ditutup dan memori dibersihkan.',
      );
    }
  }
}
