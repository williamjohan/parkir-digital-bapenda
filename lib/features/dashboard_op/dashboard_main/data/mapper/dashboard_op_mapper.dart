import 'package:parkir_digital_bapenda/features/dashboard_op/dashboard_main/data/models/dashboard_op_response_model.dart';
import 'package:parkir_digital_bapenda/features/dashboard_op/dashboard_main/domain/entities/dashboard_op_entity.dart';

class DashboardOpMapper {
  static DashboardOpEntity toEntity(DashboardOpResponseModel model) {
    return DashboardOpEntity(
      nop: model.nop,
      namaOp: model.namaOp,
      uptbId: model.uptbId,
      isDigital: model.isDigital,

      pendapatanHariIniKotor: model.pendapatanHariIniKotor,
      pendapatanHariIniBersihWajibPajak:
          model.pendapatanHariIniBersihWajibPajak,
      pendapatanHariIniBersihBapenda: model.pendapatanHariIniBersihBapenda,

      totalTransaksiRodaDua: model.totalTransaksiRodaDua,
      totalTransaksiRodaEmpat: model.totalTransaksiRodaEmpat,

      realisasiTahunIni: RealisasiTahunIniEntity(
        nonDigital: model.realisasiTahunIni.nonDigital,
        digital: model.realisasiTahunIni.digital,
        realisasi: model.realisasiTahunIni.realisasi,
      ),

      riwayatList: model.riwayatList
          .map(
            (e) => RiwayatPendapatanEntity(
              jenisKendaraan: e.jenisKendaraan,
              tgl: e.tgl,
              kredit: e.kredit,
            ),
          )
          .toList(),

      sofList: model.sofList
          .map(
            (e) => SofEntity(
              sof: e.sof,
              nominalMotor: e.nominalMotor,
              nominalMobil: e.nominalMobil,
              nominalBersihUntukWajibPajakMotor:
                  e.nominalBersihUntukWajibPajakMotor,
              nominalBersihUntukWajibPajakMobil:
                  e.nominalBersihUntukWajibPajakMobil,
              nominalBersihUntukBapendaMotor: e.nominalBersihUntukBapendaMotor,
              nominalBersihUntukBapendaMobil: e.nominalBersihUntukBapendaMobil,
              jumlahMotor: e.jumlahMotor,
              jumlahMobil: e.jumlahMobil,
            ),
          )
          .toList(),
    );
  }
}
