class FileUtils {
  FileUtils._(); // Private constructor

  /// Menghasilkan nama file yang seragam dan unik untuk transaksi parkir.
  /// Contoh output: "trx_L1234AB_1710574829384"
  static String generateTransactionFileName(String nopol) {
    final cleanNopol = nopol.replaceAll(' ', '').toUpperCase();
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    return 'trx_${cleanNopol}_$timestamp';
  }

  /// Mengambil ekstensi dari sebuah string path file (contoh: '.jpg', '.png').
  static String getFileExtension(String path) {
    if (!path.contains('.')) return '';
    return path.substring(path.lastIndexOf('.'));
  }

  /// Mengekstrak nama file dari string path lengkap.
  /// Contoh: "/data/user/0/cache/foto.jpg" -> "foto.jpg"
  static String getFileNameFromPath(String path) {
    if (!path.contains('/')) return path;
    return path.split('/').last;
  }
}
