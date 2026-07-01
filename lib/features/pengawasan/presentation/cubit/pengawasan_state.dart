import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/jenis_pelanggaran/jenis_pelanggaran_entity.dart';
import '../../domain/entities/request_laporan_pengawasan_entity/request_laporan_pengawasan_entity.dart';

part 'pengawasan_state.freezed.dart';

@freezed
class PengawasanState with _$PengawasanState {
  const factory PengawasanState({
    @Default(RequestLaporanPengawasanEntity())
    RequestLaporanPengawasanEntity request,

    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    String? errorMessage,

    @Default([]) List<JenisPelanggaranEntity> jenisPelanggaran,
  }) = _PengawasanState;
}
