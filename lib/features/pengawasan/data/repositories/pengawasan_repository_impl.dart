import 'dart:io';
import 'package:injectable/injectable.dart';
import '../../domain/entities/pengawasan_entity.dart';
import '../../domain/repositories/i_pengawasan_repository.dart';
import '../datasources/pengawasan_datasource.dart';
import '../mapper/pengawasan_mapper.dart';

@LazySingleton(as: PengawasanRepository)
class PengawasanRepositoryImpl implements PengawasanRepository {
  final PengawasanDatasource _datasource;

  PengawasanRepositoryImpl(this._datasource);

  @override
  Future<void> addPengawasan(PengawasanEntity entity, File buktiFoto) {
    return _datasource.addPengawasan(entity.toModel(), buktiFoto);
  }
}
