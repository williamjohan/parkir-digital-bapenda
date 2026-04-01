// lib/core/services/location/i_app_location_service.dart

abstract class IAppLocationService {
  /// Mengembalikan Map berisi 'latitude' dan 'longitude'
  Future<Map<String, String>> getCurrentLocation();
}
