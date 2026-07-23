import 'package:flutter/foundation.dart';
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
    // 1. Ambil payload JSON/Model dari API (I/O)
    final result = await _datasource.getDataJukir(nop);

    // 2. Lempar List<DataJukirModel> ke fungsi Isolate
    // Proses looping dan komputasi kriptografi Base64 tidak akan menyentuh Main Thread
    return await compute(DataJukirMapper.toEntityListInIsolate, result);
  }
}
