import '../../domain/entities/realisasi_entity.dart';
import '../models/realisasi_model.dart';

extension RealisasiPajakModelMapper on RealisasiModel {
  RealisasiEntity toEntity() {
    return RealisasiEntity(
      enumPajak: enumPajak ?? 0,
      jenisPajak: jenisPajak ?? '',
      tahun: tahun ?? DateTime.now().year,
      bulan: bulan ?? 1,
      bulanNama: bulanNama ?? '',
      akpTarget: akpTarget?.toDouble() ?? 0.0,
      realisasi: realisasi?.toDouble() ?? 0.0,
      pencapaian: pencapaian?.toDouble() ?? 0.0,
      selisih: selisih?.toDouble() ?? 0.0,
    );
  }
}

// Helper untuk mapping List
extension RealisasiPajakListMapper on List<RealisasiModel> {
  List<RealisasiEntity> toEntityList() {
    return map((model) => model.toEntity()).toList();
  }
}
