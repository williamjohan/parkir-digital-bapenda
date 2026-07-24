class ApiEndpoints {
  ApiEndpoints._();
  static const String login = '/api/mobile/parking/login';

  static const String refreshAccessToken =
      '/api/mobile/parking/generate-access-token';
  static const String logout = '/api/mobile/parking/logout';
  static const String profile = '/api/mobile/parking/profile';
  static const String changePassword = '/api/mobile/parking/change-password';
  static const String tarif = '/api/mobile/parking/tarif';
  static const String dashboardSummary =
      '/api/mobile/parking/dashboard-summary';

  static const String weeklyChart = '/api/mobile/parking/weekly-chart';
  static const String laporanPendapatan =
      '/api/mobile/parking/laporan-pendapatan';
  static const String generateQris = '/api/mobile/parking/generate-qris';
  static const String callBack = '/api/mobile/parking/callback-qris';
  static const String cekUuid = '/api/mobile/parking/check-device-uuid';

  ////////////DEV////////////
  static const String loginDev = '/api/mobile/parking/login-dev';
  static const String profileDev = '/api/mobile/parking/profile-dev';
  static const String profilePhoto = '/api/mobile/parking/profile-picture';
  static const String dashboardSummaryDev =
      '/api/mobile/parking/dashboard-summary-dev';
  static const String dashboardSummaryNonJukirDev =
      '/api/mobile/parking/dashboard-summary-nonjukir-dev';
  static const String weeklyChartDev = '/api/mobile/parking/weekly-chart-dev';
  static const String cekUuidDev = '/api/mobile/parking/check-device-uuid-dev';
  static const String laporanPendapatanDev =
      '/api/mobile/parking/laporan-pendapatan-dev';
  static const String dataJukirDev = '/api/mobile/parking/get-data-jukir-dev';

  //QRIS
  static const String qrisRompiDev = '/api/mobile/parking/get-qris-rompi-dev';
  static const String qrisCheckVersionDev =
      '/api/mobile/parking/get-qris-last-update';

  static const String summaryOpDev = '/api/mobile/parking/get-summary-op-dev';
  static const String summaryRealiasiOpDev =
      '/api/mobile/parking/get-summary-op-realisasi-dev';
  static const String summaryRangeDev =
      '/api/mobile/parking/dashboard-summary-nonjukir-range-dev';
  static const String summaryRealisasiDev =
      '/api/mobile/parking/dashboard-summary-nonjukir-realisasi-dev';
  static const String listNopDev = '/api/mobile/parking/nop-list-dev';
  static const String pengawasLaporanList =
      '/api/mobile/parking/pengawas-pelaporan-list';
  // static const String addPengawasanPelaporanDev =
  //     '/api/mobile/parking/pengawas-pelaporan';
  static const String addPengawasanPelaporanDev =
      '/api/mobile/parking/pengawas-pelaporan-sp3';
  static const String pengawasCheckIn =
      '/api/mobile/parking/pengawas-check-in-sp3';
  static const String pengawasCheckOut =
      '/api/mobile/parking/pengawas-check-out-sp3';
  static const String pengawasMasterAlatDigital =
      '/api/mobile/parking/pengawas-master-alat-digital';
  static const String jadwalPengawasDev = '/api/mobile/parking/pengawas-jadwal';
  static const String pengawasPelaporanListDev =
      '/api/mobile/parking/pengawas-pelaporan-list';
  static const String pengawasDashboardRosterSummaryDev =
      '/api/mobile/parking/pengawas-roster-summary-sp3';
  static const String laporanPendapatanSof =
      '/api/mobile/parking/laporan-pendapatan-sof-dev';

  static const String opLastUpdate = '/api/mobile/parking/get-op-last-update';
  static const String taxSurveillanceDetail = '';

  static const String opPengawasList = '/api/mobile/parking/op-pengawas-list';
  static const String jenisPelanggaran =
      '/api/mobile/parking/pengawas-master-jenis-pelanggaran';
}
