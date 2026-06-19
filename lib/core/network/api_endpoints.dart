// lib/core/network/api_endpoints.dart

class ApiEndpoints {
  ApiEndpoints._();

  // Endpoint khusus Modul Auth (Sesuai Swagger Bapenda)
  static const String login = '/api/mobile/parking/login-dev';
  static const String refreshToken =
      '/api/mobile/parking/generate-access-token';
  static const String logout = '/api/mobile/parking/logout';
  static const String profile = '/api/mobile/parking/profile-dev';
  static const String changePassword = '/api/mobile/parking/change-password';

  // Endpoint khusus Modul Dashboard & Master Data
  static const String tarif = '/api/mobile/parking/tarif';
  static const String dashboardSummary =
      '/api/mobile/parking/dashboard-summary-dev';
  static const String dashboardSummaryNonJukir =
      '/api/mobile/parking/dashboard-summary-nonjukir-dev';

  static const String weeklyChart = '/api/mobile/parking/weekly-chart-dev';
  static const String laporanPendapatan =
      '/api/mobile/parking/laporan-pendapatan';
  static const String generateQris = '/api/mobile/parking/generate-qris';
  static const String callBack = '/api/mobile/parking/callback-qris';

  static const String cekUuid = '/api/mobile/parking/check-device-uuid-dev';
}
