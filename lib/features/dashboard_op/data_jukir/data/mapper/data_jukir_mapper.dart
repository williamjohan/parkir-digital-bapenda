import 'dart:convert';
import 'dart:typed_data';

import 'package:parkir_digital_bapenda/features/dashboard_op/data_jukir/data/models/data_jukir/data_jukir_model.dart';
import 'package:parkir_digital_bapenda/features/dashboard_op/data_jukir/domain/entities/data_jukir_entity.dart';

class DataJukirMapper {
  static List<DataJukirEntity> toEntityListInIsolate(
    List<DataJukirModel> models,
  ) {
    return models.map((model) => toEntity(model)).toList();
  }

  // 2. FUNGSI MAPPING INDIVIDUAL
  static DataJukirEntity toEntity(DataJukirModel model) {
    return DataJukirEntity(
      idDevice: model.idDevice,
      petugas: model.petugas,
      shift: model.shift,
      totalMobilHariIni: model.totalMobilHariIni,
      totalMotorHariIni: model.totalMotorHariIni,
      totalNominalMobilHariIni: model.totalNominalMobilHariIni,
      totalNominalMotorHariIni: model.totalNominalMotorHariIni,
      totalKendaraan: model.totalKendaraan,
      totalNominal: model.totalNominal,
      usernameList: model.usernameList
          .map(
            (e) => UsernameEntity(
              username: e.username,
              namaPetugas: e.namaPetugas,
              fotoBytes: _decodeSanitizedImage(e.fotoBase64),
            ),
          )
          .toList(),
    );
  }

  // 3.  MESIN DEKODE & SANITASI BASE64 (Wajib Static)
  static Uint8List? _decodeSanitizedImage(String value) {
    if (value.isEmpty) return null;

    try {
      String cleanString = value;

      // Buang header MIME bawaan backend jika ada
      if (cleanString.contains(',')) {
        cleanString = cleanString.split(',').last;
      }

      // Sanitasi spasi, tab, atau enter ilegal yang merusak struktur byte
      cleanString = cleanString.replaceAll(RegExp(r'\s+'), '');

      // Normalisasi Padding (Base64 mutlak harus kelipatan 4)
      int padding = cleanString.length % 4;
      if (padding != 0) {
        cleanString += '=' * (4 - padding);
      }

      return base64Decode(cleanString);
    } catch (e) {
      // Jika string masih cacat dari backend, kembalikan null
      // UI akan otomatis merender icon default (Fallback) tanpa menimbulkan crash
      return null;
    }
  }
}
