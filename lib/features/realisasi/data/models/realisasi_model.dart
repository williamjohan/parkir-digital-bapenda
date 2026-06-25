import 'package:freezed_annotation/freezed_annotation.dart';

part 'realisasi_model.freezed.dart';
part 'realisasi_model.g.dart';

@freezed
class RealisasiModel with _$RealisasiModel {
  const factory RealisasiModel({
    int? enumPajak,
    String? jenisPajak,
    int? tahun,
    int? bulan,
    String? bulanNama,
    num? akpTarget,
    num? realisasi,
    num? pencapaian,
    num? selisih,
  }) = _RealisasiModel;

  factory RealisasiModel.fromJson(Map<String, dynamic> json) =>
      _$RealisasiModelFromJson(json);
}
