import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_op_response_model.freezed.dart';
part 'dashboard_op_response_model.g.dart';

@freezed
class DashboardOpResponseModel with _$DashboardOpResponseModel {
  const factory DashboardOpResponseModel({
    required String nop,
    required String namaOp,
    required int uptbId,
    required bool isDigital,

    required int pendapatanHariIniKotor,
    required int pendapatanHariIniBersihWajibPajak,
    required int pendapatanHariIniBersihBapenda,

    required int totalTransaksiRodaDua,
    required int totalTransaksiRodaEmpat,

    required RealisasiTahunIniModel realisasiTahunIni,

    required List<RiwayatPendapatanModel> riwayatList,
    required List<SofModel> sofList,
    @Default([]) List<AlatDigitalModel> alatDigitalList,
    TaxSurveillanceModel? taxSurveillance,
    required int tarifMotor,
    required int tarifMobil,
    required String jadwalOperasional,
  }) = _DashboardOpResponseModel;

  factory DashboardOpResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardOpResponseModelFromJson(json);
}

@freezed
class RealisasiTahunIniModel with _$RealisasiTahunIniModel {
  const factory RealisasiTahunIniModel({
    required int nonDigital,
    required int digital,
    required int realisasi,
  }) = _RealisasiTahunIniModel;

  factory RealisasiTahunIniModel.fromJson(Map<String, dynamic> json) =>
      _$RealisasiTahunIniModelFromJson(json);
}

@freezed
class RiwayatPendapatanModel with _$RiwayatPendapatanModel {
  const factory RiwayatPendapatanModel({
    required String jenisKendaraan,
    required String tgl,
    required int kredit,
  }) = _RiwayatPendapatanModel;

  factory RiwayatPendapatanModel.fromJson(Map<String, dynamic> json) =>
      _$RiwayatPendapatanModelFromJson(json);
}

@freezed
class SofModel with _$SofModel {
  const factory SofModel({
    required String sof,

    required int nominalMotor,
    required int nominalMobil,

    required int nominalBersihUntukWajibPajakMotor,
    required int nominalBersihUntukWajibPajakMobil,

    required int nominalBersihUntukBapendaMotor,
    required int nominalBersihUntukBapendaMobil,

    required int jumlahMotor,
    required int jumlahMobil,
  }) = _SofModel;

  factory SofModel.fromJson(Map<String, dynamic> json) =>
      _$SofModelFromJson(json);
}

@freezed
class AlatDigitalModel with _$AlatDigitalModel {
  const factory AlatDigitalModel({required String nama, required bool status}) =
      _AlatDigitalModel;

  factory AlatDigitalModel.fromJson(Map<String, dynamic> json) =>
      _$AlatDigitalModelFromJson(json);
}

@freezed
class TaxSurveillanceModel with _$TaxSurveillanceModel {
  const factory TaxSurveillanceModel({
    required String bulan,
    required String totalRealisasiMotor,
    required String totalRealisasiMobil,
    required String totalRealisasiBulan,
  }) = _TaxSurveillanceModel;

  factory TaxSurveillanceModel.fromJson(Map<String, dynamic> json) =>
      _$TaxSurveillanceModelFromJson(json);
}
