class PlateParser {
  PlateParser._();

  /// Regex Pelat Indonesia Standar
  /// Group 1: Kode Wilayah (1-2 Huruf)
  /// Group 2: Nomor (1-4 Angka)
  /// Group 3: Seri Wilayah (0-3 Huruf)
  static final RegExp _plateRegex = RegExp(
    r'^([A-Z]{1,2})\s*(\d{1,4})\s*([A-Z]{0,3})$',
  );

  /// Fungsi utama yang dipanggil oleh UseCase
  static String? extractPlateNumber(String rawText) {
    final lines = rawText.split('\n');

    for (var line in lines) {
      String cleanLine = line.toUpperCase().replaceAll(
        RegExp(r'[^A-Z0-9]'),
        '',
      );
      if (cleanLine.length < 3) continue;
      if (RegExp(r'^\d{4}$').hasMatch(cleanLine)) continue;
      String? correctedPlate = _applyCorrectionHeuristics(cleanLine);

      if (correctedPlate != null) {
        return correctedPlate; // Kembalikan format cantik: "B 1234 ABC"
      }
    }

    return null; // Gagal menemukan pelat di semua baris
  }

  /// Algoritma pintar untuk memperbaiki kesalahan baca ML Kit
  static String? _applyCorrectionHeuristics(String rawString) {
    int firstDigitIndex = rawString.indexOf(RegExp(r'\d'));
    int lastDigitIndex = rawString.lastIndexOf(RegExp(r'\d'));

    if (firstDigitIndex == -1 || firstDigitIndex == 0) {
      if (rawString.startsWith('8')) {
        rawString = 'B${rawString.substring(1)}';
        firstDigitIndex = rawString.indexOf(RegExp(r'\d'));
      } else {
        return null;
      }
    }

    if (firstDigitIndex > 2) {
      return null; // Kode wilayah maksimal 2 huruf (B, AB, W, L, dst)
    }

    try {
      String prefix = rawString.substring(0, firstDigitIndex);
      String numbers = rawString.substring(firstDigitIndex, lastDigitIndex + 1);
      String suffix = rawString.substring(lastDigitIndex + 1);
      prefix = prefix
          .replaceAll('0', 'O')
          .replaceAll('1', 'I')
          .replaceAll('5', 'S')
          .replaceAll('8', 'B');
      numbers = numbers
          .replaceAll('O', '0')
          .replaceAll('I', '1')
          .replaceAll('S', '5')
          .replaceAll('B', '8');
      suffix = suffix
          .replaceAll('0', 'O')
          .replaceAll('1', 'I')
          .replaceAll('5', 'S')
          .replaceAll('8', 'B');
      String candidate = '$prefix $numbers $suffix'.trim();
      if (_plateRegex.hasMatch(candidate.replaceAll(' ', ''))) {
        return candidate;
      }
    } catch (e) {
      return null;
    }

    return null;
  }
}
