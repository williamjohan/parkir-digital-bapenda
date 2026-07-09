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
  // 🚀 1. Terima parameter opsional compressedFotoPath
  Future<FormData> toFormData({String? compressedFotoPath}) async {
    final prefix = isCheckIn ? 'CheckIn' : 'CheckOut';

    final formData = FormData();

    // 1. Data Kendaraan & Lokasi
    formData.fields.add(MapEntry('${prefix}JmlMobil', totalMobil.toString()));
    formData.fields.add(MapEntry('${prefix}JmlMotor', totalMotor.toString()));
    formData.fields.add(MapEntry('Latitude', latitude.toString()));
    formData.fields.add(MapEntry('Longitude', longitude.toString()));

    // 2. Data List Alat
    for (final id in detailAlatIds) {
      formData.fields.add(MapEntry('DetailAlatList', id.toString()));
    }

    // 🚀 2. Tentukan foto mana yang dikirim (Prioritas: foto kompresi > foto mentah HP)
    final pathToUpload = compressedFotoPath ?? fotoPath;
    final file = File(pathToUpload);

    if (!await file.exists()) {
      throw Exception('File foto absensi tidak ditemukan di perangkat');
    }

    // 🚀 3. PERBAIKAN ANTI-CRASH RETRY: Baca sebagai Bytes!
    final bytes = await file.readAsBytes();

    formData.files.add(
      MapEntry(
        'Foto$prefix', // Hasilnya: FotoCheckIn atau FotoCheckOut
        MultipartFile.fromBytes(
          bytes,
          filename: file.path.split('/').last,
          // 4. DYNAMIC MIME TYPE: Aman di HP Samsung, Xiaomi, iPhone, dll.
          contentType: _getMediaType(file.path),
        ),
      ),
    );

    return formData;
  }
}

DioMediaType _getMediaType(String filePath) {
  final ext = filePath.split('.').last.toLowerCase();
  switch (ext) {
    case 'png':
      return DioMediaType('image', 'png');
    case 'webp':
      return DioMediaType('image', 'webp');
    case 'heic':
    case 'heif':
      return DioMediaType('image', 'heic');
    case 'jpg':
    case 'jpeg':
    default:
      return DioMediaType('image', 'jpeg');
  }
}
