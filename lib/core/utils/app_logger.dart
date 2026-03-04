// lib/core/utils/app_logger.dart

import 'package:logger/logger.dart';

class AppLogger {
  AppLogger._(); // Private constructor untuk mencegah instansiasi

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 1, // Berapa banyak method stack yang diprint
      errorMethodCount: 5, // Stacktrace jika terjadi error
      lineLength: 80,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.none,
    ),
  );

  static void debug(dynamic message) => _logger.d(message);

  static void info(dynamic message) => _logger.i(message);

  static void warning(dynamic message) => _logger.w(message);

  static void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}
