import '../models/tarif_model.dart';

abstract class ITarifRemoteDataSource {
  Future<List<TarifModel>> getTarif();
}
