import 'package:flutter/services.dart';
import 'app_logger.dart';

class AppLifecycleUtils {
  AppLifecycleUtils._();
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
