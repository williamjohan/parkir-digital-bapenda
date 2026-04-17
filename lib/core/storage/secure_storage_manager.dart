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
  Future<Map<String, dynamic>?> getJukirProfile();
  Future<void> clearJukirProfile();
  Future<void> saveMasterTarif(String jsonString);
  Future<String?> getMasterTarif();
  Future<void> clearMasterTarif();
  Future<void> saveDashboardAnchor(String jsonString);
  Future<String?> getDashboardAnchor();
  Future<void> clearDashboardAnchor();
  Future<void> saveDeviceId(String deviceId);
  Future<String?> getDeviceId();
  Future<void> savePrinterMacAddress(String macAdress);
  Future<String?> getPrinterMacAddress();
  Future<void> clearPrinterMacAddress();
  Future<void> saveJukirProfile({
    required String idUserStorage,
    required String namaUserStorage,
    required String nopStorage,
    required String alamat,
    int? pungutTarif,
    String? namaObjekPajak,
    String? idDevice,
    int? lokasiId,
    String? namaLokasi,
    String? kodeGate,
    String? namaGate,
    String? shift,
  });
}

@LazySingleton(as: ISecureStorageManager)
class SecureStorageManagerImpl implements ISecureStorageManager {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _keyAccessToken = 'ACCESS_TOKEN';
  static const String _keyRefreshToken = 'REFRESH_TOKEN';
  static const String _keyJukirProfile = 'JUKIR_PROFILE';
  static const String _keyMasterTarif = 'MASTER_TARIF';
  static const String _keyDashboardAnchor = 'DASHBOARD_ANCHOR';
  static const String _keyDeviceId = 'DEVICE_ID';
  static const String _keyPrinterMacAddress = 'PRINTER_MAC_ADDRESS';

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
    await clearMasterTarif();
    await clearDashboardAnchor();
  }

  @override
  Future<void> saveMasterTarif(String jsonString) async {
    await _storage.write(key: _keyMasterTarif, value: jsonString);
  }

  @override
  Future<String?> getMasterTarif() async {
    return await _storage.read(key: _keyMasterTarif);
  }

  @override
  Future<void> clearMasterTarif() async {
    await _storage.delete(key: _keyMasterTarif);
  }

  @override
  Future<void> saveDashboardAnchor(String jsonString) async {
    await _storage.write(key: _keyDashboardAnchor, value: jsonString);
  }

  @override
  Future<String?> getDashboardAnchor() async {
    return await _storage.read(key: _keyDashboardAnchor);
  }

  @override
  Future<void> clearDashboardAnchor() async {
    await _storage.delete(key: _keyDashboardAnchor);
  }

  @override
  Future<bool> hasValidToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
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

  @override
  Future<void> saveDeviceId(String deviceId) async {
    await _storage.write(key: _keyDeviceId, value: deviceId);
  }

  @override
  Future<String?> getDeviceId() async {
    return await _storage.read(key: _keyDeviceId);
  }

  @override
  Future<void> savePrinterMacAddress(String macAddress) async {
    await _storage.write(key: _keyPrinterMacAddress, value: macAddress);
  }

  @override
  Future<String?> getPrinterMacAddress() async {
    return await _storage.read(key: _keyPrinterMacAddress);
  }

  @override
  Future<void> clearPrinterMacAddress() async {
    await _storage.delete(key: _keyPrinterMacAddress);
  }

  @override
  Future<void> saveJukirProfile({
    required String idUserStorage,
    required String namaUserStorage,
    required String nopStorage,
    required String alamat,
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
      'alamat': alamat,
    };
    final jsonString = jsonEncode(profileData);
    await _storage.write(key: _keyJukirProfile, value: jsonString);
  }
}
