import 'dart:typed_data'; // Tambahkan import ini
import 'package:freezed_annotation/freezed_annotation.dart';

part 'data_jukir_entity.freezed.dart';

@freezed
class DataJukirEntity with _$DataJukirEntity {
  const factory DataJukirEntity({
    required String idDevice,
    required String petugas,
    required String shift,

    required int totalMobilHariIni,
    required int totalMotorHariIni,
    required int totalNominalMobilHariIni,
    required int totalNominalMotorHariIni,
    required int totalKendaraan,
    required int totalNominal,

    required List<UsernameEntity> usernameList,
  }) = _DataJukirEntity;
}

@freezed
class UsernameEntity with _$UsernameEntity {
  const factory UsernameEntity({
    required String username,
    required String namaPetugas,
    Uint8List? fotoBytes,
  }) = _UsernameEntity;
}
