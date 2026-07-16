import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
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

  static void debug(dynamic message) {
    _logger.d(message);
    // 🚀 BREADCRUMB: Catat jejak di latar belakang saat mode Release
    if (!kDebugMode) {
      FirebaseCrashlytics.instance.log("🐛 [DEBUG]: $message");
    }
  }

  static void info(dynamic message) {
    _logger.i(message);
    // 🚀 BREADCRUMB: Catat jejak navigasi / aksi user
    if (!kDebugMode) {
      FirebaseCrashlytics.instance.log("ℹ️ [INFO]: $message");
    }
  }

  static void warning(dynamic message) {
    _logger.w(message);
    if (!kDebugMode) {
      FirebaseCrashlytics.instance.log("⚠️ [WARN]: $message");
    }
  }

  static void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    // 1. Tetap print cantik di console emulator (Debug)
    _logger.e(message, error: error, stackTrace: stackTrace);

    // 🚀 2. NON-FATAL REPORTING: Kirim ke Crashlytics saat mode Release
    if (!kDebugMode) {
      FirebaseCrashlytics.instance.recordError(
        error ?? message,
        stackTrace ?? StackTrace.current,
        reason: message.toString(),
        // Set false karena ini adalah error yang BERHASIL ditangkap oleh try-catch Cubit kita
        fatal: false,
      );
    }
  }
}
