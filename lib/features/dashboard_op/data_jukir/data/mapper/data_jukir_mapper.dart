import 'package:parkir_digital_bapenda/features/dashboard_op/data_jukir/data/models/data_jukir/data_jukir_model.dart';
import 'package:parkir_digital_bapenda/features/dashboard_op/data_jukir/domain/entities/data_jukir_entity.dart';

class DataJukirMapper {
  static DataJukirEntity toEntity(DataJukirModel model) {
    return DataJukirEntity(
      nop: model.nop,
      username: model.username,
      deviceId: model.idDevice,
      namaPetugas: model.namaPetugas,
      shift: model.shift,
      // totalPendapatan: model.totalPendapatan,
      // totalMobil: model.totalMobil,
      // totalMotor: model.totalMotor,
    );
  }
}
