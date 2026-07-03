import 'dart:io';

import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/absensi_entity.dart';

part 'absensi_model.freezed.dart';
part 'absensi_model.g.dart';

@freezed
class AbsensiRequestModel with _$AbsensiRequestModel {
  const factory AbsensiRequestModel({
    @Default(0.0) double latitude,
    @Default(0.0) double longitude,
    @Default(0) int totalMotor,
    @Default(0) int totalMobil,
    @Default([]) List<int> detailAlatIds,
    @Default('') String fotoPath, // Ini adalah properti, bukan prefix
    @Default(true) bool isCheckIn,
  }) = _AbsensiRequestModel;

  factory AbsensiRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AbsensiRequestModelFromJson(json);
}

// ==========================================
// EXTENSION (Mapper Entity <-> Model <-> FormData)
// ==========================================

extension AbsensiEntityExt on AbsensiEntity {
  AbsensiRequestModel toModel() {
    return AbsensiRequestModel(
      latitude: latitude,
      longitude: longitude,
      totalMotor: totalMotor,
      totalMobil: totalMobil,
      detailAlatIds: detailAlatIds,
      fotoPath: fotoPath,
      isCheckIn: isCheckIn,
    );
  }
}

extension AbsensiRequestModelExt on AbsensiRequestModel {
  Future<FormData> toFormData() async {
    final prefix = isCheckIn ? 'CheckIn' : 'CheckOut';

    final formData = FormData();

    // 1. Data Kendaraan & Lokasi
    formData.fields.add(MapEntry('${prefix}JmlMobil', totalMobil.toString()));
    formData.fields.add(MapEntry('${prefix}JmlMotor', totalMotor.toString()));
    formData.fields.add(MapEntry('Latitude', latitude.toString()));
    formData.fields.add(MapEntry('Longitude', longitude.toString()));

    // 2. Data List Alat (Key diulang sesuai standar form-data array)
    // Contoh output HTTP: DetailAlatList=1, DetailAlatList=2
    for (final id in detailAlatIds) {
      formData.fields.add(MapEntry('DetailAlatList', id.toString()));
    }

    // 🚀 3. PERBAIKAN ANTI-CRASH RETRY: Baca sebagai Bytes!
    // Membaca ke RAM/Bytes memastikan file bisa dikirim berulang kali saat Dio melakukan retry
    final bytes = await File(fotoPath).readAsBytes();

    formData.files.add(
      MapEntry(
        'Foto$prefix', // Hasilnya: FotoCheckIn atau FotoCheckOut
        MultipartFile.fromBytes(bytes, filename: fotoPath.split('/').last),
      ),
    );

    return formData;
  }
}
