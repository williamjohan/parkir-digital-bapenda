import 'package:injectable/injectable.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/storage/app_preferences.dart';
import '../../domain/entities/jenis_pelanggaran/jenis_pelanggaran_entity.dart';
import '../../domain/entities/laporan_pengawasan/laporan_pengawasan_entity.dart';
import '../../domain/entities/request_laporan_pengawasan_entity/request_laporan_pengawasan_entity.dart';
import '../../domain/repositories/i_pengawasan_repository.dart';
import '../datasources/pengawasan_datasource.dart';
import '../mapper/laporan_pengawasan_mapper.dart';
import '../models/jenis_pelanggaran/jenis_pelanggaran_model.dart';

@LazySingleton(as: PengawasanRepository)
class PengawasanRepositoryImpl implements PengawasanRepository {
  final PengawasanDatasource _datasource;
  final AppPreferences _appPreferences;

  PengawasanRepositoryImpl(this._datasource, this._appPreferences);

  @override
  Future<void> addPengawasan(RequestLaporanPengawasanEntity request) async {
    final nomorObjek = _appPreferences.getNomorObjekPengawasan();
    final shift = _appPreferences.getShiftObjekPengawasan();
    final jenis = _appPreferences.getJenisObjekPengawasan();

    // Validasi data yang wajib tersedia
    if (nomorObjek == null || nomorObjek.isEmpty) {
      throw const ServerException(
        statusCode: 400,
        message: 'Nomor objek pengawasan belum dipilih.',
      );
    }

    if (shift == null) {
      throw const ServerException(
        statusCode: 400,
        message: 'Shift pengawasan belum dipilih.',
      );
    }

    if (jenis == null) {
      throw const ServerException(
        statusCode: 400,
        message: 'Jenis objek pengawasan belum dipilih.',
      );
    }

    final finalRequest = request.copyWith(
      nomorObjek: nomorObjek,
      shift: shift.id,
      jenis: jenis.id,
    );

    await _datasource.addPengawasan(finalRequest);
  }

  @override
  Future<List<LaporanPengawasanEntity>> getLaporanPengawasan() async {
    final models = await _datasource.getLaporanPengawasan();

    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<JenisPelanggaranEntity>> getJenisPelanggaran() async {
    final result = await _datasource.getJenisPelanggaran();

    final jenisPengawasan = _appPreferences.getJenisObjekPengawasan();

    if (jenisPengawasan == null) {
      return result.map((e) => e.toEntity()).toList();
    }

    return result
        .where((e) => e.jenis == jenisPengawasan.id)
        .map((e) => e.toEntity())
        .toList();
  }
}
