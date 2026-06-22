import 'package:parkir_digital_bapenda/features/home/domain/entities/data_jukir_entity.dart';

abstract class DataJukirRepository {
  Future<List<DataJukirEntity>> getDataJukir(String nop);
}
