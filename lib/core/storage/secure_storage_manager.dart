// lib/core/storage/secure_storage_manager.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

abstract class ISecureStorageManager {
  Future<void> saveAccessToken(String token);
  Future<String?> getAccessToken();
  Future<void> saveRefreshToken(String token);
  Future<String?> getRefreshToken();
  Future<void> clearAllTokens();
  Future<bool> hasValidToken();
}

@LazySingleton(as: ISecureStorageManager)
class SecureStorageManagerImpl implements ISecureStorageManager {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Key konstan untuk menghindari typo
  static const String _keyAccessToken = 'ACCESS_TOKEN';
  static const String _keyRefreshToken = 'REFRESH_TOKEN';

  @override
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _keyAccessToken, value: token);
  }

  @override
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _keyAccessToken);
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _keyRefreshToken, value: token);
  }

  @override
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }

  @override
  Future<void> clearAllTokens() async {
    await _storage.delete(key: _keyAccessToken);
    await _storage.delete(key: _keyRefreshToken);
  }

  @override
  Future<bool> hasValidToken() async {
    final token = await getAccessToken();
    // Catatan: Validasi masa aktif (expired) JWT akan kita lakukan di Interceptor/UseCase
    // Fungsi ini hanya mengecek apakah token fisiknya ada di storage
    return token != null && token.isNotEmpty;
  }
}
