import 'package:uuid/uuid.dart';
import '../storage/secure_storage_manager.dart';

class DeviceIdUtils {
  static Future<String> getSecureDeviceId(
    ISecureStorageManager secureStorage,
  ) async {
    try {
      String? existingId = await secureStorage.getDeviceUUID();
      if (existingId != null &&
          existingId.trim().isNotEmpty &&
          existingId.trim() != '-' &&
          existingId.length > 10) {
        return existingId.trim();
      }
      const uuid = Uuid();
      final String newDeviceId = uuid.v4();
      await secureStorage.saveDeviceUUID(newDeviceId);

      return newDeviceId;
    } catch (e) {
      return 'FALLBACK-${DateTime.now().millisecondsSinceEpoch}';
    }
  }
}
