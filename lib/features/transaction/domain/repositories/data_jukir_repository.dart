import 'package:parkir_digital_bapenda/features/dashboard_op/data_jukir/domain/entities/data_jukir_entity.dart';

abstract class DataJukirRepository {
  Future<List<DataJukirEntity>> getDataJukir(String nop);
}
