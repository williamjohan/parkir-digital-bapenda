// lib/core/services/location/app_location_service_impl.dart

import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import '../../errors/exception.dart';
import '../../storage/secure_storage_manager.dart'; // 🚀 Import Secure Storage
import 'i_app_location_service.dart';

@LazySingleton(as: IAppLocationService)
class AppLocationServiceImpl implements IAppLocationService {
  final ISecureStorageManager _secureStorage; // 🚀 Injeksi Storage

  AppLocationServiceImpl(this._secureStorage);

  @override
  Future<Map<String, String>> getCurrentLocation() async {
    try {
      // 1. Cek Hardware
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw LocationDisabledException();

      // 2. Cek Izin
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw LocationPermissionDeniedException();
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw LocationPermissionDeniedException("Izin diblokir permanen.");
      }

      // 3. Ambil Lokasi (Real-time)
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 3),
        ),
      );

      final lat = position.latitude.toString();
      final lng = position.longitude.toString();

      // 🚀 4. SIMPAN KE BRANKAS (LAST KNOWN LOCATION)
      await _secureStorage.saveLastLocation(lat, lng);

      return {'latitude': lat, 'longitude': lng};
    } on TimeoutException {
      return await _fallbackLocation();
    } catch (e) {
      if (e is LocationDisabledException ||
          e is LocationPermissionDeniedException) {
        rethrow; // Biarkan rudal meluncur ke Cubit
      }
      return await _fallbackLocation();
    }
  }

  @override
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // 🚀 FUNGSI FALLBACK CERDAS
  Future<Map<String, String>> _fallbackLocation() async {
    final cachedLocation = await _secureStorage.getLastLocation();
    if (cachedLocation != null) {
      return cachedLocation; // Kembalikan lokasi terakhir di atas tanah
    }
    return {'latitude': '0', 'longitude': '0'}; // Opsi terakhir
  }
}
