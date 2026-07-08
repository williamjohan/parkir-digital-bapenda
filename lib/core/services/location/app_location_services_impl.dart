import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/core/services/location/app_location_data.dart';
import '../../errors/exception.dart';
import '../../storage/secure_storage_manager.dart';
import 'i_app_location_service.dart';

@LazySingleton(as: IAppLocationService)
class AppLocationServiceImpl implements IAppLocationService {
  final ISecureStorageManager _secureStorage;

  AppLocationServiceImpl(this._secureStorage);

  @override
  Future<AppLocationData> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw const LocationDisabledException();

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        throw const LocationPermissionDeniedException();
      }
      if (permission == LocationPermission.deniedForever) {
        throw const LocationPermissionDeniedException(
          message: "Mohon aktifkan perizinan lokasi Anda di pengaturan sistem.",
        );
      }

      // 1. PERBAIKAN AKURASI & TIMEOUT
      // Ubah ke 'high' untuk absensi, dan beri toleransi waktu 15 detik agar GPS HP sempat mencari satelit
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      if (position.isMocked) {
        throw Exception(
          "TERDETEKSI FAKE GPS: Harap matikan aplikasi lokasi palsu untuk melakukan absensi.",
        );
      }

      final lat = position.latitude.toString();
      final lng = position.longitude.toString();

      String? placeName;
      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          String namaJalan = p.thoroughfare ?? p.street ?? '';
          if (namaJalan.contains('+')) {
            // Jika isinya Plus Code, kita kosongkan saja daripada aneh dibaca
            namaJalan = '';
          } else if (p.subThoroughfare != null &&
              p.subThoroughfare!.isNotEmpty) {
            //  3. Gabungkan dengan Nomor Bangunan jika tersedia
            // Hasil: "Jl. Jimerto No.19"
            namaJalan = '$namaJalan No.${p.subThoroughfare}';
          }
          // 2. PERBAIKAN FORMAT ALAMAT (Memasukkan Nama Jalan)
          // Contoh hasil: "Jl. Pemuda No. 1, Embong Kaliasin, Surabaya"
          final parts = [
            namaJalan,
            p.subLocality,
            p.locality,
          ].where((e) => e != null && e.isNotEmpty).toList();

          placeName = parts.isNotEmpty ? parts.join(', ') : null;
        } else {
          debugPrint('[GEOCODING] placemarks list is empty for $lat, $lng');
        }
      } catch (_) {
        // Jika internet mati sehingga geocoding gagal, biarkan placeName null.
        // Nanti UI akan secara otomatis hanya menampilkan koordinat Lat/Long.
        // debugPrint('[GEOCODING] failed: $e');
      }

      await _secureStorage.saveLastLocation(lat, lng, placeName ?? '');
      final cached = await _secureStorage.getLastLocation();
      debugPrint('[CACHE CHECK] $cached');

      return AppLocationData(latitude: lat, longitude: lng, address: placeName);
    } on TimeoutException {
      return await _fallbackLocation();
    } on AppException {
      rethrow;
    } catch (e) {
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
        address: cachedLocation['address'],
      );
    }
    return AppLocationData(
      latitude: '0',
      longitude: '0',
      address: 'Lokasi Tidak Diketahui',
    );
  }
}
