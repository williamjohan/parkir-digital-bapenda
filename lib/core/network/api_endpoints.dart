// lib/core/network/api_endpoints.dart

class ApiEndpoints {
  ApiEndpoints._();

  // Endpoint khusus Modul Auth (Sesuai Swagger Bapenda)
  static const String login = '/api/mobile/parking/login';

  static const String refreshToken =
      '/api/mobile/parking/generate-access-token';
  static const String logout = '/api/mobile/parking/logout';
  static const String profile = '/api/mobile/parking/profile';
  static const String changePassword = '/api/mobile/parking/change-password';

  // Endpoint khusus Modul Dashboard & Master Data
  static const String tarif = '/api/mobile/parking/tarif';
  static const String dashboardSummary =
      '/api/mobile/parking/dashboard-summary';
  // static const String dashboardSummaryNonJukir =
  //     '/api/mobile/parking/dashboard-summary-nonjukir';

  static const String weeklyChart = '/api/mobile/parking/weekly-chart';
  static const String laporanPendapatan =
      '/api/mobile/parking/laporan-pendapatan';
  static const String generateQris = '/api/mobile/parking/generate-qris';
  static const String callBack = '/api/mobile/parking/callback-qris';

  static const String cekUuid = '/api/mobile/parking/check-device-uuid';

  ////////////DEV////////////
  static const String loginDev = '/api/mobile/parking/login-dev';
  static const String profileDev = '/api/mobile/parking/profile-dev';
  static const String dashboardSummaryDev =
      '/api/mobile/parking/dashboard-summary-dev';
  static const String dashboardSummaryNonJukirDev =
      '/api/mobile/parking/dashboard-summary-nonjukir-dev';
  static const String weeklyChartDev = '/api/mobile/parking/weekly-chart-dev';
  static const String cekUuidDev = '/api/mobile/parking/check-device-uuid-dev';
  static const String laporanPendapatanDev =
      '/api/mobile/parking/laporan-pendapatan-dev';
}
