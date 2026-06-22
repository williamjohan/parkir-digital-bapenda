import 'package:parkir_digital_bapenda/features/home/data/models/data_jukir/data_jukir_model.dart';
import 'package:parkir_digital_bapenda/features/home/domain/entities/data_jukir_entity.dart';

class DataJukirMapper {
  static DataJukirEntity toEntity(DataJukirModel model) {
    return DataJukirEntity(
      nop: model.nop,
      username: model.username,
      deviceId: model.idDevice,
      namaPetugas: model.namaPetugas,
    );
  }
}
