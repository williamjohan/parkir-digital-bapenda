import '../entities/data_jukir_entity.dart';

abstract class DataJukirRepository {
  Future<List<DataJukirEntity>> getDataJukir(String nop);
}
