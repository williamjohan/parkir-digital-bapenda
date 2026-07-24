import 'package:injectable/injectable.dart';
import '../../domain/entities/op_pengawas_entity.dart';
import '../../domain/repositories/i_op_pengawasan_repository.dart';
import '../datasources/op_pengawasan_datasource.dart';
import '../models/op_pengawasan_model.dart';

@LazySingleton(as: IOpPengawasanRepository)
class OpPengawasanRepositoryImpl implements IOpPengawasanRepository {
  final OpPengawasanDatasource _datasource;

  OpPengawasanRepositoryImpl(this._datasource);

  @override
  Future<List<OpPengawasEntity>> getOpPengawasan() async {
    final result = await _datasource.getOpPengawasan();

    return result.map((e) => e.toEntity()).toList();
  }
}
