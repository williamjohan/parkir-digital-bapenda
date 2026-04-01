// lib/core/services/location/app_location_service_impl.dart

import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import '../../utils/app_logger.dart';
import 'i_app_location_service.dart';

@LazySingleton(as: IAppLocationService)
class AppLocationServiceImpl implements IAppLocationService {
  @override
  Future<Map<String, String>> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        AppLogger.error("GPS tidak aktif.");
        return _fallbackLocation();
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          AppLogger.error("Izin GPS ditolak.");
          return _fallbackLocation();
        }
      }
      if (permission == LocationPermission.deniedForever) {
        AppLogger.error("Izin GPS ditolak permanen.");
        return _fallbackLocation();
      }

      // [KUNCI ARSITEKTUR OFFLINE]: Timeout maksimal 3 detik!
      // Jika dalam 3 detik tidak dapat sinyal satelit, langsung gunakan default.
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy
              .medium, // Medium sudah cukup untuk area mall/parkir
          timeLimit: Duration(seconds: 3),
        ),
      );

      return {
        'latitude': position.latitude.toString(),
        'longitude': position.longitude.toString(),
      };
    } catch (e) {
      AppLogger.error("Gagal mendapat lokasi: $e");
      return _fallbackLocation();
    }
  }

  // Koordinat Default jika gagal (Bisa diset ke 0,0 atau titik Balai Kota/Bapenda)
  Map<String, String> _fallbackLocation() {
    return {'latitude': '0', 'longitude': '0'};
  }
}
