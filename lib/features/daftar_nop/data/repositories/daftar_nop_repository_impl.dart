import 'package:injectable/injectable.dart';

import '../../domain/entities/daftar_nop_entity.dart';
import '../../domain/repositories/daftar_nop_repository.dart';
import '../datasources/daftar_nop_datasource.dart';
import '../mapper/daftar_nop_mapper.dart';

@LazySingleton(as: DaftarNopRepository)
class DaftarNopRepositoryImpl implements DaftarNopRepository {
  final DaftarNopDatasource datasource;

  DaftarNopRepositoryImpl(this.datasource);

  @override
  Future<List<DaftarNopEntity>> getDaftarNop() async {
    final models = await datasource.getDaftarNop();

    return models.map((e) => e.toEntity()).toList();
  }
}
