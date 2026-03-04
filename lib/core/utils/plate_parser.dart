// lib/core/utils/plate_parser.dart

import 'app_logger.dart';

class PlateParser {
  PlateParser._(); // Private constructor

  /// Fungsi untuk mengekstrak plat nomor dari teks mentah hasil OCR.
  /// Mengembalikan [String] plat nomor jika ditemukan, atau [null] jika gagal.
  static String? extractPlateNumber(String rawText) {
    try {
      // Membersihkan karakter aneh dan newline ganda
      final cleanText = rawText.toUpperCase().replaceAll(
        RegExp(r'[^A-Z0-9\s]'),
        '',
      );

      // Regex Plat Nomor Indonesia:
      // \b        : Batas kata (word boundary)
      // [A-Z]{1,2}: 1 atau 2 huruf kapital di depan (Contoh: L, B, AB)
      // \s* : Spasi 0 atau lebih (karena kadang OCR membaca L 1234 atau L1234)
      // \d{1,4}   : 1 sampai 4 angka (Contoh: 1, 123, 1234)
      // \s* : Spasi 0 atau lebih
      // [A-Z]{0,3}: 0 sampai 3 huruf kapital di belakang (Contoh: kosong, A, BC, RFS)
      // \b        : Batas kata
      final regex = RegExp(r'\b([A-Z]{1,2})\s*(\d{1,4})\s*([A-Z]{0,3})\b');

      // Cari kecocokan di dalam teks mentah
      final match = regex.firstMatch(cleanText);

      if (match != null) {
        // Gabungkan hasil tangkapan Regex tanpa spasi untuk distandarisasi
        // Contoh: "L   1234  AB" menjadi "L 1234 AB"
        final kodeWilayah = match.group(1) ?? '';
        final nomor = match.group(2) ?? '';
        final hurufBelakang = match.group(3) ?? '';

        final formattedPlate = '$kodeWilayah $nomor $hurufBelakang'.trim();

        AppLogger.info(
          'Plat ditemukan: $formattedPlate dari rawText: $rawText',
        );
        return formattedPlate;
      }

      AppLogger.warning(
        'Tidak ada pola plat nomor yang cocok dalam rawText: $rawText',
      );
      return null;
    } catch (e, stackTrace) {
      AppLogger.error('Error saat mengekstrak plat nomor', e, stackTrace);
      return null;
    }
  }
}
