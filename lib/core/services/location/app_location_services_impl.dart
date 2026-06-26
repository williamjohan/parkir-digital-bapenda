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
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw LocationDisabledException();
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        throw LocationPermissionDeniedException("Izin lokasi ditolak.");
      }
      if (permission == LocationPermission.deniedForever) {
        throw LocationPermissionDeniedException(
          "Izin lokasi diblokir sistem. Silakan buka Pengaturan.",
        );
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 3),
        ),
      );

      final lat = position.latitude.toString();
      final lng = position.longitude.toString();
      await _secureStorage.saveLastLocation(lat, lng);
      return {'latitude': lat, 'longitude': lng};
    } on TimeoutException {
      return await _fallbackLocation();
    } catch (e) {
      final errorString = e.toString().toLowerCase();

      if (e is LocationDisabledException ||
          e is LocationPermissionDeniedException ||
          errorString.contains('permission')) {
        throw LocationPermissionDeniedException(
          "Izin lokasi telah dicabut oleh sistem.",
        );
      }
      return await _fallbackLocation();
    }
  }

  @override
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<Map<String, String>> _fallbackLocation() async {
    final cachedLocation = await _secureStorage.getLastLocation();
    if (cachedLocation != null) {
      return cachedLocation; // Kembalikan lokasi terakhir di atas tanah
    }
    return {'latitude': '0', 'longitude': '0'}; // Opsi terakhir
  }
}
