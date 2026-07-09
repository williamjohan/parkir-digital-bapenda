import 'package:injectable/injectable.dart';

import '../../domain/entities/data_jukir_entity.dart';
import '../../domain/repositories/data_jukir_repository.dart';
import '../datasources/data_jukir_datasource.dart';
import '../mapper/data_jukir_mapper.dart';

@LazySingleton(as: DataJukirRepository)
class DataJukirRepositoryImpl implements DataJukirRepository {
  final DataJukirDatasource _datasource;

  DataJukirRepositoryImpl(this._datasource);

  @override
  Future<List<DataJukirEntity>> getDataJukir(String nop) async {
    final result = await _datasource.getDataJukir(nop);

    return result.map(DataJukirMapper.toEntity).toList();
  }
}
