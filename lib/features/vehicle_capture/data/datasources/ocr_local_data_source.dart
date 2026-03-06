// lib/features/vehicle_capture/data/datasources/ocr_local_data_source.dart

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/utils/app_logger.dart';

abstract class IOcrLocalDataSource {
  /// Memproses gambar dan mengembalikan teks yang sudah difilter secara spasial
  Future<String> recognizeText(String imagePath);
}

@LazySingleton(as: IOcrLocalDataSource)
class OcrLocalDataSourceImpl implements IOcrLocalDataSource {
  @override
  Future<String> recognizeText(String imagePath) async {
    try {
      AppLogger.info('Memulai proses OCR pada gambar: $imagePath');

      final inputImage = InputImage.fromFilePath(imagePath);
      final textRecognizer = TextRecognizer(
        script: TextRecognitionScript.latin,
      );

      final RecognizedText recognizedText = await textRecognizer.processImage(
        inputImage,
      );

      // Wajib ditutup untuk mencegah Memory Leak
      await textRecognizer.close();

      // --- MULAI IMPLEMENTASI STRATEGI 1: SPATIAL LOGICAL CROPPING ---

      // 1. Kumpulkan semua baris teks (TextLine) dari gambar
      List<TextLine> allLines = [];
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          allLines.add(line);
        }
      }

      // Jika kosong, langsung kembalikan string kosong
      if (allLines.isEmpty) {
        AppLogger.warning('OCR tidak menemukan teks sama sekali.');
        return '';
      }

      // 2. Cari ukuran teks terbesar (Tinggi/Height dari Bounding Box)
      // Asumsi: Pelat nomor utama pasti dicetak paling besar di pelat.
      double maxHeight = 0;
      for (var line in allLines) {
        if (line.boundingBox.height > maxHeight) {
          maxHeight = line.boundingBox.height;
        }
      }

      // 3. Filter Baris Teks (Pembersihan Noise / Frame)
      List<String> validTextLines = [];

      // Threshold heuristik: Teks yang tingginya kurang dari 35% teks terbesar
      // dianggap sebagai "noise" (merek frame, stiker, baut).
      // Masa berlaku (03.26) biasanya sekitar 40-50% dari tinggi huruf utama, jadi akan tetap lolos.
      final double heightThreshold = maxHeight * 0.35;

      for (var line in allLines) {
        if (line.boundingBox.height >= heightThreshold) {
          // Lolos filter! Tambahkan ke kandidat teks
          validTextLines.add(line.text);
        } else {
          // Teks dibuang
          AppLogger.debug(
            'Teks dibuang karena terlalu kecil (Noise): ${line.text}',
          );
        }
      }

      // Gabungkan teks yang lolos filter dengan baris baru (newline)
      final String filteredRawText = validTextLines.join('\n');

      AppLogger.debug('Teks hasil Spatial Filter:\n$filteredRawText');
      return filteredRawText;
    } catch (e, stackTrace) {
      AppLogger.error('ML Kit Text Recognition Gagal', e, stackTrace);
      throw const OcrException(
        message: 'Gagal mengekstrak teks menggunakan ML Kit.',
      );
    }
  }
}
