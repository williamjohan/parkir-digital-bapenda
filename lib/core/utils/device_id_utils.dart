// lib/core/utils/device_id_utils.dart

import 'package:uuid/uuid.dart';
import '../storage/secure_storage_manager.dart';

class DeviceIdUtils {
  /// 🚀 Mendapatkan Device ID unik yang aman.
  /// Jika belum ada di brankas (atau datanya korup), buat baru dan simpan permanen.
  static Future<String> getSecureDeviceId(
    ISecureStorageManager secureStorage,
  ) async {
    try {
      // 1. Coba ambil dari brankas
      String? existingId = await secureStorage.getDeviceId();

      // 🚀 [PENGAMAN BERLAPIS]: Tolak jika null, kosong, cuma spasi, atau terlalu pendek!
      // UUID minimal punya 32-36 karakter. Kita set minimal 10 karakter untuk mentolerir format lain.
      if (existingId != null &&
          existingId.trim().isNotEmpty &&
          existingId.trim() != '-' &&
          existingId.length > 10) {
        return existingId.trim();
      }

      // 2. Jika tidak ada / tidak valid, Generate UUID v4 baru
      const uuid = Uuid();
      final String newDeviceId = uuid.v4();

      // 3. Simpan paksa ke brankas untuk menimpa data sampah (seperti '-')
      await secureStorage.saveDeviceId(newDeviceId);

      return newDeviceId;
    } catch (e) {
      // Fallback Darurat
      return 'FALLBACK-${DateTime.now().millisecondsSinceEpoch}';
    }
  }
}
