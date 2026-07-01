import '../entities/laporan_pengawasan/laporan_pengawasan_entity.dart';
import '../entities/request_laporan_pengawasan_entity/request_laporan_pengawasan_entity.dart';

abstract class PengawasanRepository {
  Future<void> addPengawasan(RequestLaporanPengawasanEntity request);

  Future<List<LaporanPengawasanEntity>> getLaporanPengawasan();
}
