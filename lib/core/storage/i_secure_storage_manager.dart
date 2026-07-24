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
    String? nmOpd,
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
  Future<void> saveQrisMetadata(String jsonString);
  Future<String?> getQrisMetadata();
  Future<void> clearQrisMetadata();
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
  Future<void> saveQrisLastUpdate(String dateString);
  Future<String?> getQrisLastUpdate();
  Future<void> clearQrisLastUpdate();
  Future<void> saveOpLastUpdate(String dateString);
  Future<String?> getOpLastUpdate();
  Future<void> clearOpLastUpdate();
}
