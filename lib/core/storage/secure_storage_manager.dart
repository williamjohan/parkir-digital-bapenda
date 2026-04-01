// lib/core/storage/secure_storage_manager.dart

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

abstract class ISecureStorageManager {
  Future<void> saveAccessToken(String token);
  Future<String?> getAccessToken();
  Future<void> saveRefreshToken(String token);
  Future<String?> getRefreshToken();
  Future<void> clearAllTokens();
  Future<bool> hasValidToken();

  // [PERBAIKAN]: Perlebar pintu brankas untuk menerima peluru Sync
  Future<void> saveJukirProfile({
    required String idUserStorage,
    required String namaUserStorage,
    required String nopStorage,
    int? pungutTarif,
    String? namaObjekPajak,
    String? idDevice,
    int? lokasiId,
    String? namaLokasi,
    String? kodeGate,
    String? namaGate,
    String? shift,
  });
  Future<Map<String, dynamic>?> getJukirProfile();
  Future<void> clearJukirProfile();
}

@LazySingleton(as: ISecureStorageManager)
class SecureStorageManagerImpl implements ISecureStorageManager {
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const String _keyAccessToken = 'ACCESS_TOKEN';
  static const String _keyRefreshToken = 'REFRESH_TOKEN';
  static const String _keyJukirProfile = 'JUKIR_PROFILE';

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
    await clearJukirProfile();
  }

  @override
  Future<bool> hasValidToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> saveJukirProfile({
    required String idUserStorage,
    required String namaUserStorage,
    required String nopStorage,
    int? pungutTarif,
    String? namaObjekPajak,
    String? idDevice,
    int? lokasiId,
    String? namaLokasi,
    String? kodeGate,
    String? namaGate,
    String? shift,
  }) async {
    final profileData = {
      'idUser': idUserStorage,
      'namaUser': namaUserStorage,
      'nop': nopStorage,
      'pungutTarif': pungutTarif,
      'namaObjekPajak': namaObjekPajak,
      'idDevice': idDevice,
      'lokasiId': lokasiId,
      'namaLokasi': namaLokasi,
      'kodeGate': kodeGate,
      'namaGate': namaGate,
      'shift': shift,
    };
    final jsonString = jsonEncode(profileData);
    await _storage.write(key: _keyJukirProfile, value: jsonString);
  }

  @override
  Future<Map<String, dynamic>?> getJukirProfile() async {
    final jsonString = await _storage.read(key: _keyJukirProfile);
    if (jsonString != null) {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    }
    return null;
  }

  @override
  Future<void> clearJukirProfile() async {
    await _storage.delete(key: _keyJukirProfile);
  }
}
