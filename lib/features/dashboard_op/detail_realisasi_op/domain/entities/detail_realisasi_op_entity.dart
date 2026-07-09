import 'package:freezed_annotation/freezed_annotation.dart';

part 'detail_realisasi_op_entity.freezed.dart';

@freezed
class DetailRealisasiOpEntity with _$DetailRealisasiOpEntity {
  const factory DetailRealisasiOpEntity({
    required String nop,
    required String namaOp,
    required int uptbId,
    required int tahun,
    required bool isDigital,
    required String tglDigitalisasi,
    required double nominalNonDigital,
    required double nominalDigital,
    required double totalNominal,
    @Default([]) List<RealisasiPerBulanEntity> realisasiPerBulan,
  }) = _DetailRealisasiOpEntity;
}

@freezed
class RealisasiPerBulanEntity with _$RealisasiPerBulanEntity {
  const factory RealisasiPerBulanEntity({
    required int bulan,
    required String bulanNama,
    required String tglSspd,
    required double nominalNonDigital,
    required double nominalDigital,
    required double totalNominal,
  }) = _RealisasiPerBulanEntity;
}
