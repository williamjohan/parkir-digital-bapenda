// lib/core/utils/app_lifecycle_utils.dart

import 'package:flutter/services.dart';
import 'app_logger.dart';

class AppLifecycleUtils {
  AppLifecycleUtils._();

  // Nama channel komunikasi antara Flutter dan Native Android
  static const MethodChannel _channel = MethodChannel(
    'com.bapenda.parkir/app_retain',
  );

  /// Memerintahkan OS (Android) untuk meminimalkan aplikasi ke background
  static Future<void> sendToBackground() async {
    try {
      await _channel.invokeMethod('sendToBackground');
      AppLogger.info('Aplikasi berhasil diminimalkan ke background.');
    } on PlatformException catch (e, stackTrace) {
      AppLogger.error('Gagal meminimalkan aplikasi', e, stackTrace);
    }
  }
}
