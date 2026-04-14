// lib/core/utils/device_id_utils.dart

import 'package:uuid/uuid.dart';
import '../storage/secure_storage_manager.dart';

class DeviceIdUtils {
  /// 🚀 Mendapatkan Device ID unik yang aman.
  /// Jika belum ada di brankas, buat baru dan simpan permanen.
  static Future<String> getSecureDeviceId(
    ISecureStorageManager secureStorage,
  ) async {
    try {
      // 1. Coba ambil dari brankas lokal menggunakan metode spesifik Anda
      String? existingId = await secureStorage.getDeviceId();

      if (existingId != null && existingId.isNotEmpty) {
        return existingId; // Kembalikan ID yang sudah pernah dibuat
      }

      // 2. Jika tidak ada, Generate UUID v4 baru
      const uuid = Uuid();
      final String newDeviceId = uuid.v4();

      // 3. Simpan ke brankas menggunakan metode spesifik Anda
      await secureStorage.saveDeviceId(newDeviceId);

      return newDeviceId;
    } catch (e) {
      // Fallback Darurat
      return 'FALLBACK-${DateTime.now().millisecondsSinceEpoch}';
    }
  }
}
