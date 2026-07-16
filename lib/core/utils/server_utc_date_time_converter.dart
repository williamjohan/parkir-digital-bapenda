import 'package:json_annotation/json_annotation.dart';

/// Converter global untuk standardisasi format waktu backend Bapenda.
/// Mengubah DateTime menjadi ISO-8601 UTC string (yyyy-MM-ddTHH:mm:ss.mmmZ).
class ServerUtcDateTimeConverter implements JsonConverter<DateTime, String> {
  const ServerUtcDateTimeConverter();

  @override
  DateTime fromJson(String json) {
    return DateTime.tryParse(json)?.toLocal() ?? DateTime.now();
  }

  @override
  String toJson(DateTime object) {
    return object.toServerUtcString();
  }
}

/// Extension global agar bisa dipanggil langsung tanpa model jika dibutuhkan
/// Contoh: startDate.toServerUtcString() -> "2026-07-16T07:55:17.000Z"
extension ServerDateTimeExt on DateTime {
  String toServerUtcString() {
    final utc = toUtc();
    final isoString = utc.toIso8601String();
    if (isoString.length >= 23) {
      return "${isoString.substring(0, 23)}Z";
    }
    return isoString;
  }
}
