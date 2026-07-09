import '../../domain/entities/daftar_nop_entity.dart';
import '../models/daftar_nop_model.dart';

extension DaftarNopModelMapper on DaftarNopModel {
  DaftarNopEntity toEntity() {
    return DaftarNopEntity(
      nop: nop,
      namaOp: namaOp,
      alamatOp: alamatOp,
      isDigital: isDigital,
      pungutTarif: pungutTarif,
      uptb: uptb,
      totalPendapatan: totalPendapatan,
      kdCamat: kdCamat,
      nmCamat: nmCamat,
      kdLurah: kdLurah,
      nmLurah: nmLurah,
    );
  }
}

extension DaftarNopEntityMapper on DaftarNopEntity {
  Map<String, dynamic> toDbMap() {
    return {
      'nop': nop,
      'nama_op': namaOp,
      'alamat_op': alamatOp,
      'is_digital': isDigital ? 1 : 0,
      'pungut_tarif': pungutTarif,
      'uptb': uptb,
      'kdCamat': kdCamat,
      'nmCamat': nmCamat,
      'kdLurah': kdLurah,
      'nmLurah': nmLurah,
    };
  }
}
