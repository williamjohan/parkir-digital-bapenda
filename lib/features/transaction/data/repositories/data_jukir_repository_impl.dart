import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/features/home/domain/entities/data_jukir_entity.dart';
import '../../../home/data/datasources/data_jukir_datasource.dart';
import '../../../home/data/mapper/data_jukir_mapper.dart';
import '../../domain/repositories/data_jukir_repository.dart';

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
