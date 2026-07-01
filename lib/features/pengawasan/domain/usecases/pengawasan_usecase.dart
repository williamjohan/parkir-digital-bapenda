import 'package:injectable/injectable.dart';
import '../entities/laporan_pengawasan/laporan_pengawasan_entity.dart';
import '../entities/request_laporan_pengawasan_entity/request_laporan_pengawasan_entity.dart';
import '../repositories/i_pengawasan_repository.dart';

@LazySingleton()
class AddPengawasanUsecase {
  final PengawasanRepository _repository;

  AddPengawasanUsecase(this._repository);

  Future<void> call( RequestLaporanPengawasanEntity request,) {
    return _repository.addPengawasan(request);
  }
}

@LazySingleton()
class GetLaporanPengawasanUsecase {
  final PengawasanRepository _repository;

  GetLaporanPengawasanUsecase(this._repository);

  Future<List<LaporanPengawasanEntity>> call() {
    return _repository.getLaporanPengawasan();
  }
}