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
  Future<void> saveDeviceUUID(String deviceId);
  Future<String?> getDeviceUUID();
  Future<void> clearDeviceUUID();
  Future<void> savePrinterMacAddress(String macAdress);
  Future<String?> getPrinterMacAddress();
  Future<void> clearPrinterMacAddress();
  Future<void> saveLastLocation(
    String latitude,
    String longitude,
    String address,
  );
  Future<Map<String, String>?> getLastLocation();
  Future<void> saveJukirProfile({
    required String idUserStorage,
    required String username,
    required String namaUserStorage,
    required String nopStorage,
    required String alamat,
    required int roleId,
    String? pungutTarifDescription,
    int? pungutTarif,
    String? namaObjekPajak,
    String? idDevice,
    int? lokasiId,
    String? namaLokasi,
    String? kodeGate,
    String? namaGate,
    String? shift,
  });
  Future<void> saveQrisImagePaths(String jsonString);
  Future<String?> getQrisImagePaths();
  Future<void> clearQrisImagePaths();
  Future<void> saveCredentials(String username, String password);
  Future<Map<String, String>?> getCredentials();
  Future<void> clearPasswordOnly();
  Future<void> saveLogoutReason(String reason);
  Future<String?> getAndClearLogoutReason();
  Future<void> saveIsJukir(bool value);
  Future<bool> getIsJukir();
  Future<void> saveRoleId(int roleId);
  Future<int?> getRoleId();
  Future<void> clearRoleId();
  Future<void> saveProfilePicture(String pathImage);
  Future<String?> getProfilePicture();
  Future<void> clearProfilePicture();
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
  static const String _keyDeviceLocation = 'DEVICE_LOCATION';
  static const String _keyQrisImagePaths = 'QRIS_IMAGE_PATHS';
  static const String _keyUsername = 'SAVED_USERNAME';
  static const String _keyPassword = 'SAVED_PASSWORD';
  static const String _keyLogoutReason = 'LOGOUT_REASON';
  static const String _keyIsJukir = 'IS_JUKIR';
  static const String _keyRoleId = 'ROLE_LOGIN_ID';
  static const String _keyProfilePicture = 'PROFILE_PICTURE';

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
    await clearRoleId();
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
  Future<void> saveDeviceUUID(String deviceId) async {
    await _storage.write(key: _keyDeviceId, value: deviceId);
  }

  @override
  Future<String?> getDeviceUUID() async {
    return await _storage.read(key: _keyDeviceId);
  }

  @override
  Future<void> clearDeviceUUID() async {
    await _storage.delete(key: _keyDeviceId);
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
  Future<void> saveLastLocation(
    String latitude,
    String longitude,
    String address,
  ) async {
    final locationMap = {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
    final jsonString = jsonEncode(locationMap);
    await _storage.write(key: _keyDeviceLocation, value: jsonString);
  }

  @override
  Future<Map<String, String>?> getLastLocation() async {
    try {
      final jsonString = await _storage.read(key: _keyDeviceLocation);
      if (jsonString != null) {
        final Map<String, dynamic> decodedData = jsonDecode(jsonString);
        return {
          'latitude': decodedData['latitude'].toString(),
          'longitude': decodedData['longitude'].toString(),
          'address': decodedData['address'].toString(),
        };
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  @override
  Future<void> saveJukirProfile({
    required String idUserStorage,
    required String username,
    required String namaUserStorage,
    required String nopStorage,
    required String alamat,
    required int roleId,
    int? pungutTarif,
    String? pungutTarifDescription,
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
      'username': username,
      'roleId': roleId,
      'namaUser': namaUserStorage,
      'nop': nopStorage,
      'pungutTarif': pungutTarif ?? 0,
      'pungutTarifDescription': pungutTarifDescription ?? 'Tidak Diketahui',
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

  @override
  Future<void> saveQrisImagePaths(String jsonString) async {
    await _storage.write(key: _keyQrisImagePaths, value: jsonString);
  }

  @override
  Future<String?> getQrisImagePaths() async {
    return await _storage.read(key: _keyQrisImagePaths);
  }

  @override
  Future<void> clearQrisImagePaths() async {
    await _storage.delete(key: _keyQrisImagePaths);
  }

  @override
  Future<void> saveCredentials(String username, String password) async {
    await _storage.write(key: _keyUsername, value: username);
    await _storage.write(key: _keyPassword, value: password);
  }

  @override
  Future<Map<String, String>?> getCredentials() async {
    final username = await _storage.read(key: _keyUsername);
    final password = await _storage.read(key: _keyPassword);

    if (username != null) {
      return {'username': username, 'password': password ?? ''};
    }
    return null;
  }

  @override
  Future<void> clearPasswordOnly() async {
    await _storage.delete(key: _keyPassword);
  }

  @override
  Future<void> saveLogoutReason(String reason) async {
    await _storage.write(key: _keyLogoutReason, value: reason);
  }

  @override
  Future<String?> getAndClearLogoutReason() async {
    final reason = await _storage.read(key: _keyLogoutReason);
    if (reason != null) {
      await _storage.delete(key: _keyLogoutReason);
    }
    return reason;
  }

  @override
  Future<void> saveIsJukir(bool value) async {
    await _storage.write(key: _keyIsJukir, value: value.toString());
  }

  @override
  Future<bool> getIsJukir() async {
    final value = await _storage.read(key: _keyIsJukir);
    return value == 'true';
  }

  @override
  Future<void> saveRoleId(int roleId) async {
    await _storage.write(key: _keyRoleId, value: roleId.toString());
  }

  @override
  Future<int?> getRoleId() async {
    final value = await _storage.read(key: _keyRoleId);
    if (value != null) {
      return int.tryParse(value);
    }
    return null;
  }

  @override
  Future<void> clearRoleId() async {
    await _storage.delete(key: _keyRoleId);
  }

  @override
  Future<void> saveProfilePicture(String pathImage) async {
    await _storage.write(key: _keyProfilePicture, value: pathImage);
  }

  @override
  Future<String?> getProfilePicture() async {
    return await _storage.read(key: _keyProfilePicture);
  }

  @override
  Future<void> clearProfilePicture() async {
    await _storage.delete(key: _keyProfilePicture);
  }
}
