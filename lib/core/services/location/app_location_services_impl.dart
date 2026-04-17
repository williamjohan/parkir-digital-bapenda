// lib/core/services/location/app_location_service_impl.dart

import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import '../../errors/exception.dart';
import 'i_app_location_service.dart';

@LazySingleton(as: IAppLocationService)
class AppLocationServiceImpl implements IAppLocationService {
  @override
  Future<Map<String, String>> getCurrentLocation() async {
    try {
      // 1. Cek Hardware
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw LocationDisabledException();
      }

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

      // 3. Ambil Lokasi
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 3),
        ),
      );

      return {
        'latitude': position.latitude.toString(),
        'longitude': position.longitude.toString(),
      };
    } on TimeoutException {
      return _fallbackLocation();
    }
  }

  @override
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Map<String, String> _fallbackLocation() => {
    'latitude': '0',
    'longitude': '0',
  };
}
