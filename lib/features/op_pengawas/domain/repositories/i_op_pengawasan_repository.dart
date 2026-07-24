import '../entities/op_pengawas_entity.dart';

abstract class IOpPengawasanRepository {
  Future<List<OpPengawasEntity>> getOpPengawasan();
}
