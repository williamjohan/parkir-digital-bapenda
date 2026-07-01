class JadwalDummyModel {
  final DateTime tanggal;
  final String hari;
  final String jamMasuk;
  final String jamPulang;
  final String? checkIn;
  final String? checkOut;
  final bool isLibur;
  final String? keteranganLibur;

  JadwalDummyModel({
    required this.tanggal,
    required this.hari,
    this.jamMasuk = '06:00',
    this.jamPulang = '14:00',
    this.checkIn,
    this.checkOut,
    this.isLibur = false,
    this.keteranganLibur,
  });
}
