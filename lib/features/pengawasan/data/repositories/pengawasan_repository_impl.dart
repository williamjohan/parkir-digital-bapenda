import 'package:injectable/injectable.dart';
import '../../domain/entities/request_laporan_pengawasan_entity/request_laporan_pengawasan_entity.dart';
import '../../domain/repositories/i_pengawasan_repository.dart';
import '../datasources/pengawasan_datasource.dart';

@LazySingleton(as: PengawasanRepository)
class PengawasanRepositoryImpl implements PengawasanRepository {
  final PengawasanDatasource _datasource;

  PengawasanRepositoryImpl(this._datasource);

  @override
  Future<void> addPengawasan(RequestLaporanPengawasanEntity request) {
    return _datasource.addPengawasan(request);
  }
}
