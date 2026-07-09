import 'package:injectable/injectable.dart';
import '../../domain/entities/laporan_pengawasan/laporan_pengawasan_entity.dart';
import '../../domain/entities/request_laporan_pengawasan_entity/request_laporan_pengawasan_entity.dart';
import '../../domain/repositories/i_pengawasan_repository.dart';
import '../datasources/pengawasan_datasource.dart';
import '../mapper/laporan_pengawasan_mapper.dart';

@LazySingleton(as: PengawasanRepository)
class PengawasanRepositoryImpl implements PengawasanRepository {
  final PengawasanDatasource _datasource;

  PengawasanRepositoryImpl(this._datasource);

  @override
  Future<void> addPengawasan(RequestLaporanPengawasanEntity request) {
    return _datasource.addPengawasan(request);
  }

  @override
  Future<List<LaporanPengawasanEntity>> getLaporanPengawasan() async {
    final models = await _datasource.getLaporanPengawasan();

    return models.map((model) => model.toEntity()).toList();
  }
}
