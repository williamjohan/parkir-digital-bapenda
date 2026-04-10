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

  // 🚀 [BARU] Endpoint khusus Modul Dashboard & Master Data
  static const String tarif = '/api/mobile/parking/tarif';
  static const String dashboardSummary =
      '/api/mobile/parking/dashboard-summary';
  static const String weeklyChart = '/api/mobile/parking/weekly-chart';
  static const String laporanPendapatan =
      '/api/mobile/parking/laporan-pendapatan';
}
