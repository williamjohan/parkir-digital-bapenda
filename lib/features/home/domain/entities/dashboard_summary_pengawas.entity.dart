import 'package:equatable/equatable.dart';

class DashboardSummaryPengawasEntity extends Equatable {
  final bool isSuccess;
  final int statusCode;
  final String message;
  final DashboardDataEntity data;

  const DashboardSummaryPengawasEntity({
    required this.isSuccess,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  @override
  List<Object?> get props => [isSuccess, statusCode, message, data];
}

class DashboardDataEntity extends Equatable {
  final int laporanPelanggaran;
  final DashboardInfoEntity dashboard;
  final CheckInOutEntity checkInOut;

  const DashboardDataEntity({
    required this.laporanPelanggaran,
    required this.dashboard,
    required this.checkInOut,
  });

  @override
  List<Object?> get props => [laporanPelanggaran, dashboard, checkInOut];
}

class DashboardInfoEntity extends Equatable {
  final int jumlahMotorHariIni;
  final int jumlahMobilHariIni;
  final int totalNominalHariIni;
  final int totalNominalBersihUntukWajibPajak;
  final int totalNominalBersihUntukBapenda;

  const DashboardInfoEntity({
    required this.jumlahMotorHariIni,
    required this.jumlahMobilHariIni,
    required this.totalNominalHariIni,
    required this.totalNominalBersihUntukWajibPajak,
    required this.totalNominalBersihUntukBapenda,
  });

  @override
  List<Object?> get props => [
    jumlahMotorHariIni,
    jumlahMobilHariIni,
    totalNominalHariIni,
    totalNominalBersihUntukWajibPajak,
    totalNominalBersihUntukBapenda,
  ];
}

class CheckInOutEntity extends Equatable {
  final int idEvent;
  final String op;
  final String nip;
  final String tglRoster;
  final String jadwalMasuk;
  final String jadwalOut;
  final int status;
  final String checkIn;
  final String checkInString;
  final int checkInJmlMobil;
  final int checkInJmlMotor;
  final String checkOut;
  final String checkOutString;
  final int checkOutJmlMobil;
  final int checkOutJmlMotor;
  final String latitude;
  final String longitude;
  final List<DetailAlatEntity> detailAlatCheckIn;
  final List<DetailAlatEntity> detailAlatCheckOut;

  const CheckInOutEntity({
    required this.idEvent,
    required this.op,
    required this.nip,
    required this.tglRoster,
    required this.jadwalMasuk,
    required this.jadwalOut,
    required this.status,
    required this.checkIn,
    required this.checkInString,
    required this.checkInJmlMobil,
    required this.checkInJmlMotor,
    required this.checkOut,
    required this.checkOutString,
    required this.checkOutJmlMobil,
    required this.checkOutJmlMotor,
    required this.latitude,
    required this.longitude,
    required this.detailAlatCheckIn,
    required this.detailAlatCheckOut,
  });

  bool get hasJadwal => status != 0 ;

  @override
  List<Object?> get props => [
    idEvent,
    op,
    nip,
    tglRoster,
    jadwalMasuk,
    jadwalOut,
    status,
    checkIn,
    checkInString,
    checkInJmlMobil,
    checkInJmlMotor,
    checkOut,
    checkOutString,
    checkOutJmlMobil,
    checkOutJmlMotor,
    latitude,
    longitude,
    detailAlatCheckIn,
    detailAlatCheckOut,
  ];
}

class DetailAlatEntity extends Equatable {
  final int id;
  final String namaAlat;
  final bool isBawa;

  const DetailAlatEntity({
    required this.id,
    required this.namaAlat,
    required this.isBawa,
  });

  @override
  List<Object?> get props => [id, namaAlat, isBawa];
}
