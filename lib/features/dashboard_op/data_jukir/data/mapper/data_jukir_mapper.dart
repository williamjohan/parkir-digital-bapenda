import 'package:parkir_digital_bapenda/features/dashboard_op/data_jukir/data/models/data_jukir/data_jukir_model.dart';
import 'package:parkir_digital_bapenda/features/dashboard_op/data_jukir/domain/entities/data_jukir_entity.dart';

class DataJukirMapper {
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
              fotoBase64: e.fotoBase64,
            ),
          )
          .toList(),
    );
  }
}
