// lib/core/network/env_config.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  // Pastikan inisialisasi ini dipanggil di main.dart: await dotenv.load();
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';
}
