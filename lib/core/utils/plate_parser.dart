// lib/core/utils/plate_parser.dart

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
    // 1. Pecah teks menjadi baris-baris (Line-by-Line Scanning)
    final lines = rawText.split('\n');

    for (var line in lines) {
      // 2. Pembersihan Awal: Hapus karakter aneh, ubah ke uppercase
      String cleanLine = line.toUpperCase().replaceAll(
        RegExp(r'[^A-Z0-9]'),
        '',
      );

      // Lewati baris yang terlalu pendek (bukan pelat)
      if (cleanLine.length < 3) continue;

      // 3. Heuristik Pemotongan Masa Berlaku (03.26)
      // Jika baris hanya berisi 4 angka berturut-turut tanpa huruf, abaikan (kemungkinan tanggal expired)
      if (RegExp(r'^\d{4}$').hasMatch(cleanLine)) continue;

      // 4. Proses "Optical Character Correction"
      // Kita coba tebak strukturnya dan perbaiki karakter yang tertukar
      String? correctedPlate = _applyCorrectionHeuristics(cleanLine);

      if (correctedPlate != null) {
        return correctedPlate; // Kembalikan format cantik: "B 1234 ABC"
      }
    }

    return null; // Gagal menemukan pelat di semua baris
  }

  /// Algoritma pintar untuk memperbaiki kesalahan baca ML Kit
  static String? _applyCorrectionHeuristics(String rawString) {
    // Memaksa format pelat menggunakan variasi Regex yang toleran terhadap spasi
    // Kita gunakan looping atau manipulasi index, tapi cara termudah adalah
    // mengecek pola yang paling masuk akal.

    // Contoh sederhana: Cari angka pertama untuk memisahkan Prefix dan Body
    int firstDigitIndex = rawString.indexOf(RegExp(r'\d'));
    int lastDigitIndex = rawString.lastIndexOf(RegExp(r'\d'));

    if (firstDigitIndex == -1 || firstDigitIndex == 0) {
      // Tidak ada angka, atau angka di depan (Pelat Indonesia harus diawali huruf)
      // Kita bisa coba konversi: Jika huruf pertama '8', mungkin itu 'B'
      if (rawString.startsWith('8')) {
        rawString = 'B' + rawString.substring(1);
        firstDigitIndex = rawString.indexOf(RegExp(r'\d'));
      } else {
        return null;
      }
    }

    if (firstDigitIndex > 2)
      return null; // Kode wilayah maksimal 2 huruf (B, AB, W, L, dst)

    try {
      // Pisahkan zona
      String prefix = rawString.substring(0, firstDigitIndex);
      String numbers = rawString.substring(firstDigitIndex, lastDigitIndex + 1);
      String suffix = rawString.substring(lastDigitIndex + 1);

      // CORRECTION ZONE 1: PREFIX (Wajib Huruf)
      prefix = prefix
          .replaceAll('0', 'O')
          .replaceAll('1', 'I')
          .replaceAll('5', 'S')
          .replaceAll('8', 'B');

      // CORRECTION ZONE 2: NUMBERS (Wajib Angka)
      numbers = numbers
          .replaceAll('O', '0')
          .replaceAll('I', '1')
          .replaceAll('S', '5')
          .replaceAll('B', '8');

      // CORRECTION ZONE 3: SUFFIX (Wajib Huruf)
      suffix = suffix
          .replaceAll('0', 'O')
          .replaceAll('1', 'I')
          .replaceAll('5', 'S')
          .replaceAll('8', 'B');

      // Validasi ulang dengan Regex strict
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
