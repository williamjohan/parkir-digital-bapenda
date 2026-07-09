import '../entities/daftar_nop_entity.dart';

abstract class DaftarNopRepository {
  Future<List<DaftarNopEntity>> getDaftarNop();
}
