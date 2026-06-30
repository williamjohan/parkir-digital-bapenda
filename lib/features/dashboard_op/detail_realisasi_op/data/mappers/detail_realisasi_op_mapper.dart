import '../../domain/entities/detail_realisasi_op_entity.dart';
import '../model/detail_realisasi_op_model.dart';

extension DetailRealisasiOpModelMapper on DetailRealisasiOpModel {
  DetailRealisasiOpEntity toEntity() {
    return DetailRealisasiOpEntity(
      nop: nop ?? '',
      namaOp: namaOp ?? '-',
      uptbId: uptbId ?? 0,
      tahun: tahun ?? 0,
      isDigital: isDigital ?? false,
      tglDigitalisasi: tglDigitalisasi ?? '',
      nominalNonDigital: nominalNonDigital ?? 0.0,
      nominalDigital: nominalDigital ?? 0.0,
      totalNominal: totalNominal ?? 0.0,
      realisasiPerBulan:
          realisasiPerBulan?.map((e) => e.toEntity()).toList() ?? [],
    );
  }
}

extension RealisasiPerBulanModelMapper on RealisasiPerBulanModel {
  RealisasiPerBulanEntity toEntity() {
    return RealisasiPerBulanEntity(
      bulan: bulan ?? 0,
      bulanNama: bulanNama ?? '-',
      tglSspd: tglSspd ?? '-',
      nominalNonDigital: nominalNonDigital ?? 0.0,
      nominalDigital: nominalDigital ?? 0.0,
      totalNominal: totalNominal ?? 0.0,
    );
  }
}
