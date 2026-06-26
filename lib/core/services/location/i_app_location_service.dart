abstract class IAppLocationService {
  /// Mengembalikan Map berisi 'latitude' dan 'longitude'
  Future<Map<String, String>> getCurrentLocation();

  /// Cek apakah GPS hardware aktif
  Future<bool> isLocationServiceEnabled();
}
