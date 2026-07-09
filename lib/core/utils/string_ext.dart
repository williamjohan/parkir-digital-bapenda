extension StringExtension on String {
  /// Mengubah nama menjadi format pendek tanpa titik di akhir:
  /// - "Teguh" -> "Teguh"
  /// - "Teguh Aprianto" -> "Teguh A"
  /// - "Teguh Aprianto Wibowo" -> "Teguh A.W"
  /// - "Teguh Aprianto Wibowo Putra" -> "Teguh A.W"
  String get shortName {
    if (trim().isEmpty) return this;
    final parts = trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first;

    final String firstName = parts.first;
    final String initials = parts
        .skip(1)
        .take(2)
        .map((word) => word[0].toUpperCase())
        .join('.');

    return '$firstName $initials';
  }
}
