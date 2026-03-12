class ApiEndpoints {
  ApiEndpoints._();

  // Endpoint khusus Modul Auth (Sesuai Swagger Bapenda)
  static const String login = '/api/mobile/parking/login';
  static const String refreshToken =
      '/api/mobile/parking/generate-access-token';
  static const String logout = '/api/mobile/parking/logout';
  static const String profile = '/api/mobile/parking/profile';
  static const String changePassword = '/api/mobile/parking/change-password';

  // Endpoint khusus Modul Kendaraan (Biarkan dulu, nanti disesuaikan dengan Swagger)
  static const String submitPlate = '/vehicle/submit';
  static const String getHistory = '/vehicle/history';
}
