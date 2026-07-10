import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_op_entity.freezed.dart';

@freezed
class DashboardOpEntity with _$DashboardOpEntity {
  const factory DashboardOpEntity({
    required String nop,
    required String namaOp,
    required int uptbId,
    required bool isDigital,

    required int pendapatanHariIniKotor,
    required int pendapatanHariIniBersihWajibPajak,
    required int pendapatanHariIniBersihBapenda,

    required int totalTransaksiRodaDua,
    required int totalTransaksiRodaEmpat,

    required RealisasiTahunIniEntity realisasiTahunIni,

    required List<RiwayatPendapatanEntity> riwayatList,
    required List<SofEntity> sofList,

    required int tarifMotor,
    required int tarifMobil,
    required String jadwalOperasional,
  }) = _DashboardOpEntity;
}

@freezed
class RealisasiTahunIniEntity with _$RealisasiTahunIniEntity {
  const factory RealisasiTahunIniEntity({
    required int nonDigital,
    required int digital,
    required int realisasi,
  }) = _RealisasiTahunIniEntity;
}

@freezed
class RiwayatPendapatanEntity with _$RiwayatPendapatanEntity {
  const factory RiwayatPendapatanEntity({
    required String jenisKendaraan,
    required String tgl,
    required int kredit,
  }) = _RiwayatPendapatanEntity;
}

@freezed
class SofEntity with _$SofEntity {
  const factory SofEntity({
    required String sof,

    required int nominalMotor,
    required int nominalMobil,

    required int nominalBersihUntukWajibPajakMotor,
    required int nominalBersihUntukWajibPajakMobil,

    required int nominalBersihUntukBapendaMotor,
    required int nominalBersihUntukBapendaMobil,

    required int jumlahMotor,
    required int jumlahMobil,
  }) = _SofEntity;
}
