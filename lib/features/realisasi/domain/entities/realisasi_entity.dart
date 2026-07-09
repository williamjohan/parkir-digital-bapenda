import 'package:freezed_annotation/freezed_annotation.dart';

part 'realisasi_entity.freezed.dart';

@freezed
class RealisasiEntity with _$RealisasiEntity {
  const factory RealisasiEntity({
    required int enumPajak,
    required String jenisPajak,
    required int tahun,
    required int bulan,
    required String bulanNama,
    required double akpTarget,
    required double realisasi,
    required double pencapaian,
    required double selisih,
  }) = _RealisasiEntity;
}
