import 'package:uuid/uuid.dart';
import '../storage/secure_storage_manager.dart';

class DeviceIdUtils {
  /// 🚀 Mendapatkan Device ID unik yang aman.
  /// Jika belum ada di brankas (atau datanya korup), buat baru dan simpan permanen.
  static Future<String> getSecureDeviceId(
    ISecureStorageManager secureStorage,
  ) async {
    try {
      String? existingId = await secureStorage.getDeviceId();
      if (existingId != null &&
          existingId.trim().isNotEmpty &&
          existingId.trim() != '-' &&
          existingId.length > 10) {
        return existingId.trim();
      }
      const uuid = Uuid();
      final String newDeviceId = uuid.v4();
      await secureStorage.saveDeviceId(newDeviceId);

      return newDeviceId;
    } catch (e) {
      return 'FALLBACK-${DateTime.now().millisecondsSinceEpoch}';
    }
  }
}
