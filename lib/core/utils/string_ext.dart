// lib/core/extensions/string_ext.dart

extension StringExtension on String {
  /// Mengubah nama menjadi format pendek tanpa titik di akhir:
  /// - "Teguh" -> "Teguh"
  /// - "Teguh Aprianto" -> "Teguh A"
  /// - "Teguh Aprianto Wibowo" -> "Teguh A.W"
  /// - "Teguh Aprianto Wibowo Putra" -> "Teguh A.W"
  String get shortName {
    if (trim().isEmpty) return this;

    // Pecah string berdasarkan 1 atau lebih spasi
    final parts = trim().split(RegExp(r'\s+'));

    // Jika hanya 1 kata, kembalikan apa adanya
    if (parts.length == 1) return parts.first;

    final String firstName = parts.first;

    // 🚀 BEST PRACTICE DART: Functional approach
    // 1. Lewati kata pertama (skip)
    // 2. Ambil maksimal 2 kata berikutnya (take)
    // 3. Ambil huruf pertama dari tiap kata & jadikan kapital (map)
    // 4. Gabungkan dengan titik di tengahnya SAJA (join)
    final String initials = parts
        .skip(1)
        .take(2)
        .map((word) => word[0].toUpperCase())
        .join('.');

    return '$firstName $initials';
  }
}
