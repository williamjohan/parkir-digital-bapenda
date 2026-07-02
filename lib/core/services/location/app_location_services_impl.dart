import 'dart:async';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/core/services/location/app_location_data.dart';
import '../../errors/exception.dart';
import '../../storage/secure_storage_manager.dart'; // 🚀 Import Secure Storage
import 'i_app_location_service.dart';

@LazySingleton(as: IAppLocationService)
class AppLocationServiceImpl implements IAppLocationService {
  final ISecureStorageManager _secureStorage; // 🚀 Injeksi Storage

  AppLocationServiceImpl(this._secureStorage);

  @override
  Future<AppLocationData> getCurrentLocation() async {
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

      // Tingkatkan limit sedikit menjadi 5 detik untuk mengakomodasi HP jadul
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 5),
        ),
      );

      final lat = position.latitude.toString();
      final lng = position.longitude.toString();

      // Simpan koordinat ke cache (fallback)
      await _secureStorage.saveLastLocation(lat, lng);

      // (Opsional) Ambil nama alamat. Dibungkus try-catch agar kalau gagal, tetap me-return koordinat
      String? placeName;
      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          final parts = [
            p.subLocality,
            p.locality,
          ].where((e) => e != null && e.isNotEmpty).toList();
          placeName = parts.isNotEmpty ? parts.join(', ') : null;
        }
      } catch (_) {}

      return AppLocationData(latitude: lat, longitude: lng, address: placeName);
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

  Future<AppLocationData> _fallbackLocation() async {
    final cachedLocation = await _secureStorage.getLastLocation();
    if (cachedLocation != null && cachedLocation['latitude'] != null) {
      return AppLocationData(
        latitude: cachedLocation['latitude']!,
        longitude: cachedLocation['longitude']!,
        address:
            'Lokasi Terakhir (Cache)', // Penanda bahwa ini lokasi offline/cache
      );
    }
    return AppLocationData(
      latitude: '0',
      longitude: '0',
      address: 'Lokasi Tidak Diketahui',
    );
  }
}
